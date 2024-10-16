import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signin_screen.dart';
import 'nav_bar.dart';
import 'signup_screen.dart';
import 'package:pills/theme/theme.dart';
import 'package:pills/widgets/custom_scaffold.dart';
import 'package:pills/widgets/welcome_button.dart';

class WelcomeScreen extends StatefulWidget {

static const  String routes="/";
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // التحقق من حالة تسجيل الدخول عند بدء الشاشة
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool('isLoggedIn');
    
    if (loggedIn == true) {
      // إذا كان المستخدم قد سجل الدخول، الانتقال إلى الصفحة الرئيسية
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAndToNamed(NavBar.routes);
      });
    } else {
      // إذا لم يسجل الدخول، تحديث الحالة لمواصلة عرض الشاشة الترحيبية
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

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
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 8,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 40.0),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                          text: 'مرحباً بعودتك!\n',
                          style: TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.w600,
                          )),
                      TextSpan(
                          text: '\nأدخل تفاصيل حسابك الشخصي',
                          style: TextStyle(
                            fontSize: 20,
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  const Expanded(
                    child: WelcomeButton(
                      buttonText: 'تسجيل الدخول',
                      onTap: SignInScreen(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'تسجيل',
                      onTap: const SignUpScreen(),
                      color: Colors.white,
                      textColor: lightColorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

