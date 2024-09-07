import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/data/remote_source/auth_remote_data_source.dart';
import '../features/auth/data/repository/repository_impl.dart';
import '../features/auth/domain/repo/repository.dart';
import '../features/auth/domain/useCase/auth_useCase.dart';
import '../features/chat/data/datasources/chat_remote_data_source.dart';
import '../features/chat/data/repositories/repository_impl.dart';
import '../features/chat/domain/repositories/repository.dart';
import '../features/chat/domain/usecases/chat_usecase.dart';
import '../features/home/data/remote_data_source/home_remote_data_source.dart';
import '../features/home/data/repo_impl/repo_impl.dart';
import '../features/home/domain/repo/repository.dart';
import '../features/home/domain/useCase/home_useCase.dart';

import 'app_prefs.dart';
import 'media/media_service.dart';
import 'media/media_service_interface.dart';
import 'network/api_app.dart';
import 'network/dio_factory.dart';
import 'network/network_info.dart';
import 'network/token.dart';
import 'permission/permission_handler_permission_service.dart';
import 'permission/permission_service.dart';

final locator = GetIt.instance;
// serviceLocator
///this general decency injection
Future<void> initAppModule() async {
  //shared preference instance
  final sharedPref = await SharedPreferences.getInstance();

  locator.registerLazySingleton<SharedPreferences>(
      () => sharedPref); //this create when call

  //instance app preferences

  locator
      .registerLazySingleton<AppPreferences>(() => AppPreferences(locator()));

  // network info
  locator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  // dio factory
  locator.registerLazySingleton<DioFactory>(() => DioFactory(locator()));

  //app service client

  Dio dio = await locator<DioFactory>().getDio();

  locator.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  locator.registerLazySingleton(() => TokenService(dio: dio));

  locator.registerSingleton<PermissionService>(
      PermissionHandlerPermissionService());

  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  locator.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  locator
      .registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  locator
      .registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);

  locator.registerSingleton<MediaServiceInterface>(MediaService());
}

//NEW for initiating login module
//saves user and token in shared Preferences

///this login decency injection
initAuthModule() {
  // firebase

  if (!GetIt.I.isRegistered<AuthRemoteDataSource>()) {
    locator.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(locator(), locator(), locator()));
  }
  if (!GetIt.I.isRegistered<Repository>()) {
    locator.registerLazySingleton<Repository>(
        () => AuthRepositoryImpl(locator(), locator()));
  }
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    locator.registerFactory<LoginUseCase>(() => LoginUseCase(locator()));
  }
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    locator.registerFactory<RegisterUseCase>(() => RegisterUseCase(locator()));
  }

  if (!GetIt.I.isRegistered<LogoutUseCase>()) {
    locator.registerFactory<LogoutUseCase>(() => LogoutUseCase(locator()));
  }

  if (!GetIt.I.isRegistered<StoreUserUseCase>()) {
    locator
        .registerFactory<StoreUserUseCase>(() => StoreUserUseCase(locator()));
  }


  if (!GetIt.I.isRegistered<AuthGetUserUseCase>()) {
    locator.registerFactory<AuthGetUserUseCase>(
        () => AuthGetUserUseCase(locator()));
  }
  if (!GetIt.I.isRegistered<UpdateUserStatusUseCase>()) {
    locator.registerFactory<UpdateUserStatusUseCase>(
        () => UpdateUserStatusUseCase(locator()));
  }


}

///this KDS dependency injection
initHomeModule() {
  if (!GetIt.I.isRegistered<HomeRemoteDataSource>()) {
    locator.registerLazySingleton<HomeRemoteDataSource>(
        () => HomeRemoteDataSourceImpl(locator()));
  }
  if (!GetIt.I.isRegistered<HomeRepository>()) {
    locator.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(locator(), locator()));
  }
  if (!GetIt.I.isRegistered<HomeGetAllMealsUseCase>()) {
    locator.registerFactory<HomeGetAllMealsUseCase>(
        () => HomeGetAllMealsUseCase(locator()));
  }
}



initialChatModule() {
  if (!GetIt.I.isRegistered<ChatRemoteDataSource>()) {
    locator.registerFactory<ChatRemoteDataSource>(
        () => ChatRemoteDataSourceImpl(locator(), locator(), locator()));
  }

  if (!GetIt.I.isRegistered<ChatRepository>()) {
    locator.registerLazySingleton<ChatRepository>(
        () => ChatRepositoryImpl(locator(), locator()));
  }

  if (!GetIt.I.isRegistered<ChatSendNotificationUseCase>()) {
    locator.registerFactory<ChatSendNotificationUseCase>(
        () => ChatSendNotificationUseCase(locator()));
  }

  if (!GetIt.I.isRegistered<ChatMessageUseCase>()) {
    locator.registerFactory<ChatMessageUseCase>(
        () => ChatMessageUseCase(locator()));
  }

  if (!GetIt.I.isRegistered<ChatGetUserUseCase>()) {
    locator.registerFactory<ChatGetUserUseCase>(
        () => ChatGetUserUseCase(locator()));
  }

  if (!GetIt.I.isRegistered<ChatUploadFileUseCase>()) {
    locator.registerFactory<ChatUploadFileUseCase>(
        () => ChatUploadFileUseCase(locator()));
  }

  if (!GetIt.I.isRegistered<ChatGetAllUsersUseCase>()) {
    locator.registerFactory<ChatGetAllUsersUseCase>(
        () => ChatGetAllUsersUseCase(locator()));
  }



  if (!GetIt.I.isRegistered<ChatGetLastMessagesUseCase>()) {
    locator.registerFactory<ChatGetLastMessagesUseCase>(
        () => ChatGetLastMessagesUseCase(locator()));
  }

  if (!GetIt.I.isRegistered<ChatUpdateTypingUseCase>()) {
    locator.registerFactory<ChatUpdateTypingUseCase>(
        () => ChatUpdateTypingUseCase(locator()));
  }



}

