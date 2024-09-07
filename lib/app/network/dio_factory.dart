import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/app_prefs.dart';
import '../../app/constants.dart';

const String APPLICATION_JSON = 'application/json';
const String CONTENT_TYPE = 'content-type';
const String ACCEPT = 'accept';
const String AUTHORIZATION = 'authorization';
const String DEFAULT_LANGUAGE = 'language';

class DioFactory {
  final AppPreferences _appPreferences;

  DioFactory(this._appPreferences);

  Dio? dio;
  bool isTokenRefreshDialogOpen = false;
  String? refreshTokenInProgress;

  Future<Dio> getDio() async {
    dio = Dio();

    Map<String, String> header = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: Constants.apiToken, //todo here send user token
    };
    dio!.options = BaseOptions(
      baseUrl: Constants.baseUrl,
      headers: header,
      sendTimeout: Duration(milliseconds: Constants.apiTimeout),
      receiveTimeout: Duration(milliseconds: Constants.apiTimeout),
    );

    dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        return handler.next(options);
      },
      onResponse: (e, handler) {
        return handler.next(e);
      },
      onError: (error, handler) async {
        return handler.next(error);
      },
    ));
    //this to show log for request in debug mode

    if (!kReleaseMode) {
      dio!.interceptors.add(PrettyDioLogger(
          requestHeader: true, requestBody: true, responseHeader: true));

      // Disable certificate validation (not recommended for production)
      (dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return null;
      };
    }
    return dio!;
  }

  //cache token and refresh token every 25 minutes

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    isTokenRefreshDialogOpen = false;
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio!.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> refreshToken() async {
    bool value = false;

    return value;
  }

  int getTime(token) {
    if (token != null && token.toString().isNotEmpty) {
      Map<String, dynamic> payload = Jwt.parseJwt(token);

      // how to parsing from double to int

      int exp = payload['exp'].round();
      DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);

      // return expirationDate.millisecondsSinceEpoch;

      DateTime currentDateTime = DateTime.now();

      Duration remainingTime = expirationDate.difference(currentDateTime);
      int remainingMinutes = remainingTime.inMinutes;

      if (remainingMinutes <= Constants.tokenRefreshThreshold) {
        isTokenRefreshDialogOpen = false;
      }

      return remainingMinutes;
      // return 3;
    } else {
      return 0;
    }
  }
}
