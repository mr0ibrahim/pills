import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills/screens/signin_screen.dart';
import '../model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  RxString username = ''.obs; // متغير لتخزين اسم المستخدم

  @override
  void onInit() {
    super.onInit();
    loadUsername(); // تحميل اسم المستخدم عند تهيئة الصفحة
  }
var user=UserModel().obs;
  getInfo() {
    String uuid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection("Users").doc(uuid).snapshots().listen((event) {
      user.value = UserModel.fromMap(event.data() as Map<String, dynamic>);
    },);
  }

  Future<void> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username.value =
        prefs.getString('name') ?? 'غير معروف'; // استرجاع اسم المستخدم
  }

  Future<void> logoutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // تحديث حالة تسجيل الدخول

    Get.toNamed(SignInScreen.routes);
  }
}
