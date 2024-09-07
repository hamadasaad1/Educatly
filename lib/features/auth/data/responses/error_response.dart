// To parse this JSON data, do
//
//     final errorResponse = errorResponseFromMap(jsonString);

import 'dart:convert';

ErrorResponse errorResponseFromMap(String str) =>
    ErrorResponse.fromMap(json.decode(str));

class ErrorResponse {
  bool? status;
  String? message;
  Map<String, dynamic>? errors;

  ErrorResponse({
    this.status,
    this.errors,
    this.message,
  });

  factory ErrorResponse.fromMap(Map<String, dynamic> json) => ErrorResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? '',
        errors: json["errors"] is Map ? json["errors"] ?? {} : {},
      );
}
