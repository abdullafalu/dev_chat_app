import 'package:flutter/material.dart';

class Constant{
  static String apiKey='AIzaSyBShwm_WaJIjEXxrd7t19mnu05xz0qYNRU';
  static String appId='1:759964036599:web:0a648f876e3676611292f2';
  static String messagingSenderId='759964036599';
  static String projectId='devchatappflutter';
  final primeryColor=Color.fromARGB(255, 0, 0, 0);

}

void nextScreen(context,page){
  Navigator.push(context,MaterialPageRoute(builder:(context) => page,));
}
void nextScreenReplaced(context,page){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page,));
}