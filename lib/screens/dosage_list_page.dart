import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pills/model/DosageSchedules.dart';
import 'package:pills/service/db_helper.dart';
import 'package:timezone/timezone.dart' as tz;

class DosageListPage extends StatefulWidget {
  static const String routes = "/DosageListPage";
  const DosageListPage({super.key});

  @override
  _DosageListPageState createState() => _DosageListPageState();
}

class _DosageListPageState extends State<DosageListPage> {
  final dbHelper = DatabaseHelper();
  late Future<List<DosageSchedule>> dosageSchedules;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    dosageSchedules = dbHelper.getCompletedDosageSchedules(); // استدعاء الدالة الجديدة

    // إعدادات التهيئة للإشعارات
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(DosageSchedule schedule) async {
    var time = tz.TZDateTime.from(schedule.scheduleTime, tz.local);

    // إعدادات التنبيه
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      schedule.id!, // استخدم معرف الجرعة
      'وقت الجرعة!',
      'لا تنسَ تناول ${schedule.dosageAmount} الآن.',
      time,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // التكرار يوميًا
    );
  }

  Future<void> _updateNotificationStatus(DosageSchedule schedule) async {
    schedule.notificationEnabled = !schedule.notificationEnabled;
    await dbHelper.updateDosageSchedule(schedule);

    // إذا كانت الإشعارات مفعلة، قم بجدولة التنبيه
    if (schedule.notificationEnabled) {
      await _scheduleNotification(schedule);
    }

    setState(() {
      dosageSchedules = dbHelper.getCompletedDosageSchedules(); // تحديث الجرعات
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قائمة الجرعات المكتملة')),
      body: FutureBuilder<List<DosageSchedule>>(
        future: dosageSchedules,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }

          final schedules = snapshot.data;

          return ListView.builder(
            itemCount: schedules!.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return ListTile(
                title: Text(schedule.dosageAmount),
                subtitle: Text('توقيت: ${schedule.scheduleTime}'),
                trailing: IconButton(
                  icon: Icon(
                    schedule.notificationEnabled
                        ? Icons.notifications
                        : Icons.notifications_off,
                    color: schedule.notificationEnabled ? Colors.blue : null,
                  ),
                  onPressed: () {
                    _updateNotificationStatus(schedule); // تغيير حالة الإشعار
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
