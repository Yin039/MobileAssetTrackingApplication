import 'package:flutter/material.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import '../screens/advance_screen.dart';
import '../screens/list_screen.dart';
import '../screens/new_screen.dart';
import '../screens/help_screen.dart';

import '../fields/text_field_container.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  static const routeName = '/HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 1080,
            height: 260,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 255),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100)),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40,
                      child: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 0, 0, 255),
                        size: 60,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('Hi, XYZ', style: Theme.of(context).textTheme.bodyText1),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 200,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 0,
          ),
          Container(
            //alignment: Alignment(-0.5, -0.8),
            width: 250,
            child: TextFieldContainer(
              child: TextField(
                enableInteractiveSelection: false,
                readOnly: true,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: "       Tracking",
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    border: InputBorder.none),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(ListScreen.routeName, arguments: '');
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const SizedBox(
                width: 60,
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: IconButton(
                        icon: const Icon(Icons.add,
                            color: Color.fromARGB(255, 0, 0, 255)),
                        hoverColor: Colors.green,
                        focusColor: Colors.purple,
                        splashColor: Colors.grey,
                        disabledColor: Colors.amber,
                        iconSize: 40,
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(NewScreen.routeName, arguments: '');
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('New', style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
              const SizedBox(
                width: 60,
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: IconButton(
                        icon: const Icon(Icons.list,
                            color: Color.fromARGB(255, 0, 0, 255)),
                        hoverColor: Colors.green,
                        focusColor: Colors.purple,
                        splashColor: Colors.grey,
                        disabledColor: Colors.amber,
                        iconSize: 40,
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(ListScreen.routeName, arguments: '');
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('List', style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
              const SizedBox(
                width: 60,
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: IconButton(
                        icon: const Icon(Icons.search,
                            color: Color.fromARGB(255, 0, 0, 255)),
                        hoverColor: Colors.green,
                        focusColor: Colors.purple,
                        splashColor: Colors.grey,
                        disabledColor: Colors.amber,
                        iconSize: 40,
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AdvanceScreen.routeName);
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Advance', style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              SizedBox(
                width: 125,
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: IconButton(
                        icon: const Icon(Icons.help_rounded,
                            color: Color.fromARGB(255, 0, 0, 255)),
                        hoverColor: Colors.green,
                        focusColor: Colors.purple,
                        splashColor: Colors.grey,
                        disabledColor: Colors.amber,
                        iconSize: 40,
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(HelpScreen.routeName, arguments: '');
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Help', style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
              SizedBox(
                width: 60,
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: IconButton(
                        icon: const Icon(Icons.logout,
                            color: Color.fromARGB(255, 0, 0, 255)),
                        hoverColor: Colors.green,
                        focusColor: Colors.purple,
                        splashColor: Colors.grey,
                        disabledColor: Colors.amber,
                        iconSize: 40,
                        onPressed: () {
                          Navigator.of(context).pushNamed('/');
                          Provider.of<Auth>(context, listen: false).logout();
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Logout', style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 75,
          ),
          Text(
            'XYZ',
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
