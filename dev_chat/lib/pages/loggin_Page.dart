import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_chat/helper/helper_function.dart';
import 'package:dev_chat/helper/services/auth_Services.dart';
import 'package:dev_chat/helper/services/database_Service.dart';
import 'package:dev_chat/pages/home_page.dart';
import 'package:dev_chat/pages/register_page.dart';
import 'package:dev_chat/shared/constant.dart';
import 'package:dev_chat/widgets/text_input_decoration.dart';
import 'package:dev_chat/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogginPage extends StatefulWidget {
  const LogginPage({super.key});

  @override
  State<LogginPage> createState() => _LogginPageState();
}

class _LogginPageState extends State<LogginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthServices authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_isLoading?Center(child: CircularProgressIndicator(color: Constant().primeryColor,),): Form(
        key: formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 60, left: 15, right: 15, bottom: 30),
              child: Column(
                children: [
                  //put the main text
                  const Text(
                    'DevChat',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //put the subtext
                  const Text(
                    'Login now for making your codes easy',
                    style: TextStyle(color: Colors.grey),
                  ),
                  //put login page image
                  Image.asset('assets/images/chat.png'),
                  const SizedBox(
                    height: 0,
                  ),
                  //put the textfield
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      labelText: "Email",
                      labelStyle: const TextStyle(color: Colors.black),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.blue,
                      ),
                      hintText: 'Dev123@gmail.com',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
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
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.blue,
                        )),
                    validator: (val) {
                      if (val!.length < 8) {
                        return "Password must be atleast 8 character";
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
                    height: 20,
                  ),
                  //bottom signin button
                  SizedBox(
                    height: 42,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Constant().primeryColor),
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(
                          const StadiumBorder(),
                        ),
                      ),
                      onPressed: () {
                        login();
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 55),
                    child: Row(
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          child: const Text(
                            "Register here",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onTap: () {
                            nextScreen(
                              context,
                              const RegisterPage(),
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authServices
          .loginWithUserNameAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          //saving the value to our sf
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmailSF(email);
          await HelperFunction.saveUserNameSF(snapshot.docs[0]['fullName']);
          nextScreen(context, HomePage());
        }
        else{
          snackBar(context, Colors.red, value);
          setState(() {
            _isLoading=false;
          });
        }
      });
    }
  }
}
