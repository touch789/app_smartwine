import 'dart:developer';

import 'package:baby_names/screen/cellar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final databaseReference =
    FirebaseDatabase.instance.reference().child("Bottle/2/data");

class HomePage extends StatefulWidget {
  HomePage({Key key, this.uid})
      : super(key: key); //update this to include the uid in the constructor
  final String uid; //include this

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser currentUser;

  @override
  initState() {
    this.getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  void readData() {
    databaseReference
        .orderByKey()
        .limitToFirst(5)
        .once()
        .then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
  }

  var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];
  var data1 = [0.0, -2.0, 3.5, -2.0, 0.5, 0.7, 0.8, 1.0, 2.0, 3.0, 3.2];

  List<CircularStackEntry> circularData = <CircularStackEntry>[
    new CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(700.0, Colors.pink, rankKey: 'Q1'),
      ],
      rankKey: 'Hygrometrie',
    ),
  ];

  Material myTextItems(String title, String subtitle) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material myCircularChart(String title) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: HexColor("#EB54A8"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularPercentIndicator(
                      backgroundColor: Colors.white,
                      progressColor: HexColor("#EB54A8"),
                      percent: 0.65,
                      animation: true,
                      radius: 100.0,
                      lineWidth: 12.0,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text(
                        "65%",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material myCircularItems(String title, String subtitle) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AnimatedCircularChart(
                      size: const Size(100.0, 100.0),
                      initialChartData: circularData,
                      chartType: CircularChartType.Pie,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material mychart1Items(String title) {
    return Material(
      color: HexColor("#EB54A8"),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: new Sparkline(
                      data: data,
                      lineColor: Colors.white,
                      pointSize: 8.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My wine cellar"),

        actions: <Widget>[
          FlatButton(
            child: Text("Log Out"),
            textColor: Colors.white,
            onPressed: () {
              FirebaseAuth.instance
                  .signOut()
                  .then((result) =>
                      Navigator.pushReplacementNamed(context, "/login"))
                  .catchError((err) => print(err));
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          color: HexColor("#FEF3FF"),
          child: StaggeredGridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: mychart1Items("Température"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: myCircularChart("Hygrometrie"),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: myTextItems("Mktg. Spend", "48.6M"),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: myTextItems("Users", "25.5M"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                    child: Text('appui ici pour la list des vins'),
                    color: Colors.red,

                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => cellar(
                              title:"My Wine Cellar",
                              uid: currentUser.uid,
                            )),
                            (_) => false)

                ),
              ),

            ],
            staggeredTiles: [
              StaggeredTile.extent(4, 250.0),
              StaggeredTile.extent(2, 250.0),
              StaggeredTile.extent(2, 120.0),
              StaggeredTile.extent(2, 120.0),
              StaggeredTile.extent(4, 250.0),
            ],
          ),
        ),
      ),
    );
  }
}
