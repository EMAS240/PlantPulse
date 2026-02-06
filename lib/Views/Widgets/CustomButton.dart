import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label; // النص الظاهر على الزر
  final VoidCallback onPressed; // الوظيفة التي ينفذها الزر
  final Color backgroundColor; // لون الخلفية

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF3CAA3C), // لون افتراضي
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          minimumSize: const Size(100, 50),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
