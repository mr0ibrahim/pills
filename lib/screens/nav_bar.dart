import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills/screens/PrescriptionService.dart';
import 'package:pills/screens/add_dosage_page.dart';
import 'package:pills/screens/dosage_list_page.dart';
import 'package:pills/screens/home_page.dart';
import 'package:pills/screens/settings_screen.dart';
import 'package:pills/screens/signin_screen.dart';
import 'package:pills/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  static const  String routes = "/home";
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;
  Future<void> _logoutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // تحديث حالة تسجيل الدخول

    Get.toNamed(SignInScreen.routes); // العودة إلى صفحة تسجيل الدخول
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        children:  <Widget>[
         HomePage(),
          AddPrescriptionRenewalPage(),
         DosageListPage(),
        SettingsView(),
        ], // منع التمرير
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        onPressed: () {
        Get.toNamed(AddDosagePage.routes);
          // اجراء الزر العائم
        },
        backgroundColor: Colors.blue,
        elevation: 5.0,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? Image.asset(
                    "assets/images/home.png",
                    height: 20,
                    width: 20,
                    color: lightColorScheme.primary,
                  )
                : Image.asset(
                    "assets/images/home.png",
                    height: 20,
                    width: 20,
                    color: Colors.black,
                  ),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Image.asset(
                    "assets/images/document.png",
                    height: 20,
                    width: 20,
                    color: lightColorScheme.primary,
                  )
                : Image.asset(
                    "assets/images/document.png",
                    height: 20,
                    width: 20,
                    color: Colors.black,
                  ),
            label: 'التقارير',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? Image.asset(
                    "assets/images/calendar.png",
                    height: 20,
                    width: 20,
                    color: lightColorScheme.primary,
                  )
                : Image.asset(
                    "assets/images/calendar.png",
                    height: 20,
                    width: 20,
                    color: Colors.black,
                  ),
            label: 'السجل',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3
                ? Image.asset(
                    "assets/images/profile.png",
                    height: 20,
                    width: 20,
                    color: lightColorScheme.primary,
                  )
                : Image.asset(
                    "assets/images/profile.png",
                    height: 20,
                    width: 20,
                    color: Colors.black,
                  ),
            label: 'الملف الشخصي',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: lightColorScheme.primary,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // إضافة أنماط ثابتة
      ),
    );
  }
}


// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.amber,
//         child: ElevatedButton(
//           onPressed: () {
//             _logoutUser(context);
//           },
//           child: const Text('تسجيل الخروج'),
//         ),
//       ),
//     );
//   }

  // Future<void> _logoutUser(BuildContext context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isLoggedIn', false); // تحديث حالة تسجيل الدخول

  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             const WelcomeScreen()), // العودة إلى صفحة تسجيل الدخول
  //   );
  // }
// }


