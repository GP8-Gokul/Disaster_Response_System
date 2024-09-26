// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  const CustomAppbar({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
    title: Text(text),
    centerTitle: true,
    backgroundColor: const Color.fromARGB(57, 0, 0, 0),
    titleTextStyle: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.black),
  );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
