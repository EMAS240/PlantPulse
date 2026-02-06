import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowErrorSnackbar {
  void ErrorSnackbar(String message, Color color) {
    print(message);
    Get.snackbar(
      'Error',
      message,
      backgroundColor: color,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      animationDuration: Duration(milliseconds: 500),
      borderRadius: 10,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeOutBack,
      titleText: Text(
        'Error',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      messageText: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
