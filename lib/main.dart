import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          //   headline6: TextStyle(
          //   color: Colors.white,
          //   fontSize: 35,
          //   fontWeight: FontWeight.bold
          // ),
          //   headline6: TextStyle(
          //   color: Colors.white,
          //   fontSize: 20,
          //   //fontWeight: FontWeight.bold
          // ),
          bodyText1: TextStyle(
            color: Colors.black,
            fontSize: 26,
          ),
          bodyText2: TextStyle(
            color: Colors.black,
            fontSize: 20,
            //fontWeight: FontWeight.bold
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
