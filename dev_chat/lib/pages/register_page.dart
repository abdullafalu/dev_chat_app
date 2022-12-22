import 'dart:ffi';

import 'package:dev_chat/helper/helper_function.dart';
import 'package:dev_chat/helper/services/auth_Services.dart';
import 'package:dev_chat/pages/home_page.dart';
import 'package:dev_chat/pages/loggin_Page.dart';
import 'package:dev_chat/shared/constant.dart';
import 'package:dev_chat/widgets/text_input_decoration.dart';
import 'package:dev_chat/widgets/widgets.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String fullName = "";
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthServices authServices = AuthServices();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: Constant().primeryColor),
            )
          : Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 60,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const Text(
                          'DevChat',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 42,
                          ),
                        ),
                        const Text(
                          'Create your account now to chat and explore',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 300,
                          child: Image.asset('assets/images/chat2.png'),
                        ),
                        const SizedBox(
                          height: 02,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            labelText: 'Full Name',
                            labelStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            prefixIcon: const Icon(
                              Icons.account_box,
                              color: Colors.blue,
                            ),
                            hintText: 'DevChat',
                          ),
                          onChanged: (val) {
                            setState(() {
                              fullName = val;
                            });
                          },
                          validator: (val) {
                            if (val!.isNotEmpty) {
                              return null;
                            } else {
                              return "Full name cannot be empty";
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: 'Email',
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.blue,
                              ),
                              hintText: 'devchat123@gmail.com'),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Please enter a valid email";
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.blue,
                            ),
                          ),
                          validator: (val) {
                            if (val!.length < 8) {
                              return "Password must be atleast 8 charecter";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 42,
                          child: ElevatedButton(
                            onPressed: () {
                               register();
                            },
                            child: Text(
                              'Register Now',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Constant().primeryColor),
                                shape: MaterialStateProperty.all(
                                    const StadiumBorder()),
                                elevation: MaterialStateProperty.all(0)),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 60),
                          child: Row(
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              GestureDetector(
                                child: const Text(
                                  'Login Now',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onTap: () {
                                  nextScreen(context, const LogginPage());
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authServices
          .registerUserWithEmailAndPassword(fullName, email, password)
          .then((value)async {
        if (value == true) {
          //saving the sharedprefernce state
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmailSF(email);
          await HelperFunction.saveUserNameSF(fullName);
          nextScreen(context,const HomePage());

        } else {
          snackBar(context,Colors.red,value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
