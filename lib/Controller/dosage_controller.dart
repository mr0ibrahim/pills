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
  TextEditingController prescriptionDateController = TextEditingController();
  TextEditingController scheduleTimeController = TextEditingController();
  TextEditingController dosageHourController = TextEditingController();

  String? dosageAmount;
  DateTime? scheduleTime;
  String status = 'active';
  var daysCount = 1.obs;
  DateTime timeOfDay = DateTime.now();
  var notificationEnabled = false.obs;
  TimeOfDay? dosageHour;
  String? sideEffects;
  String? improvement;
  DateTime? prescriptionDate;
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

  void updatePrescriptionDate(DateTime date) {
    prescriptionDate = date;
    prescriptionDateController.text =
        date.toLocal().toString().split(' ')[0]; // تحديث النص بالتاريخ المختار
  }

  void updateScheduleTime(DateTime date) {
    scheduleTime = date;
    scheduleTimeController.text =
        date.toLocal().toString().split(' ')[0]; // تحديث النص بتاريخ الجرعة
  }

  void updateDosageHour(TimeOfDay time) {
    dosageHour = time;
    dosageHourController.text =
        time.format(Get.context!); // تحديث النص بالوقت المختار
  }

  @override
  void onInit() {
    super.onInit();
    tz.initializeTimeZones();
    notificationService.init();
    _checkNotificationPermission();
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

  Future<bool> _isExactAlarmPermissionRequired() async {
    return Platform.isAndroid &&
        (await const MethodChannel('flutter_local_notifications')
                .invokeMethod('getSdkInt')) >=
            31;
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
        timeOfDay: combinedScheduleTime,
        notificationEnabled: notificationEnabled.value,
        sideEffects: sideEffects,
        improvement: improvement,
        prescriptionDate: prescriptionDate,
      );

      await dbHelper.insertDosageSchedule(dosageSchedule);

      // جدولة الإشعار عند تفعيل خيار الإشعار
      if (notificationEnabled.value) {
        await notificationService
          ..showNotification(1, 'PILLS', 'تم اضافه جرعه');
        ;
      }

      Get.snackbar('نجاح', 'تم إضافة الجرعة بنجاح',
          snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed('/home');
    }
  }

  Future<void> submitUpdate() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (dosageHour == null) {
        Get.snackbar('خطأ', 'يرجى تحديد توقيت الجرعة بالساعات',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final combinedScheduleTime = DateTime(
        scheduleTime!.year,
        scheduleTime!.month,
        scheduleTime!.day,
        dosageHour!.hour,
        dosageHour!.minute,
      );

      final dosageSchedule = DosageSchedule(
        dosageAmount: dosageAmount!,
        scheduleTime: combinedScheduleTime,
        status: status,
        daysCount: daysCount.value,
        notificationEnabled: notificationEnabled.value,
        sideEffects: sideEffects,
        improvement: improvement,
        prescriptionDate: prescriptionDate,
        timeOfDay: timeOfDay,
      );

      await dbHelper.updateDosageSchedule(dosageSchedule);

      if (notificationEnabled.value) {
        await notificationService.showNotification(
            1, 'PILLS', 'تم تعديل الجرعة');
      }

      Get.snackbar('نجاح', 'تم تعديل الجرعة بنجاح',
          snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed('/home');
    }
  }

  void dalet(int id) {
    dbHelper.deleteDosageSchedule(id);
  }
}
