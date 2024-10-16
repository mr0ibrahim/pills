import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills/Controller/auth_Controller.dart';
import 'package:pills/screens/signup_screen.dart';
import 'package:pills/theme/theme.dart';
import 'package:pills/widgets/custom_scaffold.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
static const  String routes="/SignInScreen";
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

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
                          'مرحباً بعودتك',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: lightColorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 40.0),
                        TextFormField(
                          controller: controller.emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال البريد الإلكتروني';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('البريد الإلكتروني'),
                            hintText: 'أدخل البريد الإلكتروني',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          controller: controller.passwordController,
                          obscureText: true,
                          obscuringCharacter: '*',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال كلمة المرور';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('كلمة المرور'),
                            hintText: 'أدخل كلمة المرور',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Obx(() => Checkbox(
                                      value: controller.rememberPassword.value,
                                      onChanged: (bool? value) {
                                        controller.rememberPassword.value =
                                            value!;
                                      },
                                      activeColor: lightColorScheme.primary,
                                    )),
                                const Text(
                                  'تذكرني',
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              child: Text(
                                'نسيت كلمة المرور؟',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: lightColorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25.0),
                        Obx(() {
                          if (controller.isLoading.value) {
                            // عرض شريط المعالجة أثناء الانتظار
                            return const CircularProgressIndicator();
                          } else {
                            // عرض زر "تسجيل الدخول" إذا لم يكن في حالة انتظار
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (controller.formKey.currentState!
                                      .validate()) {
                                    controller.loginUser(); // استدعاء دالة تسجيل الدخول
                                  }
                                },
                                child: const Text('تسجيل الدخول'),
                              ),
                            );
                          }
                        }),
                        const SizedBox(height: 25.0),
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
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
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
                        const SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'ليس لديك حساب؟ ',
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const SignUpScreen());
                              },
                              child: Text(
                                'تسجيل',
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
