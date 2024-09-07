class BaseResponseEntity {
  bool status;
  String message;
  int id;
  int code;

  BaseResponseEntity({
    required this.status,
    required this.message,
    required this.id,
    required this.code,
  });
}
