// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final bool readOnly;
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextField(
                readOnly: readOnly,
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: labelText,
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.white),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 200, 99, 92)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lime),
                  ),
                ),
              ),
    );
  }
}
