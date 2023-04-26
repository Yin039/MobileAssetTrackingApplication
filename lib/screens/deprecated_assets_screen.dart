import 'package:flutter/material.dart';

import 'homepage.dart';

class DeprecatedAssetsScreen extends StatelessWidget {
  const DeprecatedAssetsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            "Deprecatted Assets",
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
              // //Navigator.of(context).pushReplacement(MaterialPageRoute(
              //         builder: (BuildContext context) => Login()));
              Navigator.of(context)
                  .pushNamed(HomePage.routeName, arguments: '');
            },
          ),
        ),
      ),
      body: Column(
        children: [Card()],
      ),
    );
  }
}
