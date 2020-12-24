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
class BottleInfo extends StatelessWidget {
  BottleInfo({ this.id, this.uid,this.title,this.province,this.region,this.country,this.winery,this.variety,this.description,this.designation} );

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

  @override
  Widget build(BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Bottle : ' + title),
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
                              future: Datahelper.loadImagesFromGoogleTask(title),
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
                          Text('Name : ' + title),
                          Text('Designation  :' + designation),
                          Text('Variety  :' + variety),
                          Text('Winery :' + winery),
                          Text('Country :' + country),
                          Text('Region :' + region),
                          Text('Province :' + province),
                          Text('Description : ' + description),
                          RaisedButton(
                              child: Text("Add to my cellar"),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: () => _showDialog(context,title,designation,variety,
                                  winery,country,region,province,
                                  description)),

                        ],
                      ))));

  }

  _showDialog(BuildContext context,title,designation,variety,winery,country,region,province,description) async {

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AjoutBouteille(
              uid: uid,
              bottleid: id,
              action: "Add",
              add: true,
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
