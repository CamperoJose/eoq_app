import 'package:eoq_app/UI/login.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.orange,
          primaryColorDark: Colors.black,
          accentColor: Colors.black,
          backgroundColor: Colors.black,
          cardColor: Colors.black,
          errorColor: Colors.red,
          brightness: Brightness.dark,
        ),
      ),
      home: LoginView(),
    );
  }
}
