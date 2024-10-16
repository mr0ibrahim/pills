// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pills/Controller/auth_Controller.dart';
// import 'package:pills/service/frebase_helper.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class OTPVerificationScreen extends StatelessWidget {
//   static const String routes = "/OTPVerificationScreen";
//   final TextEditingController otpController = TextEditingController();

//   OTPVerificationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authController = Get.find<AuthController>(); // الحصول على AuthController

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("التحقق من البريد الإلكتروني"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               "أدخل رمز التحقق (OTP) الذي تم إرساله إلى ${authController.emailController.text}",
//               style: const TextStyle(fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: otpController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: "رمز OTP",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Obx(() {
//               return authController.isLoading.value
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: () {
//                         authController.verifyOTP(otpController.text.trim());
//                       },
//                       child: const Text("تحقق"),
//                     );
//             }),
//             const SizedBox(height: 20),
//             TextButton(
//               onPressed: () {
//                 authController.sendOTP(); // إعادة إرسال OTP
//               },
//               child: const Text("إعادة إرسال الرمز"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
