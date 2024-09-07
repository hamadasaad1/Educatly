import 'package:equatable/equatable.dart';
import 'package:template/app/error/error_handler.dart';

/// Failure is a class that has a code and a message.
class Failure extends Equatable {
  int code;
  String message;

  Failure({
    required this.code,
    required this.message,
  });

  @override
  List<Object?> get props => [];
}

class FirebaseFailure extends Failure {
  FirebaseFailure({required int code, required String message})
      : super(code: code, message: message);
}

class FirebaseAuthFailure extends FirebaseFailure {
  FirebaseAuthFailure(String message)
      : super(code: ResponseCode.FIREBASE_AUTH_ERROR, message: message);
}

class FirestoreFailure extends FirebaseFailure {
  FirestoreFailure(String message)
      : super(code: ResponseCode.FIREBASE_FIRESTORE_ERROR, message: message);
}

class FirebaseStorageFailure extends FirebaseFailure {
  FirebaseStorageFailure(String message)
      : super(code: ResponseCode.FIREBASE_STORAGE_ERROR, message: message);
}
