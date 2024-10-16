class PrescriptionRenewalRequest {
  final String id; // معرف الطلب
  final String medicationName; // اسم الدواء
  final String patientId; // معرف المريض
  final DateTime requestDate; // تاريخ تقديم الطلب
  final String
      status; // حالة الطلب (تم تقديمه، قيد المعالجة، مرفوض، تم الموافقة)
  final DateTime prescriptionDate; // تاريخ الوصفة الطبية
  final String prescriptionImage; // رابط أو مسار صورة الوصفة الطبية
final  String doctor;
  PrescriptionRenewalRequest( {
    required this.doctor,
    required this.id,
    required this.medicationName,
    required this.patientId,
    required this.requestDate,
    required this.status,
    required this.prescriptionDate,
    required this.prescriptionImage,
  });

  // دالة لتحويل البيانات من JSON إلى كائن
  factory PrescriptionRenewalRequest.fromJson(Map<String, dynamic> json) {
    return PrescriptionRenewalRequest(
 doctor:json['doctor'],
      id: json['id'],
      medicationName: json['medicationName'],
      patientId: json['patientId'],
      requestDate: DateTime.parse(json['requestDate']),
      status: json['status'],
      prescriptionDate: DateTime.parse(json['prescriptionDate']),
      prescriptionImage: json['prescriptionImage'],
    );
  }

  // دالة لتحويل الكائن إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'doctor':doctor,
      'id': id,
      'medicationName': medicationName,
      'patientId': patientId,
      'requestDate': requestDate.toIso8601String(),
      'status': status,
      'prescriptionDate': prescriptionDate.toIso8601String(),
      'prescriptionImage': prescriptionImage,
    };
  }
}
