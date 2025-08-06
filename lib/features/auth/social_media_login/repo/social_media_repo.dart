import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wow/features/auth/social_media_login/model/social_media_model.dart';
import '../../../../app/core/app_storage_keys.dart';
import '../../../../data/api/end_points.dart';
import '../../../../data/error/api_error_handler.dart';
import '../../../../data/error/failures.dart';
import '../../../../helpers/social_media_login_helper.dart';
import '../../../../main_repos/base_repo.dart';

class SocialMediaRepo extends BaseRepo {
  SocialMediaRepo(
      {required this.socialMediaLoginHelper,
      required super.sharedPreferences,
      required super.dioClient});

  final SocialMediaLoginHelper socialMediaLoginHelper;

  saveUserData(json) {
    subscribeToTopic(id: "wow", );
    sharedPreferences.setString(AppStorageKey.userId, json["id"].toString());
    sharedPreferences.setString(AppStorageKey.userData, jsonEncode(json));
    sharedPreferences.setBool(AppStorageKey.isLogin, true);
  }

  saveUserToken(token) {
    sharedPreferences.setString(AppStorageKey.token, token);
    dioClient.updateHeader(token);
  }

  Future subscribeToTopic(
      {required String id,}) async {
    FirebaseMessaging.instance
        .subscribeToTopic(EndPoints.specificTopic(id))
        .then((v) async {
      await sharedPreferences.setBool(AppStorageKey.isSubscribe, true);
    });
  }

  Future<Either<ServerFailure, Response>> signInWithSocialMedia(
      SocialMediaProvider provider) async {

    try {
      Either<ServerFailure, SocialMediaModel>? socialResponse;
      if (provider == SocialMediaProvider.google) {
        socialResponse = await socialMediaLoginHelper.googleLogin();
      }

      if (provider == SocialMediaProvider.facebook) {
        socialResponse = await socialMediaLoginHelper.facebookLogin();
      }

      if (provider == SocialMediaProvider.apple) {
        socialResponse = await socialMediaLoginHelper.appleLogin();
      }

      return socialResponse!.fold((fail) {
        return left(fail);
      }, (success) async {
        Response response = await dioClient.get(
            uri: EndPoints.socialMediaAuth,

            queryParameters: await success.toJson());
        print(" response socialResponse $response");

        if (response.statusCode == 200) {
          saveUserToken(response.data["data"]["access_token"]);
          saveUserData(response.data["data"]["client"]);
          return Right(response);
        } else {
          print(" socialResponse errorr${response.data['message']}");

          return left(
              ServerFailure(response.data['message']));
        }
      });
    } catch (error) {
      print("errorr$error");
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }
}
