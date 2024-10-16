import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pills/Controller/auth_Controller.dart';
import 'package:pills/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final AuthController authController =
      Get.find<AuthController>(); // إضافة هذا السطر

  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxString username = ''.obs; // متغير لتخزين اسم المستخدم
  RxString email = ''.obs; // متغير لتخزين البريد الالكتروني
  // المتغيرات
  var oldPassword = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;
  var isLoading = false.obs;

  // دالة للتحقق من كلمة المرور القديمة وتحديث كلمة المرور
  Future<void> updatePassword() async {
    if (newPassword.value != confirmPassword.value) {
      Get.snackbar('خطأ', 'كلمات المرور غير متطابقة');
      return;
    }

    try {
      isLoading(true);

      // الحصول على المستخدم الحالي
      User? user = _auth.currentUser;
      if (user != null) {
        String email = user.email!;

        // إعادة تسجيل الدخول للتحقق من كلمة المرور القديمة
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: oldPassword.value,
        );

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword.value);

        Get.snackbar('نجاح', 'تم تحديث كلمة المرور بنجاح');
        _auth.signOut(); // تسجيل الخروج بعد تحديث كلمة المرور
        Get.back(); // العودة إلى الشاشة السابقة بعد التحديث
      }
    } on FirebaseAuthException catch (e) {
      String message = 'حدث خطأ غير معروف';
      if (e.code == 'wrong-password') {
        message = 'كلمة المرور القديمة غير صحيحة';
      } else if (e.code == 'weak-password') {
        message = 'كلمة المرور الجديدة ضعيفة جدًا';
      } else if (e.code == 'requires-recent-login') {
        message = 'تحتاج إلى تسجيل الدخول مؤخرًا لتحديث كلمة المرور';
      }
      Get.snackbar('خطأ', message);
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getInfo(); // تحميل اسم المستخدم عند تهيئة الصفحة
  }

  var user = UserModel().obs;
  getInfo() async {
    await Future.delayed(Duration.zero);
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      Get.snackbar('خطأ', 'يجب تسجيل الدخول أولاً.');
      return;
    }

    String uid = authController.uid.value; // استخدام uid من AuthController
    print("UID: $uid");
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection("Users").doc(uid).get();

      if (snapshot.exists) {
        user.value = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
        username.value = user.value.name ?? 'غير معروف';
        email.value = user.value.email ?? '';
      } else {
        Get.snackbar('خطأ', 'المستخدم غير موجود في قاعدة البيانات');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء جلب البيانات: $e');
    }
  }

  Future<void> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('name') ?? 'غير معروف';
    email.value = prefs.getString('email') ?? ''; // استرجاع اسم المستخدم
  }
}
