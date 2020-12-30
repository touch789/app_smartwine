import 'dart:developer';

import 'package:baby_names/screen/cellar.dart';
import 'package:baby_names/screen/settings.dart';
import 'package:baby_names/smartwine/cave.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  HomePage({Key key, this.uid, this.caveid})
      : super(key: key); //update this to include the uid in the constructor
  final String uid;
  final String caveid; //include this

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser currentUser;

  List<double> temp = [];
  String hygro;
  String test;

  @override
  initState() {
    this.getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
    var userref = Firestore.instance.collection("users").document(uid).get();
    /*DocumentSnapshot variable = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .get();
    print(variable.data["caveid"]);
    setState(() {
      widget.caveid = variable.data["caveid"];
    });*/
  }

  List<CircularStackEntry> circularData = <CircularStackEntry>[
    new CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(700.0, Colors.pink, rankKey: 'Q1'),
      ],
      rankKey: 'Hygrometrie',
    ),
  ];

  Material myTextItems(
      String title, String subtitle, Color colorCard, Color colorText) {
    return Material(
      color: colorCard,
      borderRadius: BorderRadius.circular(12.0),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 10.0,
                        color: colorText,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.0,
                        color: colorText,
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

  Material myBottleItems(String title) {
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
                      style:
                          TextStyle(fontSize: 20.0, color: Colors.blueAccent),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('users')
                              .document(widget.uid)
                              .collection("compteur")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return LinearProgressIndicator();
                            } else {
                              snapshot.data.documents.forEach((element) {
                                test = element.data["count"].toString();
                              });
                              return Text(
                                test,
                                style: TextStyle(
                                  fontSize: 30.0,
                                ),
                              );
                            }
                          })),
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('Cave')
                          .document(widget.caveid)
                          .collection("sensor")
                          .orderBy("date", descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return LinearProgressIndicator();
                        } else {
                          snapshot.data.documents.forEach((element) {
                            hygro = element.data["humi"].toString();
                          });
                          return CircularPercentIndicator(
                            backgroundColor: Colors.white,
                            progressColor: HexColor("#EB54A8"),
                            percent: double.parse(hygro) / 100,
                            animation: true,
                            radius: 100.0,
                            lineWidth: 12.0,
                            circularStrokeCap: CircularStrokeCap.round,
                            center: Text(
                              hygro + "%",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          );
                        }
                      },
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

  Material mychart1Items(String title, List<double> data) {
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
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      title + ":       " + data.last.toString() + "°C",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Sparkline(
                      lineColor: Colors.white,
                      lineWidth: 5.0,
                      data: data,
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
        backgroundColor: Colors.white,
        title: Text(
          "My Cellar",
          style: TextStyle(color: HexColor("#EB54A8")),
        ),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.settings, color: HexColor("#EB54A8")),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsOnePage(
                          uid: widget.uid,
                        ))),
          ),
        ],
      ),
      body: Center(
        child: Container(
          color: HexColor("#FEF3FF"),
          child: StaggeredGridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 12.0,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                    color: HexColor("#EB54A8"),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Text(
                      "My Bottles",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => cellar(
                                  title: "My Wine Cellar",
                                  uid: currentUser.uid,
                                )),
                        (_) => false)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: myCircularChart("Hygrometrie"),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child:
                    myTextItems("Red", "2", HexColor("#8C0B1F"), Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child:
                    myTextItems("Rosé", "1", HexColor("#D885A7"), Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: myTextItems(
                    "White", "2", HexColor("#FCEBCA"), Colors.grey[900]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('Cave')
                        .document(widget.caveid)
                        .collection("sensor")
                        .orderBy("date", descending: true)
                        .limit(10)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return LinearProgressIndicator();
                      } else {
                        snapshot.data.documents.forEach((element) {
                          temp.insert(0, element.data["temp"]);
                        });
                        return mychart1Items("Température", temp);
                      }
                    },
                  ),
                ),
              ),
            ],
            staggeredTiles: [
              StaggeredTile.extent(4, 250.0),
              StaggeredTile.extent(2, 200.0),
              StaggeredTile.extent(2, 50.0),
              StaggeredTile.extent(2, 50.0),
              StaggeredTile.extent(2, 50.0),
              StaggeredTile.extent(4, 250.0),
            ],
          ),
        ),
      ),
    );
  }
}
