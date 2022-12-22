import 'package:flutter/material.dart';

import '../shared/constant.dart';

final textInputDecoration = InputDecoration(
  labelStyle: TextStyle(
    
     fontWeight: FontWeight.w300,
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Constant().primeryColor,
      width: 2,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(30),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Constant().primeryColor,
      width: 2,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(30),
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(30),
    ),
  ),
);
