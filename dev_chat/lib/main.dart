import 'package:dev_chat/helper/helper_function.dart';
import 'package:dev_chat/pages/home_page.dart';
import 'package:dev_chat/pages/loggin_Page.dart';
import 'package:dev_chat/shared/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    //run installation for web

    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: Constant.apiKey,
        appId: Constant.appId,
        messagingSenderId: Constant.messagingSenderId,
        projectId: Constant.projectId,
      ),
    );
  } else {
    //run installation for android
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignedIn = false;
  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Constant().primeryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home:isSignedIn? const HomePage():const LogginPage(),
    );
  }
}
