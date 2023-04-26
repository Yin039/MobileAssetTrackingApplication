import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 50),
                Container(
                    padding: EdgeInsets.only(bottom: 400),
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/Logo.png"),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: AuthCard(),
                ),
                const SizedBox(height: 70),
                const Text(
                  'XYZ',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();
  bool _isVisible = true;
  bool _isVisible2 = true;

  @override
  void dispose() {
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'].toString(),
          _authData['password'].toString(),
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'].toString(),
          _authData['password'].toString(),
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  void updateStatus() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void updateStatus2() {
    setState(() {
      _isVisible2 = !_isVisible2;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              Text(
                (_authMode == AuthMode.Login) ? 'Login' : 'Sign Up',
                style: TextStyle(
                  fontSize: 45,
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  // width: size.width/1.5,
                  child: Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),

                          if (_authMode == AuthMode.Signup)
                            Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 40.0),
                                  height: 50,
                                  width: size.width * 0.8,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                            offset: Offset(2, 3),
                                            blurRadius: 5,
                                            color:
                                                Color.fromARGB(255, 0, 0, 255))
                                      ]),
                                ),
                                TextFormField(
                                  enabled: _authMode == AuthMode.Signup,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(70.0, 0, 20, 0),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Username",
                                    errorStyle: TextStyle(
                                      height: 1.5,
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        70.0, 17.0, 20.0, 20),
                                    // border: InputBorder.none
                                  ),
                                  obscureText: false,
                                  autocorrect: false,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Invalid username!';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _authData['username'] = value as String;
                                  },
                                ),
                              ],
                            ),

                          SizedBox(
                            height: 10,
                          ),

                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 40.0),
                                height: 50,
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(2, 3),
                                          blurRadius: 5,
                                          color: Color.fromARGB(255, 0, 0, 255))
                                    ]),
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(70.0, 0, 20, 0),
                                    child: Icon(
                                      Icons.email,
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Email",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(70.0, 17.0, 20.0, 20),
                                  // border: InputBorder.none
                                ),
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Invalid email!';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _authData['email'] = value as String;
                                },
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 40.0),
                                height: 50,
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(2, 3),
                                          blurRadius: 5,
                                          color: Color.fromARGB(255, 0, 0, 255))
                                    ]),
                              ),
                              TextFormField(
                                obscureText: _isVisible,
                                autocorrect: false,
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    prefixIcon: const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(70.0, 0, 20, 0),
                                      child: Icon(
                                        Icons.lock,
                                        color: Colors.black,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        70.0, 17.0, 20.0, 20),
                                    suffixIcon: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0.0, 0, 55, 5),
                                      child: IconButton(
                                        onPressed: () => updateStatus(),
                                        icon: Icon(_isVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        color: Colors.black,
                                      ),
                                    ),
                                    border: InputBorder.none),
                                controller: _passwordController,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 5) {
                                    return 'Password is too short!';
                                  }
                                },
                                onSaved: (value) {
                                  _authData['password'] = value as String;
                                },
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          if (_authMode == AuthMode.Signup)
                            Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 40.0),
                                  height: 50,
                                  width: size.width * 0.8,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                            offset: Offset(2, 3),
                                            blurRadius: 5,
                                            color:
                                                Color.fromARGB(255, 0, 0, 255))
                                      ]),
                                ),
                                TextFormField(
                                  enabled: _authMode == AuthMode.Signup,
                                  obscureText: true,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                      hintText: "Confirm Password",
                                      prefixIcon: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(70.0, 0, 20, 0),
                                        child: Icon(
                                          Icons.lock,
                                          color: Colors.black,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          70.0, 17.0, 20.0, 20),
                                      suffixIcon: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0.0, 0, 55, 5),
                                        child: IconButton(
                                          onPressed: () => updateStatus2(),
                                          icon: Icon(_isVisible2
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                          color: Colors.black,
                                        ),
                                      ),
                                      border: InputBorder.none),
                                  validator: _authMode == AuthMode.Signup
                                      ? (value) {
                                          if (value !=
                                              _passwordController.text) {
                                            return 'Passwords do not match!';
                                          }
                                        }
                                      : null,
                                ),
                              ],
                            ),

                          SizedBox(
                            height: 10,
                          ),

                          if (_isLoading)
                            CircularProgressIndicator()
                          else
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              height: 55,
                              width: 200,
                              child: RaisedButton(
                                child: Text(
                                  _authMode == AuthMode.Login
                                      ? 'Login'
                                      : 'Sign Up',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                ),
                                onPressed: _submit,
                                color: const Color.fromARGB(255, 0, 0, 255),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 8.0),
                              ),
                            ),

                          //just for temporary only
                          // Container(
                          //   margin: EdgeInsets.symmetric(vertical: 10),
                          //   height: 55,
                          //   width: 200,
                          //   child: RaisedButton(
                          //     child: const Text("Login"),
                          //     onPressed: () {
                          //      Navigator.of(context)
                          //               .pushNamed(HomePage.routeName, arguments: '');
                          //     },
                          //   ),
                          // ),

                          FlatButton(
                            child: Text(
                                '${_authMode == AuthMode.Login ? 'New User Sign Up HERE' : 'Already have any account? Login'} '),
                            onPressed: _switchAuthMode,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 4),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            textColor: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
