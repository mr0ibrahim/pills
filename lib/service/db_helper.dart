import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pills/model/DosageSchedules.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz; // استيراد مكتبة timezone
import 'package:timezone/data/latest.dart' as tz; // استيراد البيانات
// لإدارة الإشعارات

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones(); // تهيئة المناطق الزمنية
  }

  Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    // تحويل DateTime إلى TZDateTime
    final tz.TZDateTime tzScheduledTime =
        tz.TZDateTime.from(scheduledTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime, // استخدام TZDateTime بدلاً من DateTime
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'your_channel_id', 'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    await initNotifications(); // تهيئة الإشعارات
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'pills.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE dosage_schedule (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            dosage_amount TEXT NOT NULL,
            schedule_time TEXT NOT NULL,
            status TEXT NOT NULL,
            days_count INTEGER NOT NULL,
            time_of_day TEXT NOT NULL,
            notification_enabled INTEGER NOT NULL,
            side_effects TEXT,
            improvement TEXT,
            prescription_date TEXT
          )
          ''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute(
              "ALTER TABLE dosage_schedule ADD COLUMN side_effects TEXT;");
          db.execute(
              "ALTER TABLE dosage_schedule ADD COLUMN improvement TEXT;");
          db.execute(
              "ALTER TABLE dosage_schedule ADD COLUMN prescription_date TEXT;");
        }
      },
    );
  }

  Future<void> insertDosageSchedule(DosageSchedule dosageSchedule) async {
    final db = await database;
    await db.insert(
      'dosage_schedule',
      dosageSchedule.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // إعداد الإشعار عند إضافة جرعة جديدة
    if (dosageSchedule.notificationEnabled == 1) {
      DateTime scheduleTime =
          DateTime.parse(dosageSchedule.scheduleTime as String);
      await scheduleNotification(
        dosageSchedule.id ?? 0,
        "وقت الجرعة",
        "حان الوقت لتناول الجرعة المقررة",
        scheduleTime,
      );
    }
   
  }
  Future<List<DosageSchedule>> getCompletedDosageSchedules() async {
   final db = await database; // تأكد من أنك قد أنشأت قاعدة البيانات

   final List<Map<String, dynamic>> maps = await db.query(
     'dosage_schedule', // تعديل من 'dosage_schedules' إلى 'dosage_schedule'
     where: 'status = ?', // شرط لجلب الجرعات المكتملة
     whereArgs: ['مكتمل'], // استبدل بـ الحالة التي تستخدمها
   );

   return List.generate(maps.length, (i) {
     return DosageSchedule(
       id: maps[i]['id'],
       dosageAmount: maps[i]['dosage_amount'], // تأكد من أن هذه الحقول مطابقة لتسمية الجدول
       scheduleTime: DateTime.parse(maps[i]['schedule_time']),
       status: maps[i]['status'],
       notificationEnabled: maps[i]['notification_enabled'] == 1,
       timeOfDay: DateTime.parse(maps[i]['time_of_day']),
       daysCount: maps[i]['days_count'],
     );
   });
 }


  Future<List<DosageSchedule>> getAllDosageSchedules() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('dosage_schedule');

    return List.generate(maps.length, (i) {
      return DosageSchedule.fromMap(maps[i]);
    });
  }

  Future<void> updateDosageSchedule(DosageSchedule dosageSchedule) async {
    final db = await database;
    await db.update(
      'dosage_schedule',
      dosageSchedule.toMap(),
      where: 'id = ?',
      whereArgs: [dosageSchedule.id],
    );
  }

  Future<void> deleteDosageSchedule(int id) async {
    final db = await database;
    await db.delete(
      'dosage_schedule',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  
}
