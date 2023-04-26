import 'package:flutter/material.dart';
import '../screens/homepage.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 55,
      width: 200,
      child: RaisedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(HomePage.routeName, arguments: '');
        },
        color: const Color.fromARGB(255, 0, 0, 255),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Text(
          "Login",
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 55,
      width: 200,
      child: RaisedButton(
        onPressed: () {},
        color: const Color.fromARGB(255, 0, 0, 255),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Text(
          "Sign Up",
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
      ),
    );
  }
}

class ResetPWButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 55,
      width: 250,
      child: RaisedButton(
        onPressed: () {},
        color: const Color.fromARGB(255, 0, 0, 255),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Text(
          "Send Security Code",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
