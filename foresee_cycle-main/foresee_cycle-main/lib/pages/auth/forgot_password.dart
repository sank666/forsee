import 'package:flutter/material.dart';

import 'package:foresee_cycles/utils/styles.dart';
import 'package:foresee_cycles/pages/auth/login.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
          children: <Widget>[
            Container(
              height: screenSize.height * 0.18,
              color: CustomColors.primaryColor,
              child: Padding(
                padding: EdgeInsets.only(top: screenSize.height * 0.02),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.keyboard_arrow_left,
                        color: CustomColors.secondaryColor,
                        size: screenSize.width * 0.08,
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.055,
                          color: CustomColors.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "Forgot password",
                            style: Theme.of(context).textTheme.headline6.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.headline6.color,
                                fontSize: 28),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                                "Enter your email address below and we'll\nsend you an email with instructions on how\nto change your password",
                            style: Theme.of(context).textTheme.headline6.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.headline6.color,
                                fontSize: 15),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'email cannot be empty';
                              }
                              return "";
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                              labelStyle: TextStyle(color: Colors.black26, fontSize: 8),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          InkWell(
                            onTap: () {
                              
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                              child: GestureDetector(
                                child: Container(
                                  height: 50.0,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: CustomColors.primaryColor,
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: Center(
                                    child: Text(
                                      'send'.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenSize.width * 0.06,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  print("Forgot Password Button Pressed");
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
    );
  }
}
