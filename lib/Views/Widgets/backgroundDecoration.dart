import 'package:flutter/material.dart';

BoxDecoration backgroundDecoration() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.white, Colors.white],
    ),
    image: DecorationImage(
      image: AssetImage("images/background.png"),
      fit: BoxFit.fill,
    ),
  );
}
