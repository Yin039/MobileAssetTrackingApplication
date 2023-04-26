import 'dart:async';

import 'package:flutter/material.dart';
import 'homepage.dart';
import 'manager_screen.dart';
import '../providers/circle.dart';
import '../providers/keyboard.dart';
import '../screens/passcode_screen.dart';
import '../screens/staff_screen.dart';

const storedPasscode = '1234';
const storedPasscodeStaff = '5678';

class AdvanceScreen extends StatefulWidget {
  static const routeName = '/AdvancePage';

  const AdvanceScreen({Key? key}) : super(key: key);

  @override
  State<AdvanceScreen> createState() => _AdvanceScreenState();
}

class _AdvanceScreenState extends State<AdvanceScreen> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            "Advance",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 40,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            iconSize: 40,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(HomePage.routeName, arguments: '');
            },
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 0, 0, 255),
              radius: 140,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 210,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SecurityScreenButton(context),
                _SecurityScreenButton2(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _SecurityScreenButton(BuildContext context) => MaterialButton(
        color: Color.fromARGB(255, 0, 0, 255),
        child: Text('Manager',
            style: const TextStyle(fontSize: 16, color: Colors.white)),
        onPressed: () {
          _SecurityPinScreen(
            context,
            opaque: false,
            cancelButton: Text(
              'Cancel',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Cancel',
            ),
          );
        },
      );

  _SecurityPinScreen(
    BuildContext context, {
    required bool opaque,
    CircleUIConfig? circleUIConfig,
    KeyboardUIConfig? keyboardUIConfig,
    required Widget cancelButton,
    List<String>? digits,
  }) async {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
            title: Text(
              'Enter Passcode',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            cancelButton: cancelButton,
            deleteButton: Text(
              'Delete',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Delete',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: _onPasscodeCancelled,
            digits: digits,
            passwordDigits: 4,
          ),
        ));
  }

  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = storedPasscode == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ManagerScreen()));
    }
  }

  _SecurityScreenButton2(BuildContext context) => MaterialButton(
        color: Color.fromARGB(255, 0, 0, 255),
        child: Text('Staff',
            style: const TextStyle(fontSize: 16, color: Colors.white)),
        onPressed: () {
          _SecurityPinScreen2(
            context,
            opaque: false,
            cancelButton: Text(
              'Cancel',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Cancel',
            ),
          );
        },
      );

  _SecurityPinScreen2(
    BuildContext context, {
    required bool opaque,
    CircleUIConfig? circleUIConfig,
    KeyboardUIConfig? keyboardUIConfig,
    required Widget cancelButton,
    List<String>? digits,
  }) async {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
            title: Text(
              'Enter Passcode',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered2,
            cancelButton: cancelButton,
            deleteButton: Text(
              'Delete',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Delete',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: _onPasscodeCancelled,
            digits: digits,
            passwordDigits: 4,
          ),
        ));
  }

  _onPasscodeEntered2(String enteredPasscode) {
    bool isValid = storedPasscodeStaff == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => StaffScreen()));
    }
  }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }
}
