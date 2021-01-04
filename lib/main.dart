import 'package:baby_names/screen/ajoutbouteille.dart';
import 'package:baby_names/screen/bottleinfo.dart';
import 'package:baby_names/screen/checkCellarId.dart';
import 'package:baby_names/screen/cellar.dart';
import 'package:baby_names/screen/settings.dart';
import 'screen/home.dart';
import 'screen/login.dart';
import 'screen/rechercher.dart';
import 'screen/register.dart';
import 'screen/splash.dart';
import 'package:flutter/material.dart';
import 'screen/task.dart';
import 'package:hexcolor/hexcolor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SmartWine',
        theme: ThemeData(
          primaryColor: HexColor("#EB54A8"),
          primarySwatch: Colors.pink,
        ),
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          '/task': (BuildContext context) => BottlePage(),
          '/home': (BuildContext context) => HomePage(),
          '/splash': (BuildContext context) => SplashPage(),
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
          '/SearchList': (BuildContext context) => ListSearch(),
          '/addBottle': (BuildContext context) => checkCellarId(),
          '/cellar': (BuildContext context) => cellar(),
          '/checkcaveid': (BuildContext context) => checkCellarId(),
          '/ajoutbouteille': (BuildContext context) => AjoutBouteille(),
          '/infobottle': (BuildContext context) => BottleInfo(),
          '/settings': (BuildContext context) => SettingsOnePage(),
        });
  }
}
