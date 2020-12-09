import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widget/customCard.dart';

final databaseReference =
    FirebaseDatabase.instance.reference().child("Bottle/2/data");

class cellar extends StatefulWidget {
  cellar({Key key, this.title, this.uid})
      : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this

  @override
  _cellar createState() => _cellar();
}

class _cellar extends State<cellar> {
  TextEditingController BottleTitleInputController;
  TextEditingController BottleDescripInputController;
  TextEditingController BottleCountryInputController;
  TextEditingController BottleDesignationInputController;
  TextEditingController BottleProvinceInputController;
  TextEditingController BottleregionInputController;
  TextEditingController BottlevarietyInputController;
  TextEditingController BottleWineryInputController;
  FirebaseUser currentUser;

  @override
  initState() {
    BottleTitleInputController = new TextEditingController();
    BottleDescripInputController = new TextEditingController();
    BottleCountryInputController = new TextEditingController();
    BottleDesignationInputController = new TextEditingController();
    BottleProvinceInputController = new TextEditingController();
    BottleregionInputController = new TextEditingController();
    BottlevarietyInputController = new TextEditingController();
    BottleWineryInputController = new TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, "/home"),
          ),
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
              padding: const EdgeInsets.all(20.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("users")
                    .document(widget.uid)
                    .collection('bottle')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Text('Loading...');
                    default:
                      return new ListView(
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return new CustomCard(
                              id: document.documentID,
                              usid: widget.uid,
                              title: document['title'],
                              description: document['description'],
                              designation: document['designation'],
                              country: document['country'],
                              province: document['province'],
                              region: document['region'],
                              variety: document['variety'],
                              winery: document['winery']);
                        }).toList(),
                      );
                  }
                },
              )),
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 31),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton(
                  onPressed: _showDialog,
                  child: Icon(Icons.add),
                ),
              ),
            ),
          ],
        ));
  }

  _showDialog() async {
    DocumentSnapshot variable = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('compteur')
        .document('count')
        .get();
    int nb = int.parse(variable.data["count"]);
    print(nb);
    if (nb <= 5) {
      await showDialog<String>(
        context: context,
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            children: <Widget>[
              Text("Please fill all fields to add your new bottle"),
              Expanded(
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Bottle Title'),
                  controller: BottleTitleInputController,
                ),
              ),
              Expanded(
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Bottle Designation'),
                  controller: BottleDesignationInputController,
                ),
              ),
              Expanded(
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Bottle Variety'),
                  controller: BottlevarietyInputController,
                ),
              ),
              Expanded(
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Bottle Country'),
                  controller: BottleCountryInputController,
                ),
              ),
              Expanded(
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Bottle Province'),
                  controller: BottleProvinceInputController,
                ),
              ),
              Expanded(
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Bottle Region'),
                  controller: BottleregionInputController,
                ),
              ),
              Expanded(
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Bottle Winery'),
                  controller: BottleWineryInputController,
                ),
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: 'Bottle Description*'),
                  controller: BottleDescripInputController,
                ),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  BottleTitleInputController.clear();
                  BottleDescripInputController.clear();
                  BottleCountryInputController.clear();
                  BottleDesignationInputController.clear();
                  BottleProvinceInputController.clear();
                  BottleregionInputController.clear();
                  BottlevarietyInputController.clear();
                  BottleWineryInputController.clear();
                  Navigator.pop(context);
                }),
            FlatButton(
                child: Text('Search'),
                onPressed: () {
                  Navigator.pushNamed(context, "/SearchList");
                }),
            FlatButton(
                child: Text('Search'),
                onPressed: () {
                  Navigator.pushNamed(context, "/graph");
                }),

            FlatButton(
                child: Text('Add'),
                onPressed: () {
                  if (BottleTitleInputController.text.isNotEmpty) {
                    Firestore.instance
                        .collection('users')
                        .document(widget.uid)
                        .collection('compteur')
                        .document('count')
                        .setData({"count": (nb + 1).toString()});
                    Firestore.instance
                        .collection("users")
                        .document(widget.uid)
                        .collection('bottle')
                        .add({
                          "title": BottleTitleInputController.text,
                          "description": BottleDescripInputController.text,
                          "country": BottleCountryInputController.text,
                          "designation": BottleDesignationInputController.text,
                          "province": BottleProvinceInputController.text,
                          "region": BottleregionInputController.text,
                          "variety": BottlevarietyInputController.text,
                          "winery": BottleWineryInputController.text,
                          "detect": false,
                        })
                        .then((result) => {
                              Navigator.pop(context),
                              BottleTitleInputController.clear(),
                              BottleDescripInputController.clear(),
                              BottleCountryInputController.clear(),
                              BottleDesignationInputController.clear(),
                              BottleProvinceInputController.clear(),
                              BottleregionInputController.clear(),
                              BottlevarietyInputController.clear(),
                              BottleWineryInputController.clear()
                            })
                        .catchError((err) => print(err));
                  }
                })
          ],
        ),
      );
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Wine cellar full"),
              content: Text(
                  "You can not add another bottle because your Wine cellar is full. Please delete a bottle before adding another one"),
            );
          });
    }
  }
}
