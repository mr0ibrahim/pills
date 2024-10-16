import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pills/Controller/auth_Controller.dart';
import 'package:pills/routes.dart';
import 'package:pills/theme/theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pills/utils/onbording.dart';

import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin(); // تأكد من تعريف هذا المتغير هنا

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAsMwiGJ-w6JKPTfCjev3p44EuSJxUrD4s",
          appId: "1:529340742421:android:f8ab292bda843d88bbc71c",
          messagingSenderId: "529340742421",
          projectId: "pills-819da"));
  tz.initializeTimeZones();
   Get.lazyPut(() => AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages:routes ,
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''), // Arabic
      ],
      locale: const Locale('ar', ''), // Set default language to Arabic
      home:const   Onboarding(), // البداية من صفحة تسجيل الدخول
    );
  }
}
