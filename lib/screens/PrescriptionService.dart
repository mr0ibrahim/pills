import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pills/model/Prescription.dart';
import 'package:pills/model/user_model.dart';
import 'package:pills/service/ImageUploadHelper.dart';
import 'package:pills/service/frebase_helper.dart';
import 'package:image_picker/image_picker.dart';

class AddPrescriptionRenewalPage extends StatefulWidget {
  @override
  _AddPrescriptionRenewalPageState createState() => _AddPrescriptionRenewalPageState();
}

class _AddPrescriptionRenewalPageState extends State<AddPrescriptionRenewalPage> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreHelper _firestoreHelper = FirestoreHelper();
  final ImagePicker _picker = ImagePicker();
  String? selectedDoctor;
  List<UserModel> doctors = [];

  String medicationName = '';
  String patientId = '';
  DateTime? requestDate;
  String status = 'تم تقديمه'; // الحالة الافتراضية
  DateTime? prescriptionDate;
  String prescriptionImage = '';

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    List<UserModel> fetchedDoctors = await _firestoreHelper.getUsers();
    setState(() {
      doctors = fetchedDoctors.where((doctor) => doctor.role == 'doctor').toList(); // تأكد من أن لديك حقل يحدد دور المستخدم
    });
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String downloadUrl = await ImageUploadHelper().uploadImage(pickedFile.path);
      setState(() {
        prescriptionImage = downloadUrl; // حفظ رابط الصورة بعد الرفع
      });
    }
  }

  void submitRequest() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      PrescriptionRenewalRequest newRequest = PrescriptionRenewalRequest(
        doctor: selectedDoctor!,
        id: DateTime.now().millisecondsSinceEpoch.toString(), // استخدام الطابع الزمني كمعرف
        medicationName: medicationName,
        patientId: patientId,
        requestDate: DateTime.now(),
        status: status,
        prescriptionDate: prescriptionDate!,
        prescriptionImage: prescriptionImage,
      );

      await _firestoreHelper.insertPrescriptionRenewal(newRequest);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة طلب تجديد وصفة طبية'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedDoctor,
                hint: Text('اختر طبيباً'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDoctor = newValue;
                  });
                },
                items: doctors.map<DropdownMenuItem<String>>((UserModel doctor) {
                  return DropdownMenuItem<String>(
                    value: doctor.id.toString(),
                    child: Text(doctor.name.toString()), // افترض أن لديك حقل name في نموذج UserModel
                  );
                }).toList(),
                validator: (value) => value == null ? 'يرجى اختيار طبيب' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'اسم الدواء'),
                onSaved: (value) => medicationName = value ?? '',
                validator: (value) => value!.isEmpty ? 'يرجى إدخال اسم الدواء' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'معرف المريض'),
                onSaved: (value) => patientId = value ?? '',
                validator: (value) => value!.isEmpty ? 'يرجى إدخال معرف المريض' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'تاريخ الوصفة الطبية'),
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    prescriptionDate = DateTime.tryParse(value);
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'يرجى إدخال تاريخ الوصفة الطبية';
                  } else if (DateTime.tryParse(value) == null) {
                    return 'يرجى إدخال تاريخ صحيح';
                  }
                  return null;
                },
              ),
              // زر لرفع الصورة
              ElevatedButton(
                onPressed: pickImage,
                child: Text('رفع صورة الوصفة الطبية'),
              ),
              // عرض رابط الصورة المرفوعة
              if (prescriptionImage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('تم رفع الصورة بنجاح: $prescriptionImage'),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitRequest,
                child: Text('إرسال الطلب'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
