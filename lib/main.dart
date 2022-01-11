import 'package:flutter/material.dart';

import 'login/login.dart';

void main() {
  runApp(const iCareApp());
}

class iCareApp extends StatelessWidget {
  const iCareApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iCare mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}