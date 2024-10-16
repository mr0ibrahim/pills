import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills/doctor/doctor_page.dart';
import 'package:pills/screens/signin_screen.dart';
import 'package:pills/service/frebase_helper.dart';
// استبدال db_helper بـ firestore_helper
import 'package:pills/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pills/screens/nav_bar.dart';

class AuthController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var otp = ''.obs; // رمز OTP
  var selectedRole = 'patient'.obs; // دور المستخدم، مريض افتراضيًا
  var uid = ''.obs; 

  var rememberPassword = false.obs;
  var agreePersonalData = true.obs;
  var isLoading = false.obs; // متغير لحالة المعالجة

  @override
  void onInit() {
    super.onInit();
    _loadCredentials(); // تحميل بيانات المستخدم المخزنة
  }

  // دالة لتحميل بيانات البريد الإلكتروني وكلمة المرور
  Future<void> _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    rememberPassword.value = prefs.getBool('rememberPassword') ?? false;
    if (rememberPassword.value) {
      emailController.text = prefs.getString('email') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
    }
  }

Future<void> loginUser() async {
    isLoading.value = true;

    final dbHelper = FirestoreHelper();
    List<UserModel> users = await dbHelper.getUsers();

    final UserModel user = users.firstWhere(
      (user) =>
          user.email == emailController.text &&
          user.password == passwordController.text,
      orElse: () =>
          UserModel(id: -1, name: '', email: '', password: '', role: 'patient'),
    );

    if (user.id != -1) {
      print('تم تسجيل الدخول بنجاح');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // حفظ UID المستخدم
      uid.value = user.id.toString(); // تأكد من أن id هو UID في نموذج المستخدم

      if (rememberPassword.value) {
        await prefs.setString('name', nameController.text);
        await prefs.setString('email', emailController.text.trim());
        await prefs.setString('password', passwordController.text.trim());
        await prefs.setBool('rememberPassword', true);
      } else {
        await prefs.setString('name', nameController.text);
        await prefs.remove('email');
        await prefs.remove('password');
        await prefs.setBool('rememberPassword', false);
      }

      isLoading.value = false;
      if (user.role == 'doctor') {
        Get.to(const DoctorPage());
      } else {
        Get.offAllNamed(NavBar.routes);
      }
    } else {
      isLoading.value = false;
      print('فشل تسجيل الدخول');
      Get.snackbar(
        'خطأ',
        'البريد الإلكتروني أو كلمة المرور غير صحيحة',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> registerUser() async {
    if (formKey.currentState!.validate() && agreePersonalData.value) {
      isLoading.value = true;
      final dbHelper = FirestoreHelper();

      List<UserModel> users = await dbHelper.getUsers();
      final existingUser = users.firstWhere(
        (user) => user.email == emailController.text.trim(),
        orElse: () => UserModel(
            id: -1, name: '', email: '', password: '', role: 'patient'),
      );

      if (existingUser.id != -1) {
        isLoading.value = false;
        Get.snackbar('خطأ', 'المستخدم موجود مسبقًا');
        return;
      }

      // إذا لم يكن موجودًا، تابع التسجيل مع الدور (role)
      await dbHelper.insertUser(
        UserModel(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
          role: selectedRole.value,
        ),
      );

      // بعد التسجيل، حفظ UID المستخدم
      uid.value = existingUser.id.toString(); // تأكد من أنك تستخدم UID الصحيح هنا

      isLoading.value = false;
      Get.snackbar('نجاح', 'تم تسجيلك بنجاح');
      Get.offAllNamed(SignInScreen.routes);
    } else if (!agreePersonalData.value) {
      isLoading.value = false;
      Get.snackbar('تحذير', 'يرجى الموافقة على معالجة البيانات الشخصية');
    }
  }

  Future<void> sendOTP() async {
    isLoading.value = true;

    try {
      otp.value = generateOTP(); // توليد OTP عشوائي
      await FirestoreHelper()
          .sendOTPEmail(emailController.text, otp.value); // إرسال OTP بالبريد
      Get.toNamed(SignInScreen.routes); // الانتقال إلى شاشة التحقق
    } catch (error) {
      Get.snackbar('خطأ', 'فشل في إرسال رمز التحقق');
    } finally {
      isLoading.value = false;
    }
  }

  // دالة توليد OTP عشوائي
  String generateOTP() {
    var rng = Random();
    return (100000 + rng.nextInt(900000)).toString(); // توليد رقم من 6 أرقام
  }

  // التحقق من صحة رمز OTP
  Future<void> verifyOTP(String enteredOTP) async {
    if (enteredOTP == otp.value) {
      Get.offAndToNamed(NavBar.routes);
      Get.snackbar('نجاح', 'تم التحقق بنجاح');
      // يمكنك تنفيذ عمليات إضافية مثل تسجيل الدخول أو إتمام التسجيل
    } else {
      Get.snackbar('خطأ', 'الرمز الذي أدخلته غير صحيح');
    }
  }

 

  // دوال للتحقق من صحة البيانات
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال الاسم الكامل';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    // تحقق من صحة البريد الإلكتروني باستخدام تعبير عادي
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'يرجى إدخال بريد إلكتروني صالح';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'يجب أن تكون كلمة المرور مكونة من 6 أحرف على الأقل';
    }
    return null;
  }
}
