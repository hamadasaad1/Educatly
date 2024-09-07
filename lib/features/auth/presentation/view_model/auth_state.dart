part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthStateInitial extends AuthState {}

class AuthLoginLoadingState extends AuthState {}

class AuthLoginSuccessState extends AuthState {
  final User entity;

  AuthLoginSuccessState({
    required this.entity,
  });
}

class AuthLoginErrorState extends AuthState {
  final Failure failure;

  AuthLoginErrorState({
    required this.failure,
  });
}

class AuthLogoutLoadingState extends AuthState {}

class AuthLogoutSuccessState extends AuthState {}

class AuthLogoutErrorState extends AuthState {
  final Failure failure;

  AuthLogoutErrorState({
    required this.failure,
  });
}

class AuthStoreUserLoadingState extends AuthState {}

class AuthStoreUserSuccessState extends AuthState {}

class AuthGetUserLoadingState extends AuthState {}

class AuthGetUserSuccessState extends AuthState {
  final DocumentSnapshot<Object?> entity;

  AuthGetUserSuccessState({
    required this.entity,
  });
}

class AuthGetUserErrorState extends AuthState {
  final Failure failure;

  AuthGetUserErrorState({
    required this.failure,
  });
}
