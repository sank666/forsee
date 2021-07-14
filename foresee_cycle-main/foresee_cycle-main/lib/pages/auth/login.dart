import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foresee_cycles/pages/models.dart';

import 'package:foresee_cycles/utils/styles.dart';
import 'package:foresee_cycles/pages/auth/signup.dart';
import 'package:foresee_cycles/pages/home/home_page.dart';
import 'package:foresee_cycles/pages/auth/forgot_password.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _toggleVisibility = true;
  bool checkedValue = false;
  String userName, password;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userName, password: password);

      DocumentReference collectionReference = FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user.uid);

      var documents;
      collectionReference.snapshots().listen((snapshot) {
        print(documents[userCredential.user.uid]);
      });
      collectionReference.snapshots().listen((event) {
        setState(() {
          userdata.name = event.get('name');
          userdata.mbNo = event.get('phone');
          userdata.age = event.get('age');

          userdata.height = event.get('height');
          userdata.weight = event.get('weight');
          userdata.email = userCredential.user.email;
          print(userdata.name);
        });
      });
      // collectionReference2.snapshots().listen((snapshot) {
      //   setState(() {
      //     // userdata.name = snapshot.docs[userCredential.user.uid]['name'];
      //     // avgPeriodLength = snapshot.docs[0]['period_length'];
      //   });
      // });

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      print(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackbar("No user found for that email.");
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnackbar('Wrong password provided for that user.');
        print('Wrong password provided for that user.');
      }
    }
  }

  void showSnackbar(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.4, 0.7, 0.9],
            colors: [
              Color(0xFFffebbb),
              Color(0xFFfbceac),
              Color(0xFFf48988),
              Color(0xFFef6786),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
              left: screenSize.width * 0.07,
              right: screenSize.width * 0.07,
            ),
            child: Container(
              height: screenSize.height * 0.54,
              width: screenSize.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: screenSize.width * 0.095),
                  ),
                  Form(
                      key: formKey,
                      child: Padding(
                        padding: EdgeInsets.all(screenSize.height * 0.025),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: screenSize.height * 0.01,
                                top: screenSize.height * 0.01,
                              ),
                              child: Text(
                                'Email',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Material(
                              elevation: 5.0,
                              shadowColor: CustomColors.secondaryColor,
                              borderRadius: BorderRadius.circular(10),
                              child: TextFormField(
                                onSaved: (input) {
                                  setState(() {
                                    userName = input;
                                  });
                                  print('UserName: $input');
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintText: 'User Name',
                                  prefixIcon: Icon(Icons.alternate_email),
                                  labelStyle: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                validator: (input) => input.isEmpty
                                    ? 'User name field cannot be empty!'
                                    : null,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: screenSize.height * 0.01,
                                top: screenSize.height * 0.02,
                              ),
                              child: Text(
                                'Password',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Material(
                              elevation: 5.0,
                              shadowColor: CustomColors.secondaryColor,
                              borderRadius: BorderRadius.circular(10),
                              child: TextFormField(
                                onSaved: (input) {
                                  setState(() {
                                    password = input;
                                  });
                                  print('Password: $input');
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintText: 'Password',
                                  prefixIcon: Icon(Icons.lock_outline_rounded),
                                  labelStyle: TextStyle(
                                    fontSize: 16,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _toggleVisibility = !_toggleVisibility;
                                      });
                                    },
                                    icon: _toggleVisibility
                                        ? Icon(
                                            Icons.visibility_off,
                                            color: CustomColors.greyColor,
                                          )
                                        : Icon(
                                            Icons.visibility,
                                            color: CustomColors.greyColor,
                                          ),
                                  ),
                                ),
                                obscureText: _toggleVisibility,
                                validator: (input) => input.isEmpty
                                    ? 'Password field cannot be empty!'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      )),
                  CheckboxListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Remember Me',
                          style: TextStyle(
                            color: CustomColors.greyColor,
                          ),
                        ),
                        GestureDetector(
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              color: CustomColors.primaryColor,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()));
                          },
                        ),
                      ],
                    ),
                    value: checkedValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05),
                    child: GestureDetector(
                      child: Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: CustomColors.primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Center(
                          child: Text(
                            'login'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenSize.width * 0.06,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      onTap: () {
                        if (validateAndSave()) {
                          signIn();
                        }
                      },
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'If you have no an account ? ',
                      ),
                      GestureDetector(
                        child: Text(
                          'signUp'.toUpperCase(),
                          style: TextStyle(
                              color: CustomColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
