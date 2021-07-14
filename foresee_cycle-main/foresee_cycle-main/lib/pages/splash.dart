import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:foresee_cycles/pages/welcome.dart';
import 'package:foresee_cycles/utils/constant_data.dart';
import 'home/home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    isUserSignedIn();
    super.initState();
  }
  void isUserSignedIn() {
    FirebaseAuth.instance
      .authStateChanges()
      .listen((User user) {
        if (user == null) {
          print('User is currently signed out!');
          //Navigate to welcomescreen
          Timer(Duration(seconds: 2), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WelcomeScreen())));
        } else {
          print('User is signed in!');
          //navigate to homescreen
          Timer(Duration(seconds: 2), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen())));
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    //find screen width and height
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRect(            
                child: CircleAvatar(
                  backgroundImage: AssetImage(ConstantsData.splashImage),
                  radius: screenSize.width * 0.15,
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),
              Text(
                "Foresee Cycle",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width * 0.07,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
