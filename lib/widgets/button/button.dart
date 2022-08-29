import 'package:flutter/material.dart';

class ButtonOn extends StatelessWidget {
  final String title;
  final void Function()? onPressed;

  const ButtonOn({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size(100, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            // side: BorderSide(color: Colors.blue),
          ),
        ),
        onPressed: onPressed,
        child: Text(title, style: const TextStyle(fontSize: 14)));
  }
}

class ButtonOff extends StatelessWidget {
  final String title;
  final void Function()? onPressed;

  const ButtonOff({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(100, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(color: Colors.blue),
          ),
        ),
        onPressed: onPressed,
        child: Text(title, style: const TextStyle(fontSize: 14)));
  }
}