import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
    title: const Text('Volunteers'),
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