import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:foresee_cycles/pages/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foresee Cycles',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}