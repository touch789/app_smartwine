import 'dart:developer';

import 'package:baby_names/screen/ajoutbouteille.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../widget/customCard.dart';
import 'package:hexcolor/hexcolor.dart';

class cellar extends StatefulWidget {
  cellar({Key key, this.title, this.uid})
      : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this

  @override
  _cellar createState() => _cellar();
}

class _cellar extends State<cellar> {
  FirebaseUser currentUser;

  @override
  initState() {
    this.getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: HexColor("#EB54A8")),
            onPressed: () => Navigator.pushNamed(context, "/splash"),
          ),
          backgroundColor: Colors.white,
          title: Text(
            widget.title,
            style: TextStyle(color: HexColor("#EB54A8")),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: HexColor("#EB54A8"),
              ),
              onPressed: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((result) =>
                        Navigator.pushReplacementNamed(context, "/login"))
                    .catchError((err) => print(err));
              },
            ),
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
                          );
                        }).toList(),
                      );
                  }
                },
              )),
        ),
        floatingActionButton: SpeedDial(
            marginRight: 18,
            marginBottom: 20,
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            // this is ignored if animatedIcon is non null
            // child: Icon(Icons.add),

            // If true user is forced to close dial manually
            // by tapping main button and overlay is not rendered.
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            tooltip: 'Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            backgroundColor: Colors.white,
            foregroundColor: HexColor("#EB54A8"),
            elevation: 4.0,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                  child: Icon(Icons.search, color: Colors.white),
                  backgroundColor: HexColor("#EB54A8"),
                  label: 'Search',
                  labelStyle: TextStyle(fontSize: 18.0),
                  onTap: () {
                    Navigator.pushNamed(context, "/SearchList");
                  }),
              SpeedDialChild(
                  child: Icon(Icons.add, color: Colors.white),
                  backgroundColor: HexColor("#EB54A8"),
                  label: 'Add Manually',
                  labelStyle: TextStyle(fontSize: 18.0),
                  onTap: () {
                    _showDialog();
                  }),
            ]));
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
      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AjoutBouteille(
                    uid: widget.uid,
                    action: "Add",
                    add: true,
                  )));
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
