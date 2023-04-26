import 'package:flutter/material.dart';
import '../providers/help_qna.dart';

import '../screens/homepage.dart';

class HelpScreen extends StatelessWidget {
  static const routeName = '/HelpPage';

  HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            centerTitle: true,
            title: const Text(
              "Help",
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
        body: ListView.builder(
            itemCount: QnA.length,
            itemBuilder: (BuildContext ctx, int index) {
              return Container(
                height: 120,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(100), blurRadius: 10.0),
                    ]),
                padding:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                child: Card(
                    child: ListTile(
                  tileColor: Colors.white,
                  title: Text(
                    QnA[index].question,
                    style: TextStyle(fontSize: 25),
                  ),
                  subtitle: Text(
                    QnA[index].answer,
                    style: TextStyle(fontSize: 18),
                  ),
                )),
              );
            }));
  }
}
