import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills/Controller/dosage_controller.dart';
import 'package:pills/model/DosageSchedules.dart';
import 'package:pills/widgets/custom_text_field.dart';

class EditDosagePage extends StatefulWidget {
  static const String routes = "/EditDosagePage";
  const EditDosagePage({Key? key}) : super(key: key);

  @override
  _EditDosagePageState createState() => _EditDosagePageState();
}

class _EditDosagePageState extends State<EditDosagePage> {
  final controller = Get.put(DosageController());

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null && Get.arguments is DosageSchedule) {
      final dosageSchedule = Get.arguments as DosageSchedule;
      controller.loadDosage(dosageSchedule);
    } else {
      Get.snackbar("Error", "No dosage schedule found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('تعديل جرعة', style: TextStyle(fontSize: 16)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: TextEditingController(text: controller.dosageAmount),
                hintText: "اسم الجرعة",
                labelText: "اسم الجرعة",
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
              const SizedBox(height: 10),
              CustomTextField(
                controller: TextEditingController(text: controller.daysCount.toString()),
                kepord: TextInputType.number,
                hintText: "عدد الأيام",
                labelText: "عدد الأيام",
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'يرجى إدخال عدد الأيام';
                  }
                  return null;
                },
                onSaved: (value) {
                  controller.daysCount.value = int.parse(value!);
                },
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: "الآثار الجانبية",
                labelText: "الآثار الجانبية",
                controller: TextEditingController(text: controller.sideEffects),
                onSaved: (value) {
                  controller.sideEffects = value;
                },
              ),
              const SizedBox(height: 10),
              CustomTextField(
                labelText: "التحسن",
                hintText: "التحسن",
                controller: TextEditingController(text: controller.improvement),
                onSaved: (value) {
                  controller.improvement = value;
                },
              ),
              const SizedBox(height: 10),
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
                controller: TextEditingController(
                  text: controller.prescriptionDate != null
                      ? '${controller.prescriptionDate!.toLocal()}'.split(' ')[0]
                      : '',
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                labelText: 'تاريخ الجرعة',
                hintText: 'تاريخ الجرعة',
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
                controller: TextEditingController(
                  text: controller.scheduleTime != null
                      ? '${controller.scheduleTime!.toLocal()}'.split(' ')[0]
                      : '',
                ),
              ),
              const SizedBox(height: 10),
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
                controller: TextEditingController(
                  text: controller.dosageHour != null
                      ? '${controller.dosageHour!.hour}:${controller.dosageHour!.minute.toString().padLeft(2, '0')}'
                      : '',
                ),
              ),
              Row(
                children: [
                  Obx(() => Checkbox(
                    value: controller.notificationEnabled.value,
                    onChanged: (value) {
                      controller.notificationEnabled.value = value!;
                    },
                  )),
                  const Text('تفعيل الإشعارات')
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.submitUpdate();
                },
                child: const Text('تعديل الجرعة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
