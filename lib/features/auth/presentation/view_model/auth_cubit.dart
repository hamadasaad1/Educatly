import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:template/app/singlton.dart';

import '../../../../app/error/failure.dart';
import '../../../../app/service_locator.dart';
import '../../domain/useCase/auth_useCase.dart';
import '../model/input_login_model.dart';
import '../model/input_register_model.dart';
import '../model/input_store_user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthStateInitial());

  final LoginUseCase _loginUseCase = locator<LoginUseCase>();

  final RegisterUseCase _registerUseCase = locator<RegisterUseCase>();

  final LogoutUseCase _logoutUseCase = locator<LogoutUseCase>();

  final StoreUserUseCase _storeUserUseCase = locator<StoreUserUseCase>();
  final AuthGetUserUseCase _authGetUserUseCase = locator<AuthGetUserUseCase>();
  final UpdateUserStatusUseCase _statusUseCase =
      locator<UpdateUserStatusUseCase>();

  void login({required LoginInputModel model}) async {
    emit(AuthLoginLoadingState());

    (await _loginUseCase.execute(model)).fold((failure) {
      return {
        emit(AuthLoginErrorState(failure: failure)),
      };
    }, (data) {
      updateUserStatus(isOnline: true);
      emit(AuthLoginSuccessState(entity: data));
    });
  }

  void register({required InputRegisterModel model}) async {
    emit(AuthLoginLoadingState());
    (await _registerUseCase.execute(model)).fold((failure) {
      return {
        emit(AuthLoginErrorState(failure: failure)),
      };
    }, (data) {
      emit(AuthLoginSuccessState(entity: data));
    });
  }

  void logout() async {
    updateUserStatus(isOnline: false);
    emit(AuthLogoutLoadingState());
    (await _logoutUseCase.execute(Void)).fold((failure) {
      return {
        emit(AuthLogoutErrorState(failure: failure)),
      };
    }, (data) {
      emit(AuthLogoutSuccessState());
    });
    Singleton().userData = null;
    Singleton().userModel = null;
  }

  void storeUser({required InputStoreUserModel model}) async {
    (await _storeUserUseCase.execute(model)).fold((failure) {
      return {};
    }, (data) {});
  }

  void getUser() async {
    if (Singleton().userData != null) {
      return;
    }
    emit(AuthGetUserLoadingState());
    (await _authGetUserUseCase.execute(Singleton().userModel?.uid ?? '')).fold(
        (failure) {
      return {
        emit(AuthGetUserErrorState(failure: failure)),
      };
    }, (data) {
      Singleton().userData = data;
      emit(AuthGetUserSuccessState(entity: data));
    });
  }

  void updateUserStatus({required bool isOnline}) async {
    (await _statusUseCase.execute(isOnline)).fold((failure) {
      return {
        debugPrint(failure.message),
      };
    }, (data) {
      debugPrint('data Status Changed');
    });
  }
}
