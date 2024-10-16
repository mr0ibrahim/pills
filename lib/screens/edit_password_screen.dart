import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills/Controller/profile_controller.dart';

class UpdatePasswordScreen extends StatelessWidget {
  static const String routes = "/UpdatePasswordScreen";
  final ProfileController controller = Get.put(ProfileController());

  UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(onPressed: () {
            Get.back();
          }, icon: Image.asset("assets/images/next.png",height: 20,width: 20,)),
          title: const Text(
            "الملف الشخصي",
            style: TextStyle(fontSize: 16),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // استخدام Obx مع المتغيرات القابلة للملاحظة
              UserAccountsDrawerHeader(
                accountName: Obx(() => Center(
                    child: Text(controller.username.value,
                        style: const TextStyle(color: Colors.black)))),
                accountEmail: Obx(() => Center(
                        child: Text(
                      controller.email.value,
                      style: const TextStyle(color: Colors.black),
                    ))),
                currentAccountPicture: Center(
                    child: Image.asset(
                  "assets/images/u1.png",
                  width: 70,
                  height: 70,
                )),
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAF3),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration:
                    const InputDecoration(labelText: 'كلمة المرور القديمة'),
                onChanged: (value) {
                  controller.oldPassword.value = value;
                },
              ),
              TextField(
                decoration:
                    const InputDecoration(labelText: 'كلمة المرور الجديدة'),
                onChanged: (value) {
                  controller.newPassword.value = value;
                },
              ),
              TextField(
                decoration:
                    const InputDecoration(labelText: 'تأكيد كلمة المرور'),
                onChanged: (value) {
                  controller.confirmPassword.value = value;
                },
              ),
              const SizedBox(height: 20),
              Obx(() {
                // إظهار زر التحميل إذا كان هناك عملية تحميل
                return controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          controller.updatePassword();
                        },
                        child: const Text('تحديث كلمة المرور'),
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
