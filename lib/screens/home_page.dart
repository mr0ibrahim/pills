import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:pills/screens/dosage_detail_page.dart';
import 'package:pills/screens/edit_dosage_page.dart';
import 'package:pills/service/db_helper.dart';
import 'package:pills/model/DosageSchedules.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  List<DosageSchedule> _dosageSchedules = [];
  final dbHelper = DatabaseHelper(); // استدعاء DatabaseHelper لجلب الجرعات

  // استدعاء الجرعات بناءً على التاريخ المختار
  Future<void> _getDosagesByDate(DateTime date) async {
    List<DosageSchedule> schedules = await dbHelper.getAllDosageSchedules();

    setState(() {
      _dosageSchedules = schedules.where((dosage) {
        DateTime scheduleTime = DateTime.parse(dosage.scheduleTime.toString());
        return scheduleTime.year == date.year &&
            scheduleTime.month == date.month &&
            scheduleTime.day == date.day;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getDosagesByDate(
        _selectedDate); // تحميل الجرعات لأول مرة بناءً على التاريخ الحالي
  }

  String _formatTime(DateTime dateTime) {
    String formattedTime = DateFormat.jm().format(dateTime);
    // تحويل الوقت إلى صباح أو مساء بالعربية
    final hour = dateTime.hour;
    return hour < 12 ? "$formattedTime صباحًا" : "$formattedTime مساءً";
  }

  _dateBar() {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(bottom: 4),
      child: DatePicker(
        daysCount: 10,
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        locale: "ar",
        selectionColor: Colors.blue,
        selectedTextColor: Colors.black,
        dateTextStyle: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        dayTextStyle: const TextStyle(
          fontSize: 10.0,
          color: Colors.black,
        ),
        monthTextStyle: const TextStyle(
          fontSize: 10.0,
          color: Colors.black,
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
            _getDosagesByDate(
                date); // جلب الجرعات بناءً على التاريخ الجديد المختار
          });
        },
      ),
    );
  }

  void _editDosage(DosageSchedule dosage) {
    // هنا يمكنك إضافة منطق لتعديل الجرعة
    // يمكن استخدام showDialog لتعديل التفاصيل
    showDialog(
      context: context,
      builder: (context) {
        final dosageController =
            TextEditingController(text: dosage.dosageAmount);
        return AlertDialog(
          title: Text('تعديل الجرعة'),
          content: TextField(
            controller: dosageController,
            decoration: InputDecoration(labelText: 'الجرعة'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // قم بتحديث الجرعة في قاعدة البيانات هنا
                // dbHelper.updateDosage(...)
                Navigator.of(context).pop();
                _getDosagesByDate(_selectedDate); // تحديث الجرعات بعد التعديل
              },
              child: Text('حفظ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notification_add))
        ],
        title: const Center(
          child: Text(
            'الصفحه الرئيسيه',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      body: Column(
        children: [
          _dateBar(), // عنصر DatePicker
          const SizedBox(height: 20),

          // عرض الجرعات بناءً على التاريخ المحدد
          Expanded(
            child: _dosageSchedules.isNotEmpty
                ? ListView.builder(
                    itemCount: _dosageSchedules.length,
                    itemBuilder: (context, index) {
                      final dosage = _dosageSchedules[index];
                      return Card(
                        child: ListTile(
                          title: Text(dosage.dosageAmount),
                          subtitle: Text(
                            "الوقت: ${_formatTime(DateTime.parse(dosage.scheduleTime.toString()))}",
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {

                    
  Get.to(EditDosagePage(), arguments: dosage);


                            }, // استدعاء دالة التعديل
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    DosageDetailPage(dosage: dosage),
                              ),
                            ); // الانتقال إلى صفحة تفاصيل الجرعة
                          },
                        ),
                      );
                    },
                  )
                : const Center(child: Text("لا توجد جرعات لهذا اليوم")),
          ),
        ],
      ),
    );
  }
}
