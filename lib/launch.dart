import 'package:flutter/material.dart';
import 'package:group_assg/screens/new_screen.dart';
import '../screens/manager_screen.dart';
import '../screens/staff_screen.dart';
import 'package:provider/provider.dart';
import 'screens/advance_screen.dart';
import 'screens/homepage.dart';
import 'screens/list_screen.dart';
import 'screens/auth_screen.dart';
import 'providers/assets.dart';
import 'screens/help_screen.dart';
import './providers/auth.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Assets>(
          create: (ctx) => Assets(null, null,
              []), //Note: for dependencies version is version 4.00 above (in pubspec.yaml)=> must issue create:
          update: (ctx, auth, previousProducts) => Assets(
            //Note: for dependencies version is version 4.00 above (in pubspec.yaml)=> must use :update NOT a :builder..!
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => (MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: const TextTheme(
              bodyText1: TextStyle(
                color: Colors.black,
                fontSize: 26,
              ),
              bodyText2: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          home: auth.isAuth ? HomePage() : AuthScreen(),
          routes: <String, WidgetBuilder>{
            StaffScreen.routeName: (ctx) => StaffScreen(),
            ManagerScreen.routeName: (ctx) => ManagerScreen(),
            HomePage.routeName: (ctx) => HomePage(),
            ListScreen.routeName: (ctx) => ListScreen(),
            AdvanceScreen.routeName: (ctx) => const AdvanceScreen(),
            HelpScreen.routeName: (ctx) => HelpScreen(),
            NewScreen.routeName: (ctx) => const NewScreen(),
          },
        )),
      ),
    );
  }
}
