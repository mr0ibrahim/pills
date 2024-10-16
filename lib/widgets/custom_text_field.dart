import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final bool? readOnly;
  final TextInputType? kepord;
  final Function(String?)? onSaved;
  final Function()? onTap;
  const CustomTextField({
    super.key,
    this.onSaved,
    this.onTap,
    this.kepord,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.readOnly = false, // افتراضياً تكون غير مخفية
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly!,
      onTap: onTap,
      keyboardType: kepord,
      onSaved: onSaved,
      controller: controller,
      validator: validator,
      obscureText: obscureText!,
      decoration: InputDecoration(
        label: Text(
          labelText!,
          overflow: TextOverflow.visible,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black26,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
