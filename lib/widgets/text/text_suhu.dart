import 'package:flutter/material.dart';

class TextSuhu extends StatelessWidget {
  const TextSuhu({
    Key? key,
    required this.title,
    required this.dataSuhu,
  }) : super(key: key);

  final String title;
  final String dataSuhu;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            dataSuhu,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}