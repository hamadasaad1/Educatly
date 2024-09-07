import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/auth/data/responses/error_response.dart';
import 'failure.dart';

/// It handles the error and returns a Failure object
class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _handleError(error);
    } else if (error is FirebaseAuthException) {
      failure = FirebaseAuthFailure(_mapFirebaseAuthError(error));
    } else if (error is FirebaseException) {
      failure = _handleFirebaseException(error);
    } else {
      failure = DataSource.DEFAULT.getFailure();
    }
  }

  Failure _handleFirebaseException(FirebaseException error) {
    switch (error.plugin) {
      case 'firebase_auth':
        return FirebaseAuthFailure(
            _mapFirebaseAuthError(error as FirebaseAuthException));
      case 'cloud_firestore':
        return FirestoreFailure(_mapFirestoreError(error));
      case 'firebase_storage':
        return FirebaseStorageFailure(error.message ?? ResponseMessage.DEFAULT);
      default:
        return FirebaseFailure(
            code: ResponseCode.DEFAULT, message: ResponseMessage.DEFAULT);
    }
  }

  String _mapFirebaseAuthError(FirebaseAuthException error) {
    if (error.message != null && error.message!.isNotEmpty) {
      return error.message!;
    }
    switch (error.code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'account-exists-with-different-credential':
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      default:
        return 'An unknown authentication error occurred.';
    }
  }

  String _mapFirestoreError(FirebaseException error) {
    if (error.message != null && error.message!.isNotEmpty) {
      return error.message!;
    }
    switch (error.code) {
      case 'permission-denied':
        return 'You do not have permission to access this resource.';
      case 'not-found':
        return 'The requested resource could not be found.';
      default:
        return 'An unknown Firestore error occurred.';
    }
  }

  Failure _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.CONNECT_TIMEOUT.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.SEND_TIMEOUT.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.RECEIVE_TIMEOUT.getFailure();
      case DioExceptionType.badResponse:
        return _getFailureFromResponse(response: error.response);
      case DioExceptionType.cancel:
        return DataSource.CANCEL.getFailure();
      case DioExceptionType.unknown:
        return DataSource.DEFAULT.getFailure();
      case DioExceptionType.badCertificate:
        return DataSource.DEFAULT.getFailure();

      case DioExceptionType.connectionError:
        return DataSource.NO_INTERNET_CONNECTION.getFailure();
      default:
        return DataSource.DEFAULT.getFailure();
    }
  }

  Failure _getFailureFromResponse({Response<dynamic>? response}) {
    try {
      if (response != null && response.statusCode != null) {
        if ((response.statusCode == 406 ||
                response.statusCode == 422 ||
                response.statusCode == 400 ||
                response.statusCode == 401) &&
            response.data.toString().contains('errors')) {
          ErrorResponse errorResponse = ErrorResponse.fromMap(response.data);
          List<String> messages = [];
          errorResponse.errors?.forEach((key, value) {
            List<String> errorMessages = List<String>.from(value);
            messages.add(errorMessages.first);
          });

          if (messages.isNotEmpty) {
            return Failure(
                code: response.statusCode ?? ResponseCode.DEFAULT,
                message: messages.join(', '));
          } else if (errorResponse.message != null &&
              errorResponse.message!.isNotEmpty) {
            return Failure(
                code: response.statusCode ?? ResponseCode.DEFAULT,
                message: errorResponse.message ?? ResponseMessage.DEFAULT);
          } else {
            return DataSource.DEFAULT.getFailure();
          }
        } else if (response.statusCode == 406 || response.statusCode == 422) {
          return Failure(
              code: response.statusCode ?? ResponseCode.DEFAULT,
              message: response.data?['message'] ?? ResponseMessage.DEFAULT);
        } else {
          return Failure(
              code: response.statusCode ?? ResponseCode.DEFAULT,
              message: response.statusMessage ?? ResponseMessage.DEFAULT);
        }
      } else {
        return DataSource.DEFAULT.getFailure();
      }
    } catch (e) {
      return DataSource.DEFAULT.getFailure();
    }
  }
}

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTHORIZED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECEIVE_TIMEOUT,
  SEND_TIMEOUT,
  CASH_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT,
}

