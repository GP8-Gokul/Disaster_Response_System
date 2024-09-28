// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController searchController;
  const SearchTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                  width: 2.0),
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.black,
                cursorWidth: 2.0,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: labelText,
                  labelStyle: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    ),
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5), 
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: Colors.white,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
        );
  }
}
