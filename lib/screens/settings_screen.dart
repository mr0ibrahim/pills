import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills/Controller/settings_controller.dart';
import 'package:pills/screens/edit_password_screen.dart';
import 'package:pills/widgets/icon_item_row.dart';

class SettingsView extends StatefulWidget {
  static const String routes = "/SettingsView";
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    // الحصول على حجم الشاشة
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "الإعدادات",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/u1.png",
                    width: screenWidth * 0.2, // عرض الصورة يعتمد على عرض الشاشة
                    height: screenWidth * 0.2, // نفس الشيء للطول
                  )
                ],
              ),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.username.value, // عرض اسم المستخدم هنا
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: screenWidth * 0.05, // التباعد الأفقي يعتمد على عرض الشاشة
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 8),
                      child: Text(
                        "عام",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          IconItemRow(
                            onTap: () {
                              Get.toNamed(UpdatePasswordScreen.routes);
                            },
                            title: "تعديل الملف الشخصي",
                            icon: "assets/images/face_id.png",
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 8),
                      child: Text(
                        "إعدادات الإشعارات",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          IconItemRow(
                            title: "الإشعارات",
                            icon: "assets/images/notification.png",
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 8),
                      child: Text(
                        "صفحة الأسئلة الشائعة",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          IconItemRow(
                            title: "الأسئلة الشائعة",
                            icon: "assets/images/fqa.png",
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 8),
                      child: Text(
                        "تسجيل الخروج",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          IconItemRow(
                            onTap: () {
                              _showLogoutConfirmation(context);
                            },
                            title: "خروج",
                            icon: "assets/images/log-out.png",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة لتأكيد تسجيل الخروج
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("تأكيد تسجيل الخروج"),
          content: const Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق مربع الحوار إذا اختار "لا"
              },
              child: const Text("لا"),
            ),
            TextButton(
              onPressed: () {
                controller.logoutUser(context); // تسجيل الخروج إذا اختار "نعم"
                Navigator.of(context).pop(); // إغلاق مربع الحوار
              },
              child: const Text("نعم"),
            ),
          ],
        );
      },
    );
  }
}
