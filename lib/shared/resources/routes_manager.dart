import 'package:flutter/material.dart';
import 'package:template/features/chat/presentation/pages/chat_room_screen.dart';

import '../../app/service_locator.dart';
import '../../features/auth/presentation/view/login_screen.dart';
import '../../features/chat/presentation/model/receiver_model.dart';
import '../../features/chat/presentation/pages/messages_screen.dart';
import '../../features/home/presentation/view/home_screen.dart';
import '../../features/splash/splash_view.dart';
import 'strings_manager.dart';

class Routes {
  static const String splashRoute = '/';

  static const String loginRoute = '/login';

  static const String kdsHomeRoute = '/kdsHomeRoute';
  
  static const String chatRoomRoute = '/chatRoomRoute';
  static const String messagesRoute = '/messagesRoute';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => SplashView());

      case Routes.loginRoute:
        initAuthModule();
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case Routes.kdsHomeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case Routes.messagesRoute:
        initialChatModule();
        return MaterialPageRoute(builder: (_) => const MessagesScreen());

      case Routes.chatRoomRoute:
        initialChatModule();
        initAuthModule();
        Map arguments = settings.arguments as Map;
        String? senderId;

        if (arguments != null) {
          senderId = arguments['senderId'];
        }
        return MaterialPageRoute(
            builder: (_) => ChatRoomScreen(
                receiverModel:
                    ReceiverModel(name: '', phone: '', id: senderId ?? '')));

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.noRouteFound),
        ),
        body: const Center(
          child: Text(AppStrings.noRouteFound),
        ),
      ),
    );
  }
}
