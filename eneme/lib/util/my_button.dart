/*import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  VoidCallback onPressed;
  MyButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Theme.of(context).primaryColor,
      child: Text(text),
    );
  }
}*/
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final VoidCallback? onDateSelect;
  
  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.onDateSelect,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        if (text == 'Set Date' && onDateSelect != null) {
          onDateSelect!();
        } else {
          onPressed();
        }
      },
      color: Theme.of(context).primaryColor,
      child: Text(text),
    );
  }
}


