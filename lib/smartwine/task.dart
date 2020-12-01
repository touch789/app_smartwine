import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';




class BottlePage extends StatelessWidget {
  BottlePage({@required this.title, this.description, this.designation, this.country, this.province, this.variety, this.winery, this.region, this.id,this.usid});

  String title ;
  String description;
  String  designation;
  String  country;
  String  province;
  String  region;
  String  variety;
  String  winery;
  final  id;
  final usid;



  FirebaseUser currentUser;



  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }



  void deleteBottle ( String id,BuildContext context ) async{
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
              title:"My Wine Cellar",
              uid: usid,
            )),
            (_) => false);

    Firestore.instance
        .collection("users")
        .document(usid)
        .collection('bottle')
        .document(id).delete();
    DocumentSnapshot variable = await Firestore.instance.collection('users').document(usid).collection('compteur').document('count').get();
    int nb = int.parse(variable.data["count"]);

    Firestore.instance.collection('users').document(usid).collection('compteur').document('count').setData(
        {"count":(nb-1).toString()});

  }

  @override
  Widget build(BuildContext context) {
        return StreamBuilder(
            stream: Firestore.instance.collection('users').document(usid)
                .collection("bottle").document(id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Text('Loading data.... please wait...');
              return Scaffold(
                  appBar: AppBar(
                    title: Text('Bottle : '+snapshot.data['title']),
                  ),
                  body : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Nom : ' + snapshot.data['title']),
                      Text('Designation  :' + snapshot.data['designation']),
                      Text('Variety  :' + snapshot.data['variety']),
                      Text('Winery :' + snapshot.data['winery']),
                      Text('Country :' + snapshot.data['country']),
                      Text('Region :' + snapshot.data['region']),
                      Text('Province :' + snapshot.data['province']),
                      Text('Description : ' + snapshot.data['description']),
                      RaisedButton(
                          child: Text('Delete this bottle '),
                          color: Theme
                              .of(context)
                              .primaryColor,
                          textColor: Colors.white,
                          onPressed: () => deleteBottle(id, context)),
                      RaisedButton(
                          child: Text("Modify bottle's information "),
                          color: Theme
                              .of(context)
                              .primaryColor,
                          textColor: Colors.white,
                          onPressed: () => _showDialog(context)),
                    ],
                  )
                  )
              );
            }

    );
  }










  _showDialog(BuildContext context) async {
    TextEditingController BottleTitleInputController = new TextEditingController(text: title);
    TextEditingController BottleDescripInputController= new TextEditingController(text: description);
    TextEditingController BottleCountryInputController= new TextEditingController(text: country);
    TextEditingController BottleDesignationInputController= new TextEditingController(text: designation);
    TextEditingController BottleProvinceInputController= new TextEditingController(text: province);
    TextEditingController BottleregionInputController= new TextEditingController(text: region);
    TextEditingController BottlevarietyInputController= new TextEditingController(text: variety);
    TextEditingController BottleWineryInputController= new TextEditingController(text: winery);
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          children: <Widget>[
            Text("Please fill all fields to add your new bottle"),
            Expanded(
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Bottle Title'),
                controller: BottleTitleInputController,
              ),
            ),
            Expanded(
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Bottle Designation'),
                controller: BottleDesignationInputController,
              ),
            ),
            Expanded(
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Bottle Variety'),
                controller: BottlevarietyInputController,
              ),
            ),
            Expanded(
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Bottle Country'),
                controller: BottleCountryInputController,
              ),
            ),
            Expanded(
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Bottle Province'),
                controller: BottleProvinceInputController,
              ),
            ),
            Expanded(
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Bottle Region'),
                controller: BottleregionInputController,
              ),
            ),
            Expanded(
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Bottle Winery'),
                controller: BottleWineryInputController,
              ),
            ),
            Expanded(
              child: TextFormField(
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
              child: Text('Update'),
              onPressed: () {

                  Firestore.instance
                      .collection("users")
                      .document(usid)
                      .collection('bottle')
                      .document(id).updateData({
                    "title": BottleTitleInputController.text,
                    "description": BottleDescripInputController.text,
                    "country" : BottleCountryInputController.text,
                    "designation" : BottleDesignationInputController.text,
                    "province" : BottleProvinceInputController.text,
                    "region" : BottleregionInputController.text,
                    "variety" : BottlevarietyInputController.text,
                    "winery" : BottleWineryInputController.text,
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
              )
        ],
      ),
    );
  }
}
