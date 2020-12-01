import 'smartwine/addBottle.dart';
import 'smartwine/rechercher.dart';
import 'package:flutter/material.dart';
import 'smartwine/task.dart';
import 'smartwine/register.dart';
import 'smartwine/splash.dart';
import 'smartwine/login.dart';
import 'smartwine/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  //test
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
          '/addBottle': (BuildContext context) => addBottle(),
        });
  }
}
