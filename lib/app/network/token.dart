import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TokenService {
  final Dio _dio;

  TokenService({required Dio dio}) : _dio = dio;

  void updateToken(String token) {
    _dio.options.headers["Authorization"] = 'Bearer $token';
    debugPrint(token);
    // Singleton().token = token;
  }
}
