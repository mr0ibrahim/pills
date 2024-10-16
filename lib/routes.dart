import 'package:get/get.dart';
import 'package:pills/screens/add_dosage_page.dart';
import 'package:pills/screens/dosage_list_page.dart';
import 'package:pills/screens/edit_password_screen.dart';
import 'package:pills/screens/forget_passsword_screen.dart';
import 'package:pills/screens/nav_bar.dart';
import 'package:pills/screens/settings_screen.dart';
import 'package:pills/screens/signin_screen.dart';
import 'package:pills/screens/signup_screen.dart';
import 'package:pills/utils/onbording.dart';

List<GetPage> routes = [
  GetPage(name: Onboarding.routes, page: () => const Onboarding()),
  GetPage(name: NavBar.routes, page: () => const NavBar()),
  GetPage(name: SignInScreen.routes, page: () => const SignInScreen()),
  GetPage(name: AddDosagePage.routes, page: () => AddDosagePage()),
  GetPage(name: DosageListPage.routes, page: () => const DosageListPage()),
  GetPage(
      name: ForgetPasswordScreen.routes,
      page: () => const ForgetPasswordScreen()),
  GetPage(name: SettingsView.routes, page: () => const SettingsView()),
  GetPage(name: SignUpScreen.routes, page: () => const SignUpScreen()),
  GetPage(
    name: UpdatePasswordScreen.routes,
    page: () => UpdatePasswordScreen(),
  )
];
