import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills/model/DosageSchedules.dart';
import 'package:pills/screens/edit_dosage_page.dart';
import 'package:pills/service/db_helper.dart';

class DosageDetailPage extends StatelessWidget {
  final DosageSchedule dosage;

  final db = DatabaseHelper();
  DosageDetailPage({super.key, required this.dosage});

  String _formatTime(DateTime dateTime) {
    // تنسيق الوقت باللغة العربية
    String period = dateTime.hour >= 12 ? 'م' : 'ص';
    String hour =
        ((dateTime.hour % 12) == 0 ? 12 : dateTime.hour % 12).toString();
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    DateTime scheduleTime = DateTime.parse(dosage.scheduleTime.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الجرعة'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // تفاصيل الجرعة في منتصف الصفحة
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الجرعة: ${dosage.dosageAmount}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 16),
                  Text('الوقت: ${_formatTime(scheduleTime)}',
                      style: const TextStyle(fontSize: 18)),
                         const SizedBox(height: 16),
                  Text('الوقت: ${dosage.status}',
                      style: const TextStyle(fontSize: 18)),
                  // يمكنك إضافة تفاصيل إضافية هنا إذا لزم الأمر
                ],
              ),
            ),
          ),
          // أزرار العمليات الثلاثة
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRoundedButton(
                  context,
                  'تعديل',
                  Colors.blue,
                  () => _editDosage(context, dosage),
                ),
                _buildRoundedButton(
                  context,
                  'حذف',
                  Colors.red,
                  () => _showDeleteConfirmationDialog(context, dosage),
                ),
                _buildRoundedButton(
                  context,
                  'تم شرب الجرعة',
                  Colors.green,
                  () => _markDosageAsTaken(context, dosage),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedButton(
      BuildContext context, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape:const  StadiumBorder(), // شكل دائري
        padding: const EdgeInsets.all(20), // حجم الزر
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }

  void _editDosage(BuildContext context, DosageSchedule d) {
    Get.to(() => const EditDosagePage(), arguments: d);
    // منطق تعديل الجرعة هنا
  }

  void _showDeleteConfirmationDialog(BuildContext context, DosageSchedule dosage) {
    Get.defaultDialog(
      title: "تحذير",
      middleText: "هل أنت متأكد أنك تريد حذف هذه الجرعة؟",
      confirm: ElevatedButton(
        onPressed: () {
          _deleteDosage(context, dosage);
          Get.back(); // إغلاق الحوار
        },
        child: const Text("نعم"),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back(); // إغلاق الحوار
        },
        child: const Text("لا"),
      ),
    );
  }

  void _deleteDosage(BuildContext context, DosageSchedule d) {
    db.deleteDosageSchedule(d.id!);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('تم حذف الجرعة')));
    Get.offAllNamed('/home'); // العودة إلى الصفحة الرئيسية بعد الحذف
  }

  void _markDosageAsTaken(BuildContext context, DosageSchedule dosage) async {
    // تحديث حالة الجرعة إلى مكتمل في قاعدة البيانات
    dosage.status = 'مكتمل'; // تأكد من أن لديك حقل الحالة في نموذج الجرعة
    await db.updateDosageSchedule(dosage); // افترض أن لديك دالة لتحديث الجرعة في قاعدة البيانات

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('تم تسجيل الجرعة كمكتملة')));
    Get.offAllNamed('/home'); // العودة إلى الصفحة الرئيسية بعد التحديث
  }
}
