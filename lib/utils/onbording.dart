import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pills/Controller/onboarding_controller.dart';
import 'package:pills/screens/nav_bar.dart';
import 'package:pills/screens/signin_screen.dart';
import 'package:pills/screens/signup_screen.dart';
// تأكد من أن هذا المسار صحيح
import 'package:pills/utils/content_model.dartcontent_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatefulWidget {
  static const String routes = "/";
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // التحقق من حالة تسجيل الدخول عند بدء الشاشة
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool('isLoggedIn');
    bool? hasSeenOnboarding = prefs.getBool('hasSeenOnboarding');

    if (loggedIn == true) {
      // إذا كان المستخدم قد سجل الدخول، الانتقال إلى الصفحة الرئيسية
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAndToNamed(NavBar.routes);
      });
    } else if (hasSeenOnboarding == true) {
      // إذا كان المستخدم قد أكمل عرض الصفحات، الانتقال إلى صفحة التسجيل
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(SignInScreen.routes); // استخدام Get.offAll
      });
    } else {
      // إذا لم يسجل الدخول أو لم يشاهد العرض، تحديث الحالة لمواصلة عرض الشاشة الترحيبية
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  final OnboardingController onboardingController =
      Get.put(OnboardingController());

  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    // إذا لم يتم التحقق من حالة تسجيل الدخول بعد، إظهار مؤشر التحميل
    if (_isLoggedIn == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // إذا لم يكن المستخدم مسجلاً للدخول، بناء واجهة الشاشة الترحيبية
    return _buildWelcomeContent(context);
  }

  Widget _buildWelcomeContent(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF3),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: onboardingController.setCurrentIndex,
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        contents[i].image ?? '',
                        height: 300,
                      ),
                      Text(
                        contents[i].title!,
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        contents[i].discription!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  contents.length,
                  (index) => buildDot(
                      index, onboardingController.currentIndex.value, context),
                ),
              )),
          Container(
            height: 60,
            margin: const EdgeInsets.all(40),
            width: double.infinity,
            child: ElevatedButton(
              child: Obx(() => Text(
                  onboardingController.currentIndex.value == contents.length - 1
                      ? "موافق"
                      : "التالي")),
              onPressed: () async {
                if (onboardingController.currentIndex.value ==
                    contents.length - 1) {
                  // حفظ حالة مشاهدة العرض
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('hasSeenOnboarding', true);
                  Get.offAll(() => const SignUpScreen()); // استخدام Get.offAll
                } else {
                  onboardingController.nextPage(_controller);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, int currentIndex, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
