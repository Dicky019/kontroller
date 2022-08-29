import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  const Error({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Error');
  }
}

class SwitchCostum extends StatelessWidget {
  final bool value;
  final String title;
  final void Function(bool)? onChanged;
  const SwitchCostum({
    Key? key,
    required this.value,
    this.onChanged,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Transform.scale(
          scale: 2.0,
          child: Switch(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}