/// An extension method.

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(
            code: ResponseCode.SUCCESS, message: ResponseMessage.SUCCESS);

      case DataSource.NO_CONTENT:
        return Failure(
            code: ResponseCode.NO_CONTENT, message: ResponseMessage.NO_CONTENT);

      case DataSource.BAD_REQUEST:
        return Failure(
            code: ResponseCode.BAD_REQUEST,
            message: ResponseMessage.BAD_REQUEST);
      case DataSource.FORBIDDEN:
        return Failure(
            code: ResponseCode.FORBIDDEN, message: ResponseMessage.FORBIDDEN);
      case DataSource.UNAUTHORIZED:
        return Failure(
            code: ResponseCode.UNAUTHORIZED,
            message: ResponseMessage.UNAUTHORIZED);
      case DataSource.NOT_FOUND:
        return Failure(
            code: ResponseCode.NOT_FOUND, message: ResponseMessage.NOT_FOUND);
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(
            code: ResponseCode.INTERNAL_SERVER_ERROR,
            message: ResponseMessage.INTERNAL_SERVER_ERROR);
      case DataSource.CONNECT_TIMEOUT:
        return Failure(
            code: ResponseCode.CONNECT_TIMEOUT,
            message: ResponseMessage.CONNECT_TIMEOUT);
      case DataSource.CANCEL:
        return Failure(
            code: ResponseCode.CANCEL, message: ResponseMessage.CANCEL);
      case DataSource.RECEIVE_TIMEOUT:
        return Failure(
            code: ResponseCode.RECEIVE_TIMEOUT,
            message: ResponseMessage.RECEIVE_TIMEOUT);
      case DataSource.SEND_TIMEOUT:
        return Failure(
            code: ResponseCode.SEND_TIMEOUT,
            message: ResponseMessage.SEND_TIMEOUT);
      case DataSource.CASH_ERROR:
        return Failure(
            code: ResponseCode.CASH_ERROR, message: ResponseMessage.CASH_ERROR);
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(
            code: ResponseCode.NO_INTERNET_CONNECTION,
            message: ResponseMessage.NO_INTERNET_CONNECTION);
      case DataSource.DEFAULT:
        return Failure(
            code: ResponseCode.DEFAULT, message: ResponseMessage.DEFAULT);
    }
  }
}

class ResponseCode {
  static const int SUCCESS = 200; //success with data
  static const int NO_CONTENT = 201; //success no data
  static const int BAD_REQUEST = 400; //failure api rejected request
  static const int FORBIDDEN = 401; //failure api user not auth
  static const int UNAUTHORIZED = 403; //failure api rejected request
  static const int INTERNAL_SERVER_ERROR = 500; //crash in server side
  static const int NOT_FOUND = 404; // api not found in rote of server
//local status code

  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECEIVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CASH_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;

  // Firebase specific codes
  static const int FIREBASE_AUTH_ERROR = -8;
  static const int FIREBASE_FIRESTORE_ERROR = -9;
  static const int FIREBASE_STORAGE_ERROR = -10;
}

class ResponseMessage {
  static const String SUCCESS = 'success'; //success with data
  static const String NO_CONTENT = 'success'; //success no data
  static const String BAD_REQUEST =
      'Bad Request, Try again later'; //failure api rejected request
  static const String FORBIDDEN =
      'Forbidden Request, Try again later'; //failure api user not auth
  static const String UNAUTHORIZED =
      'User is unauthorized, Try again later'; //failure api rejected request
  static const String INTERNAL_SERVER_ERROR =
      'Something went wrong, Try again later '; //crash in server side
  static const String NOT_FOUND =
      'Not found, Try again later '; // api not found in rote of server
//local status code

  static const String CONNECT_TIMEOUT = 'Time out error, Try again later ';
  static const String CANCEL = 'Request was cancelled, Try again later ';
  static const String RECEIVE_TIMEOUT = 'Time out error, Try again later ';
  static const String SEND_TIMEOUT = 'Time out error, Try again later ';
  static const String CASH_ERROR = 'Cache error, Try again later ';
  static const String NO_INTERNET_CONNECTION =
      'Please check your internet connection ';
  static const String DEFAULT = 'Something went wrong, Try again later';
}

class ApiInternalStatus {
  static const int SUCCESS = 0;
  static const int FAILURE = 1;
}
