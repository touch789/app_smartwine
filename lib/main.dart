import 'package:baby_names/screen/home.dart';
import 'package:baby_names/screen/login.dart';
import 'package:baby_names/screen/rechercher.dart';
import 'package:baby_names/screen/register.dart';
import 'package:baby_names/screen/splash.dart';
import 'package:baby_names/screen/task.dart';
import 'package:flutter/material.dart';


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
