import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pills/model/Medication.dart';
import 'package:pills/model/Prescription.dart';
import 'package:pills/model/user_model.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class FirestoreHelper {
  static final FirestoreHelper _instance = FirestoreHelper._internal();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  factory FirestoreHelper() {
    return _instance;
  }

  FirestoreHelper._internal();

  // العمليات المتعلقة بالمستخدمين
  Future<void> insertUser(UserModel user) async {
    try {
      await firestore
          .collection('Users')
          .doc(user.id.toString())
          .set(user.toMap());
      print("User added to Firestore");
    } catch (e) {
      print("Failed to add user: $e");
    }
  }
  Future<void> insertPrescriptionRenewal(PrescriptionRenewalRequest renewal) async {
    try {
      await firestore.collection('PrescriptionRenewals').doc(renewal.id).set(renewal.toJson());
      print("Prescription renewal added to Firestore");
    } catch (e) {
      print("Failed to add prescription renewal: $e");
    }
  }

  Future<List<PrescriptionRenewalRequest>> getPrescriptionRenewals() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('PrescriptionRenewals').get();
      return snapshot.docs.map((doc) => PrescriptionRenewalRequest.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print("Failed to fetch prescription renewals: $e");
      return [];
    }
  }

  Future<void> updatePrescriptionRenewal(PrescriptionRenewalRequest renewal) async {
    try {
      await firestore.collection('PrescriptionRenewals').doc(renewal.id).update(renewal.toJson());
      print("Prescription renewal updated in Firestore");
    } catch (e) {
      print("Failed to update prescription renewal: $e");
    }
  }

  Future<void> deletePrescriptionRenewal(String id) async {
    try {
      await firestore.collection('PrescriptionRenewals').doc(id).delete();
      print("Prescription renewal deleted from Firestore");
    } catch (e) {
      print("Failed to delete prescription renewal: $e");
    }
  }
  Future<List<UserModel>> getUsers() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('Users').get();
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Failed to fetch users: $e");
      return [];
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await firestore
          .collection('Users')
          .doc(user.id.toString())
          .update(user.toMap());
      print("User updated in Firestore");
    } catch (e) {
      print("Failed to update user: $e");
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await firestore.collection('Users').doc(id.toString()).delete();
      print("User deleted from Firestore");
    } catch (e) {
      print("Failed to delete user: $e");
    }
  }

  Future<void> sendOTPEmail(String email, String otp) async {
    String username = 'your-email@gmail.com'; // بريدك الإلكتروني
    String password =
        'your-email-password'; // كلمة المرور للتطبيق الخاص بالبريد

    final smtpServer = gmail(username, password); // إعداد SMTP Gmail

    final message = Message()
      ..from = Address(username, 'Your App Name')
      ..recipients.add(email)
      ..subject = 'OTP Verification Code'
      ..text = 'Your OTP code is $otp. Please use it to verify your email.';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print('Message not sent. ${e.toString()}');
      throw 'Error in sending OTP email';
    }
  }

  // // العمليات المتعلقة بالجرعات
  // Future<void> insertDosageSchedule(DosageSchedule schedule) async {
  //   try {
  //     await firestore.collection('DosageSchedules').doc(schedule.id.toString()).set(schedule.toMap());
  //     print("Dosage schedule added to Firestore");
  //   } catch (e) {
  //     print("Failed to add dosage schedule: $e");
  //   }
  // }

  // Future<List<DosageSchedule>> getDosageSchedules(int userId) async {
  //   try {
  //     QuerySnapshot snapshot = await firestore
  //         .collection('DosageSchedules')
  //         .where('user_id', isEqualTo: userId)
  //         .get();
  //     return snapshot.docs
  //         .map((doc) => DosageSchedule.fromMap(doc.data() as Map<String, dynamic>))
  //         .toList();
  //   } catch (e) {
  //     print("Failed to fetch dosage schedules: $e");
  //     return [];
  //   }
  // }

  // العمليات المتعلقة بالأدوية
  Future<void> insertMedication(Medication medication) async {
    try {
      await firestore
          .collection('Medications')
          .doc(medication.id.toString())
          .set(medication.toMap());
      print("Medication added to Firestore");
    } catch (e) {
      print("Failed to add medication: $e");
    }
  }

  Future<List<Medication>> getMedications() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('Medications').get();
      return snapshot.docs
          .map((doc) => Medication.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Failed to fetch medications: $e");
      return [];
    }
  }

  Future<void> updateMedication(Medication medication) async {
    try {
      await firestore
          .collection('Medications')
          .doc(medication.id.toString())
          .update(medication.toMap());
      print("Medication updated in Firestore");
    } catch (e) {
      print("Failed to update medication: $e");
    }
  }

  Future<void> deleteMedication(int id) async {
    try {
      await firestore.collection('Medications').doc(id.toString()).delete();
      print("Medication deleted from Firestore");
    } catch (e) {
      print("Failed to delete medication: $e");
    }
  }

  // العمليات المتعلقة بتجديد الوصفات
  // Future<void> insertPrescriptionRenewal(PrescriptionRenewal renewal) async {
  //   try {
  //     await firestore.collection('PrescriptionRenewals').doc(renewal.renewalId.toString()).set(renewal.toMap());
  //     print("Prescription renewal added to Firestore");
  //   } catch (e) {
  //     print("Failed to add prescription renewal: $e");
  //   }
  // }

  // Future<List<PrescriptionRenewal>> getPrescriptionRenewals() async {
  //   try {
  //     QuerySnapshot snapshot = await firestore.collection('PrescriptionRenewals').get();
  //     return snapshot.docs.map((doc) => PrescriptionRenewal.fromMap(doc.data() as Map<String, dynamic>)).toList();
  //   } catch (e) {
  //     print("Failed to fetch prescription renewals: $e");
  //     return [];
  //   }
  // }

  // Future<void> updatePrescriptionRenewal(PrescriptionRenewal renewal) async {
  //   try {
  //     await firestore.collection('PrescriptionRenewals').doc(renewal.renewalId.toString()).update(renewal.toMap());
  //     print("Prescription renewal updated in Firestore");
  //   } catch (e) {
  //     print("Failed to update prescription renewal: $e");
  //   }
  // }

  // Future<void> deletePrescriptionRenewal(int id) async {
  //   try {
  //     await firestore.collection('PrescriptionRenewals').doc(id.toString()).delete();
  //     print("Prescription renewal deleted from Firestore");
  //   } catch (e) {
  //     print("Failed to delete prescription renewal: $e");
  //   }
  // }

  // // العمليات المتعلقة بالإشعارات
  // Future<void> insertNotification(NotificationModel notification) async {
  //   try {
  //     await firestore.collection('Notifications').doc(notification.notificationId.toString()).set(notification.toMap());
  //     print("Notification added to Firestore");
  //   } catch (e) {
  //     print("Failed to add notification: $e");
  //   }
  // }

  // Future<List<NotificationModel>> getNotifications(int userId) async {
  //   try {
  //     QuerySnapshot snapshot = await firestore
  //         .collection('Notifications')
  //         .where('user_id', isEqualTo: userId)
  //         .get();
  //     return snapshot.docs
  //         .map((doc) => NotificationModel.fromMap(doc.data() as Map<String, dynamic>))
  //         .toList();
  //   } catch (e) {
  //     print("Failed to fetch notifications: $e");
  //     return [];
  //   }
  // }

  // Future<void> deleteNotification(int id) async {
  //   try {
  //     await firestore.collection('Notifications').doc(id.toString()).delete();
  //     print("Notification deleted from Firestore");
  //   } catch (e) {
  //     print("Failed to delete notification: $e");
  //   }
  // }
}
