import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills/Controller/auth_Controller.dart';
import 'package:pills/widgets/custom_text_field.dart';
import 'package:pills/screens/signin_screen.dart';
import 'package:pills/theme/theme.dart';
import 'package:pills/widgets/custom_scaffold.dart';

class SignUpScreen extends StatelessWidget {
  static const  String routes="/SignUpScreen ";
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController()); // تفعيل الـ Controller

    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomScaffold(
        child: Column(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(height: 10),
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'ابدأ الآن',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: lightColorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 40.0),
 Obx(() {
              return DropdownButtonFormField<String>(
                dropdownColor:Colors.white ,
                value: controller.selectedRole.value,
                items: const [
                  DropdownMenuItem(
                    value: 'doctor',
                    child: Text('طبيب'),
                  ),
                  DropdownMenuItem(
                    value: 'patient',
                    child: Text('مريض'),
                  ),
                ],
                onChanged: (value) {
                  controller.selectedRole.value = value!;
                },
                decoration: const InputDecoration(
                  labelText: 'نوع الحساب',
                  hintText: 'اختر نوع الحساب',
                ),
              );
            }),
           const  SizedBox(height: 25,),
                        CustomTextField(
                          controller: controller.nameController,
                          labelText: 'الاسم الكامل',
                          hintText: 'أدخل الاسم الكامل',
                          validator: controller.validateName,
                        ),
                        const SizedBox(height: 25.0),

                        CustomTextField(
                          controller: controller.emailController,
                          labelText: 'البريد الإلكتروني',
                          hintText: 'أدخل البريد الإلكتروني',
                          validator: controller.validateEmail,
                        ),
                        const SizedBox(height: 25.0),

                        CustomTextField(
                          controller: controller.passwordController,
                          labelText: 'كلمة المرور',
                          hintText: 'أدخل كلمة المرور',
                          obscureText: true,
                          validator: controller.validatePassword,
                        ),
                        const SizedBox(height: 25.0),

                        Row(
                          children: [
                            Obx(() => Checkbox(
                                  value: controller.agreePersonalData.value,
                                  onChanged: (bool? value) {
                                    controller.agreePersonalData.value = value!;
                                  },
                                  activeColor: lightColorScheme.primary,
                                )),
                            const Text(
                              'أوافق على معالجة ',
                              style: TextStyle(color: Colors.black45),
                            ),
                            Text(
                              'البيانات الشخصية',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25.0),

                        Obx(() {
                          return controller.isLoading.value
                              ? const CircularProgressIndicator() // شريط المعالجة
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.registerUser(); // استدعاء دالة التسجيل
                                    },
                                    child: const Text('تسجيل'),
                                  ),
                                );
                        }),
                        const SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.7,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              child: Text(
                                'أو قم بالتسجيل عبر',
                                style: TextStyle(color: Colors.black45),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.7,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'هل لديك حساب بالفعل؟ ',
                              style: TextStyle(color: Colors.black45),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const SignInScreen());
                              },
                              child: Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: lightColorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
