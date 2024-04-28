import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldTextFieldStyle() {
    return const TextStyle(
        color: Colors.black,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins');
  }

  static TextStyle HeadTextFieldStyle() {
    return const TextStyle(
        color: Colors.black,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins');
  }

  static TextStyle LightTextFieldStyle() {
    return const TextStyle(
        color: Colors.black38,
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins');
  }

    static TextStyle semiBoldTextFieldStyle() {
    return const TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins');
  }
}
