import 'package:flutter/material.dart';

class CustomButtonStyle {
  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ), backgroundColor: Colors.cyan,
    elevation: 4.0,
    splashFactory: InkRipple.splashFactory,
  );
}

Widget targetSubmitButton(Function handleSubmit) {
  return SizedBox(
    width: double.infinity,
    height: 60,
    child: ElevatedButton(
      style: CustomButtonStyle.buttonStyle,
      onPressed: handleSubmit(),
      child: const Text(
        'Save',
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 24,
        ),
      ),
    ),
  );
}