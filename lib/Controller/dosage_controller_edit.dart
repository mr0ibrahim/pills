import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pills/model/DosageSchedules.dart';
import 'package:pills/service/db_helper.dart';
import 'package:pills/service/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class DosageController extends GetxController {
  final dbHelper = DatabaseHelper();
  final notificationService = NotificationService();
  final formKey = GlobalKey<FormState>();

  String? dosageAmount;
  DateTime? scheduleTime;
  String status = 'active';
  var daysCount = 1.obs;
  var notificationEnabled = false.obs;
  TimeOfDay? dosageHour;
  String? sideEffects;
  String? improvement;
  DateTime ?timeofday;
  DateTime? prescriptionDate;

  @override
  void onInit() {
    super.onInit();
    tz.initializeTimeZones();
    notificationService.init();
    _checkNotificationPermission();
  }

  void loadDosage(DosageSchedule dosageSchedule) {
    // تحميل البيانات الحالية للجرعة
    dosageAmount = dosageSchedule.dosageAmount;
    scheduleTime = dosageSchedule.scheduleTime;
    daysCount.value = dosageSchedule.daysCount;
    notificationEnabled.value = dosageSchedule.notificationEnabled;
    sideEffects = dosageSchedule.sideEffects;
    improvement = dosageSchedule.improvement;
    prescriptionDate = dosageSchedule.prescriptionDate;
    dosageHour = TimeOfDay.fromDateTime(dosageSchedule.scheduleTime);
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status != PermissionStatus.granted) {
      Get.snackbar(
        'تنبيه',
        'إذن التنبيهات مطلوب لتفعيل الإشعارات.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void submit() async {
    // تحقق من صحة النموذج
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // تحقق من توقيت الجرعة
      if (dosageHour == null) {
        Get.snackbar('خطأ', 'يرجى تحديد توقيت الجرعة بالساعات',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // دمج الوقت
      final combinedScheduleTime = DateTime(
        scheduleTime!.year,
        scheduleTime!.month,
        scheduleTime!.day,
        dosageHour!.hour,
        dosageHour!.minute,
      );

      // أدخل الجدول في قاعدة البيانات
      final dosageSchedule = DosageSchedule(
        dosageAmount: dosageAmount!,
        scheduleTime: combinedScheduleTime,
        status: status,
        daysCount: daysCount.value,
        notificationEnabled: notificationEnabled.value,
        sideEffects: sideEffects,
        improvement: improvement,
        prescriptionDate: prescriptionDate,
         timeOfDay: timeofday!,
      );

      // قم بتحديث الجدول في قاعدة البيانات
      await dbHelper.updateDosageSchedule(dosageSchedule); // تأكد من وجود دالة التحديث في db_helper

      // جدولة الإشعار عند تفعيل خيار الإشعار
      if (notificationEnabled.value) {
        await notificationService.showNotification(1, 'PILLS', 'تم تعديل الجرعة');
      }

      Get.snackbar('نجاح', 'تم تعديل الجرعة بنجاح',
          snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed('/home');
    }
  }
}
