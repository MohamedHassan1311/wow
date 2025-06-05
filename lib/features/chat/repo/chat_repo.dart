import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';
import '../../../main_repos/base_repo.dart';
class ChatRepo extends BaseRepo {
  ChatRepo({required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> getAllChats() async {
    try {
      Response response = await dioClient.get(uri: EndPoints.chatMessages(userId));
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
        return left(ApiErrorHandler.getServerFailure(error));
    }
  }  Future<Either<ServerFailure, Response>> getChatDetails(id) async {
    try {
      Response response = await dioClient.get(uri: EndPoints.chatMessages(id));
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
        return left(ApiErrorHandler.getServerFailure(error));
    }
  }

  Future<Either<ServerFailure, Response>> uploadFile(String filePath) async {
    try {
      print("filePathh $filePath");
      Response response = await dioClient.post(
        uri: EndPoints.uploadFile,
        data: FormData.fromMap({
          "photo": MultipartFile.fromFileSync(filePath ),
        }),
      );
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
        return left(ApiErrorHandler.getServerFailure(error));
    }
  }

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<Either<ServerFailure, String>> sendMessage(
      {required String message,
         String? photo,
        required String receiverId,
        required String convId}) async {
    try {
      print(convId);
      await ref.child("messages").child(convId).push().set({
        "conv_id": convId,
        "sender_id": userId,
        "message": message,
        "receiver_id": receiverId,
        "type": 'patient',
        "read": false,
        "photo": photo??"",
        "created_at": DateTime.now().toString(),
      }).then((dx){
        print(" ");});
      sendNotifi(convId: convId,userid: receiverId);
      return Right("success");
    } catch (e) {
      print(e);
        return left(ApiErrorHandler.getServerFailure(e));
    }
  }
  Future<Either<ServerFailure, Response>> sendNotifi(
      {required String convId,required String userid}) async {
    try {

      Response response = await dioClient.post(
        uri: "${EndPoints.sendNotificationConversation}/$userid/$convId",

      );
      return Right(response);
    } catch (e) {
        return left(ApiErrorHandler.getServerFailure(e));
    }
  }

}

enum MessageType {
  text,
  image,
  audio,
  video,
  invitation,
  file,
}
