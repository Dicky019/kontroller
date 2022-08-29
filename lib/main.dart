import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'view/admin.dart';
import 'view/login_user.dart';
import 'view/home.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  log("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.subscribeToTopic('myTopic');

  await GetStorage.init();
  final box = GetStorage();
  String? isLogin = box.read('isLogin');

  if (isLogin != null) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    // box.remove('isAdmin');
    // box.remove('isLogin');
    String? isLogin = box.read('isLogin');
    String? mac = box.read('mac');
    bool isAdmin = box.read('isAdmin') ?? false;

    return GetMaterialApp(
      theme: ThemeData(
        // primaryColor: Colors.pinkAccent,
        // colorSchemeSeed: Colors.pinkAccent,
        useMaterial3: true,
      ),
      home: isLogin != null
          ? (isAdmin
              ? Admin(id: isLogin)
              : Home(
                  id: isLogin,
                  mac: mac ?? "",
                ))
          : const LoginUser(),
    );
  }
}
