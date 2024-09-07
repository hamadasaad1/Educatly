// To parse this JSON data, do
//
//     final addBranchResponse = addBranchResponseFromMap(jsonString);

import 'dart:convert';

BaseResponse addBranchResponseFromMap(String str) =>
    BaseResponse.fromJson(json.decode(str));

String addBranchResponseToMap(BaseResponse data) => json.encode(data.toMap());

class BaseResponse {
  bool? status;
  String? message;
  int? id;
  int? code;

  BaseResponse({
    this.status,
    this.message,
    this.id,
    this.code,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        status: json["status"] ?? false,
        message: json["message"],
        id: json["id"],
        code: json["code"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
      };
}
