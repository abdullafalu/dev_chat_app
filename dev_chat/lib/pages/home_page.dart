import 'package:dev_chat/helper/helper_function.dart';
import 'package:dev_chat/helper/services/auth_Services.dart';
import 'package:dev_chat/helper/services/database_Service.dart';
import 'package:dev_chat/pages/loggin_Page.dart';
import 'package:dev_chat/pages/profile_Page.dart';
import 'package:dev_chat/pages/seach_page.dart';
import 'package:dev_chat/shared/constant.dart';
import 'package:dev_chat/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthServices authServices = AuthServices();
  String userName = "";
  String email = "";
  Stream? group;
  bool _isloading = false;
  String groupName = "";
  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunction.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    //getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroup()
        .then((snapshot) {
      setState(() {
        group = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Groups',
          style: TextStyle(fontSize: 25, letterSpacing: 2),
        ),
        backgroundColor: Constant().primeryColor,
        actions: [
          IconButton(
            onPressed: () {
              nextScreenReplaced(context, const SearchPage());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          children: [
            const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 150,
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
                child: Text(
              userName.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              selectedColor: const Color.fromARGB(255, 203, 115, 109),
              selected: true,
              onTap: () {},
              leading: const Icon(
                Icons.group,
                size: 30,
              ),
              title: const Text(
                'Groups',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              onTap: () {
                nextScreenReplaced(
                    context,
                    ProfilePage(
                      email: email,
                      userName: userName,
                    ));
              },
              leading: const Icon(
                Icons.account_box,
                color: Colors.white,
                size: 30,
              ),
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout'),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                await authServices.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const LogginPage(),
                                    ),
                                    (route) => false);
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ))
                        ],
                      );
                    });
              },
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 30,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialoge(context);
        },
        child: Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: Constant().primeryColor,
        elevation: 0,
      ),
    );
  }

  groupList() {
    return StreamBuilder(
      stream: group,
      builder: (context, AsyncSnapshot snapshot) {
//checking data
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return const Text("Hello");
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(color: Constant().primeryColor),
          );
        }
      },
    );
  }

  popUpDialoge(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Constant().primeryColor,
          title: const Text(
            'Create a group',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _isloading == true
                  ? Center(
                      child: CircularProgressIndicator(
                          color: Constant().primeryColor),
                    )
                  : TextField(
                      onChanged: (val) {
                        setState(() {
                          groupName = val;
                        });
                      },
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (group != null) {
                  setState(() {
                    _isloading = true;
                  });
                  DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                      .createGroup(userName,
                          FirebaseAuth.instance.currentUser!.uid, groupName)
                      .whenComplete(() {
                    _isloading = false;
                  });
                  Navigator.of(context).pop();
                  snackBar(context, Colors.green, "Group successfully created");
                }
              },
                child: Text(
                "Create",
                style: TextStyle(color: Colors.black),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  noGroupWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  popUpDialoge(context);
                },
                child: const Icon(
                  Icons.add_circle,
                  size: 70,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "You've not joined any group,tap on the add icons below to join new groups and also search groups from top seach icon",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
