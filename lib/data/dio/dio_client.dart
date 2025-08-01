import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/core/app_storage_keys.dart';
import '../api/end_points.dart';
import 'api_client.dart';
import 'logging_interceptor.dart';

class DioClient extends ApiClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;

  final Dio dio;

  DioClient(
    this.baseUrl, {
    required this.dio,
    required this.loggingInterceptor,
    required this.sharedPreferences,
  }) {
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 60)
      ..options.receiveTimeout = const Duration(seconds: 60)
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": " application/json",
        'x-api-key': EndPoints.apiKey,
        "Accept-Language":
            sharedPreferences.getString(AppStorageKey.languageCode) ?? "ar",
        if (sharedPreferences.getString(AppStorageKey.token) != null)
          'Authorization':
              "Bearer ${sharedPreferences.getString(AppStorageKey.token)}",
        if (sharedPreferences.getString(AppStorageKey.token) != null)
          'user-id':
          "${sharedPreferences.getString(AppStorageKey.userId)}",
      };
    dio.interceptors.add(PrettyDioLogger(
      request: true,
      responseBody: true,
      requestBody: true,
      requestHeader: true,
      enabled: kDebugMode,
    ));
  }

  Future<void> updateHeader(String? token, {String? lang}) async {
    dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": " application/json",
      'x-api-key': EndPoints.apiKey,
      "Accept-Language":
          sharedPreferences.getString(AppStorageKey.languageCode) ?? "ar",
      if (token != null) 'Authorization': "Bearer $token",
      if (token != null)        'user-id':
        "${sharedPreferences.getString(AppStorageKey.userId)}",
    };
  }

  Future<void> refreshHeader() async {
    dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": " application/json",
      'x-api-key': EndPoints.apiKey,
      "Accept-Language":
          sharedPreferences.getString(AppStorageKey.languageCode) ?? "ar",
      if (sharedPreferences.getString(AppStorageKey.token) != null)
        'Authorization':
            "Bearer ${sharedPreferences.getString(AppStorageKey.token)}",
      if (sharedPreferences.getString(AppStorageKey.token) != null)
        'user-id':
        "${sharedPreferences.getString(AppStorageKey.userId)}",
    };
  }

  ///Update Language in header
  updateLang(lang) {
    dio.options.headers = {
      if (sharedPreferences.getString(AppStorageKey.token) != null)
        'Authorization':
            "Bearer ${sharedPreferences.getString(AppStorageKey.token)}",
      if (sharedPreferences.getString(AppStorageKey.token) != null)
        'user-id':
        "${sharedPreferences.getString(AppStorageKey.userId)}",
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": " application/json",
      'x-api-key': EndPoints.apiKey,
      "Accept-Language": lang
    };
  }

  @override
  Future<Response> get({
    required String uri,
    bool useGoogleUri = false,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      if (useGoogleUri) {
        dio.options.baseUrl = EndPoints.googleMapsBaseUrl;
      } else {
        dio.options.baseUrl = baseUrl;
      }
      var response = await dio.get(uri, queryParameters: queryParameters);

      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future post(
      {required String uri,
      Map<String, dynamic>? queryParameters,
      Function(int, int)? onReceiveProgress,
      data,

      bool validateStatus =true
      }) async {
    try {
      dio.options.baseUrl = baseUrl;
      var response = await dio.post(
        uri,
        data: data,
        // options: Options(
        //   validateStatus: (_) => validateStatus, // يسمح لكل status code
        // ),
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {

      rethrow;
    }
  }

  @override
  Future put(
      {required String uri,
      Map<String, dynamic>? queryParameters,
      data}) async {
    try {
      dio.options.baseUrl = baseUrl;
      var response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future patch(
      {required String uri,
      Map<String, dynamic>? queryParameters,
      data}) async {
    try {
      dio.options.baseUrl = baseUrl;
      var response = await dio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future delete(
      {required String uri,
      Map<String, dynamic>? queryParameters,
      data}) async {
    try {
      dio.options.baseUrl = baseUrl;
      var response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}
