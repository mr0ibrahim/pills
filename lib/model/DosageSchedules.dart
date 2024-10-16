class DosageSchedule {
  int? id;
  String dosageAmount;
  DateTime scheduleTime;
  String status;
  int daysCount;
  DateTime timeOfDay;
  bool notificationEnabled;
  String? sideEffects;
  String? improvement;
  DateTime? prescriptionDate;

  DosageSchedule({
    this.id,
    required this.dosageAmount,
    required this.scheduleTime,
    required this.status,
    required this.daysCount,
    required this.timeOfDay,
    required this.notificationEnabled,
    this.sideEffects,
    this.improvement,
    this.prescriptionDate,
  });

  // تحويل إلى Map مع تحويل DateTime إلى String
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dosage_amount': dosageAmount,
      'schedule_time': scheduleTime.toIso8601String(), // تحويل DateTime إلى String
      'status': status,
      'days_count': daysCount,
      'time_of_day': timeOfDay.toIso8601String(), // تحويل DateTime إلى String
      'notification_enabled': notificationEnabled ? 1 : 0,
      'side_effects': sideEffects,
      'improvement': improvement,
      'prescription_date': prescriptionDate?.toIso8601String(), // تحويل DateTime إلى String
    };
  }

  // تحويل من Map مع تحويل String إلى DateTime
  factory DosageSchedule.fromMap(Map<String, dynamic> map) {
    return DosageSchedule(
      id: map['id'],
      dosageAmount: map['dosage_amount'],
      scheduleTime: DateTime.parse(map['schedule_time']), // تحويل String إلى DateTime
      status: map['status'],
      daysCount: map['days_count'],
      timeOfDay: DateTime.parse(map['time_of_day']), // تحويل String إلى DateTime
      notificationEnabled: map['notification_enabled'] == 1,
      sideEffects: map['side_effects'],
      improvement: map['improvement'],
      prescriptionDate: map['prescription_date'] != null
          ? DateTime.parse(map['prescription_date']) // تحويل String إلى DateTime
          : null,
    );
  }
}
