import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:template/app/singlton.dart';

import '../../app/service_locator.dart';
import '../../shared/resources/color_manager.dart';
import '../../shared/resources/constants_manager.dart';
import '../../shared/resources/routes_manager.dart';

class SplashView extends StatefulWidget {
  SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;

  _startDelay() {
    _timer = Timer(const Duration(seconds: AppConstants.splashDelay), _goNext);
  }

  _goNext() async {
    //go to login page
    var user = await _checkLoginStatus();
    if (user != null) {
      Singleton().userModel = user;
      Navigator.pushReplacementNamed(
        context,
        Routes.messagesRoute,
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        Routes.loginRoute,
      );
    }
  }

  @override
  void initState() {
    initAuthModule();
    _startDelay();
    enableFirebaseOffline();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorManager.primary,
    );
  }

  Future<User?> _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser; // Get current user
    return user; // Return the user
  }

  void enableFirebaseOffline() {
    if (FirebaseAuth.instance.currentUser != null) {
      locator<FirebaseFirestore>().settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    }
  }
}
