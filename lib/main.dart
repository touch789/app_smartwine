import 'screen/rechercher.dart';
import 'package:flutter/material.dart';

import 'screen/task.dart';
import 'screen/register.dart';
import 'screen/splash.dart';
import 'screen/login.dart';
import 'screen/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SmartWine',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          '/task': (BuildContext context) => BottlePage(title: 'Task'),
          '/home': (BuildContext context) => HomePage(title: 'Home'),
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
          '/SearchList': (BuildContext context) => ListSearch(),


        });
  }
}
