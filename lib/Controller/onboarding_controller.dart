import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pills/utils/content_model.dartcontent_model.dart'; // تم تصحيح المسار

class OnboardingController extends GetxController {
  var currentIndex = 0.obs; // استخدام Rx لتتبع الفهرس الحالي

  void setCurrentIndex(int index) {
    currentIndex.value = index; // تحديث الفهرس الحالي
  }

  void nextPage(PageController controller) {
    if (currentIndex.value < contents.length - 1) {
      controller.nextPage(
        duration: Duration(milliseconds: 100),
        curve: Curves.bounceIn,
      );
    } else {
      // يمكنك إضافة إجراء هنا عند الانتهاء من الـ Onboarding
    }
  }
}
