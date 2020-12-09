import 'package:baby_names/screen/checkCellarId.dart';
import 'package:baby_names/screen/cellar.dart';
import 'screen/home.dart';
import 'screen/login.dart';
import 'screen/rechercher.dart';
import 'screen/register.dart';
import 'screen/splash.dart';
import 'package:flutter/material.dart';
import 'screen/task.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  //test2
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
          '/home': (BuildContext context) => HomePage(),
          '/splash': (BuildContext context) => SplashPage(),
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
          '/SearchList': (BuildContext context) => ListSearch(),
          '/addBottle': (BuildContext context) => checkCellarId(),
          '/cellar': (BuildContext context) => cellar(),
          '/checkcaveid': (BuildContext context) => checkCellarId(),


        });
  }
}
