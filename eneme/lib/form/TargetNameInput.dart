import 'package:flutter/material.dart';

/// The InputField for the Create and Edit a Target forms
Widget targetNameInput(TextEditingController targetNameController) {
  return SizedBox(
    width: double.infinity,
    height: 60,
    child:
    TextFormField(
      controller: targetNameController,
      decoration: InputDecoration(
        labelText: 'Pick a name for your target',
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
          ),
        ),
      ),
      keyboardType: TextInputType.text,
      validator: (val) {
        if (val?.isEmpty ?? true) {
          return 'Target name cannot be empty';
        } else {
          return null;
        }

      },
      style: const TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 24,
      ),
    ),
  );
}