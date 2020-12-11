import 'dart:developer';

import 'package:baby_names/screen/cellar.dart';
import 'package:baby_names/smartwine/image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'ajoutbouteille.dart';
import 'home.dart';

// ignore: must_be_immutable
class BottlePage extends StatelessWidget {
  BottlePage({@required this.id, this.uid});

  String title;
  String description;
  String designation;
  String country;
  String province;
  String region;
  String variety;
  String winery;
  final id;
  final uid;

  FirebaseUser currentUser;

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  void deleteBottle(String id, BuildContext context) async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => cellar(
                  uid: uid,
                  title: "My wine cellar",
                )),
        (_) => false);

    Firestore.instance
        .collection("users")
        .document(uid)
        .collection('bottle')
        .document(id)
        .delete();
    DocumentSnapshot variable = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('compteur')
        .document('count')
        .get();
    int nb = int.parse(variable.data["count"]);

    Firestore.instance
        .collection('users')
        .document(uid)
        .collection('compteur')
        .document('count')
        .setData({"count": (nb - 1).toString()});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(uid)
            .collection("bottle")
            .document(id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data.... please wait...');
          return Scaffold(
              appBar: AppBar(
                title: Text('Bottle : ' + snapshot.data['title']),
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => cellar(
                            title: "My Wine Cellar",
                            uid: uid,
                          )),
                          (_) => false),
                ),
              ),
              body: SingleChildScrollView(
                child : Center(

                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: FutureBuilder<List<String>>(
                      future: Datahelper.loadImagesFromGoogleTask(snapshot.data['title']),
                      builder: (context, item) {
                        if (item.hasData) {
                          String url = item.data.firstWhere((element) => element.contains(".png"));
                          // return Expanded(flex:1,child: Image.network(item.data[0],fit: BoxFit.cover, filterQuality: FilterQuality.low));
                          return CachedNetworkImage(
                            useOldImageOnUrlChange: true,
                            imageUrl: url,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          );
                        } else if (item.hasError) {
                          return Text("${item.error}");
                        }

                        // By default, show a loading spinner.
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                  Text('Name : ' + snapshot.data['title']),
                  Text('Designation  :' + snapshot.data['designation']),
                  Text('Variety  :' + snapshot.data['variety']),
                  Text('Winery :' + snapshot.data['winery']),
                  Text('Country :' + snapshot.data['country']),
                  Text('Region :' + snapshot.data['region']),
                  Text('Province :' + snapshot.data['province']),
                  Text('Description : ' + snapshot.data['description']),
                  RaisedButton(
                      child: Text('Delete this bottle '),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () => deleteBottle(id, context)),
                  RaisedButton(
                      child: Text("Modify bottle's information "),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () => _showDialog(context, snapshot.data["title"],snapshot.data['designation'],snapshot.data['variety'],
                                  snapshot.data['winery'],snapshot.data['country'],snapshot.data['region'],snapshot.data['province'],
                                  snapshot.data['description'])),

                ],
              ))));
        });
  }

  _showDialog(BuildContext context,title,designation,variety,winery,country,region,province,description) async {

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AjoutBouteille(
              uid: uid,
              bottleid: id,
              action: "Update",
              add: false,
              titlein: title ,
              descriptionin: description,
              designationin: designation,
              varietyin: variety,
              wineryin: winery,
              countryin: country,
              regionin: region,
              provincein: province,
            )));


  }
}
