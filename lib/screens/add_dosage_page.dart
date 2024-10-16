import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills/Controller/dosage_controller.dart';
import 'package:pills/widgets/custom_text_field.dart';

class AddDosagePage extends StatelessWidget {
  static const String routes = "/AddDosagePage";
  final controller = Get.put(DosageController()); // استدعاء الـ Controller

  AddDosagePage({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على حجم الشاشة
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('إضافة جرعة', style: TextStyle(fontSize: 16)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Padding يعتمد على عرض الشاشة
        child: Form(
          key: controller.formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView( // للسماح بالتمرير عند الشاشات الصغيرة
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    CustomTextField(
                      controller: TextEditingController(text: controller.dosageAmount),
                      hintText: "اسم الجرعه",
                      labelText: "اسم الجرعه",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يرجى إدخال اسم الجرعة';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        controller.dosageAmount = value;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02), // الحجم النسبي لتباعد الحقول
                    CustomTextField(
                      controller: TextEditingController(text: controller.daysCount.toString()),
                      kepord: TextInputType.number,
                      hintText: "عدد الايام",
                      labelText: "عدد الأيام",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يرجى إدخال عدد الأيام';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        controller.daysCount.value = int.parse(value!); // تعديل لقيمة قابلة للمراقبة
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      hintText: "الآثار الجانبية",
                      labelText: "الآثار الجانبية",
                      controller: TextEditingController(text: controller.sideEffects),
                      onSaved: (value) {
                        controller.sideEffects = value;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      labelText: "التحسن",
                      hintText: "التحسن",
                      controller: TextEditingController(text: controller.improvement),
                      onSaved: (value) {
                        controller.improvement = value;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      labelText: 'تاريخ الوصفة',
                      hintText: 'تاريخ الوصفة',
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: controller.prescriptionDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          controller.updatePrescriptionDate(pickedDate);
                        }
                      },
                      readOnly: true,
                      controller: controller.prescriptionDateController,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      hintText: 'تاريخ الجرعة',
                      labelText: 'تاريخ الجرعة',
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: controller.scheduleTime ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          controller.updateScheduleTime(pickedDate);
                        }
                      },
                      readOnly: true,
                      controller: controller.scheduleTimeController,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      labelText: 'توقيت الجرعة بالساعات',
                      hintText: 'توقيت الجرعة بالساعات',
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: controller.dosageHour ?? TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          controller.updateDosageHour(pickedTime);
                        }
                      },
                      readOnly: true,
                      controller: controller.dosageHourController,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      children: [
                        Obx(() => Checkbox(
                              value: controller.notificationEnabled.value,
                              onChanged: (value) {
                                controller.notificationEnabled.value = value!;
                              },
                            )),
                        const Text('تفعيل الإشعارات'),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03), // تباعد إضافي
                    Center(
                      child: ElevatedButton(
                        onPressed: controller.submit,
                        child: const Text('إضافة جرعة'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
