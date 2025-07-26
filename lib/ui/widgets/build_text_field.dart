import 'package:flutter/material.dart';

Widget buildTextField(
  TextEditingController controller,
  String label, {
  bool obscureText = false,
  String? hintText,
}) {
  final isEmail = label.toLowerCase().contains('email');
  final isPassword = label.toLowerCase().contains('password');

  return TextField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
    autocorrect: !isEmail && !isPassword,
    enableSuggestions: !isEmail && !isPassword,
    textCapitalization:
        isEmail || isPassword
            ? TextCapitalization.none
            : TextCapitalization.sentences,
    decoration: InputDecoration(
      labelText: label,
      hintText: hintText,
      filled: true,
      fillColor: Colors.indigo.shade100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
