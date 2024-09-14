import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String nomchamp;

  final TextEditingController controller;
  final Icon iconChoice;
  const MyTextField(
      {super.key,
      required this.nomchamp,
      required this.iconChoice,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        height: 50,
        width: 500,
        child: TextFormField(
          controller: controller,
          validator: (String? value) {
            if (value!.isEmpty) {
              return "le champs ne doit pas etre vide";
            }
            return null;
          },
          autofocus: true,
          decoration: InputDecoration(
            icon: iconChoice,
            border: InputBorder.none,
            hintText: nomchamp,
            hintStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
