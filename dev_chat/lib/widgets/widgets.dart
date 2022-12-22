import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

void snackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration:const Duration(seconds: 2),
action: SnackBarAction(
  label: 'OK',
  onPressed: () {
    
  },
  textColor: Colors.white,
),
    ),
  );
}