import 'dart:developer';

import 'package:baby_names/model/classBouteille.dart';
import 'package:baby_names/screen/cellar.dart';
import 'package:baby_names/smartwine/Services.dart';
import 'package:baby_names/smartwine/image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'ajoutbouteille.dart';
import 'bottleinfo.dart';
import 'home.dart';

// ignore: must_be_immutable
class BottlePage extends StatefulWidget {
  BottlePageState createState() => BottlePageState();
  BottlePage({@required this.id, this.uid});

  String title;
  String description;
  String designation;
  String country;
  String province;
  String region;
  String variety;
  String winery;
  String caveid;
  final id;
  final uid;



}
class BottlePageState extends State<BottlePage> {
  @override
  void initState() {
    super.initState();
   onItemChanged();
  }
  FirebaseUser currentUser;
  List<myBottle> newDataList = [];

  onItemChanged() async {
    await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection("bottle")
        .document(widget.id)
        .get().then((value) => widget.variety = value.data["variety"]);
    Services.getspecificBottles(widget.variety).then((employees) {
      setState(() {
        newDataList = employees.toList();
      });
    });
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  void deleteBottle(String location) async {

    await Firestore.instance.collection("users").document(widget.uid).get().then((DocumentSnapshot result) => widget.caveid = result.data["caveid"]);
   await Firestore.instance.collection("Cave").document(widget.caveid).collection("cellar").document(location).updateData({"detect":true});


  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(widget.uid)
            .collection("bottle")
            .document(widget.id)
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
                            uid: widget.uid,
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
                    height: 300,
                    child: FutureBuilder<List<String>>(
                      future: Datahelper.loadImagesFromGoogleTask(snapshot.data['title']),
                      builder: (context, item) {
                        if (item.hasData) {
                          String url = item.data.firstWhere((element) => element.contains(".png"), orElse: () => "https://assets.stickpng.com/thumbs/585ac2114f6ae202fedf2943.png");
                          if (url != ""){
                            return CachedNetworkImage(
                              useOldImageOnUrlChange: true,
                              imageUrl: url,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            );
                          }else{
                            return CachedNetworkImage(
                              useOldImageOnUrlChange: true,
                              imageUrl: "https://toppng.com/uploads/preview/red-wine-bottle-115469785000mn3ykraej.png",
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            );
                          }
                          // return Expanded(flex:1,child: Image.network(item.data[0],fit: BoxFit.cover, filterQuality: FilterQuality.low));

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
                  Text('Location in cellar : ' + snapshot.data['location']),

                  RaisedButton(
                      child: Text('Detect this bottle '),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () => deleteBottle(snapshot.data["location"])),
                  RaisedButton(
                      child: Text("Modify bottle's information "),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () => _showDialog( snapshot.data["title"],snapshot.data['designation'],snapshot.data['variety'],
                                  snapshot.data['winery'],snapshot.data['country'],snapshot.data['region'],snapshot.data['province'],
                                  snapshot.data['description'],snapshot.data['location'])),
                  Text("This selection of wine might also interest you :")
                  ,
                  Container(
                      height: 300.0,

                    child: ListView(
                    scrollDirection: Axis.horizontal,
                        children: newDataList.map((data) {
                          return Container(

                              width: 160.0,
                            child :InkWell(
                              onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BottleInfo(
                                        uid: widget.uid,
                                        title: data.title.toString(),
                                        variety: data.variety.toString(),
                                        country: data.country.toString(),
                                        province: data.province.toString(),
                                        designation: data.designation.toString(),
                                        description: data.description.toString(),
                                        winery: data.winery.toString(),
                                        region: data.region.toString(),
                                      ))),
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                margin: EdgeInsets.all(10),
                              child: Column (
                              children: <Widget>[
                                Container(
                                  height : 200,
                                  child: FutureBuilder<List<String>>(
                                    future: Datahelper.loadImagesFromGoogleTask(data.title),
                                    builder: (context, item) {
                                      if (item.hasData) {
                                        String url = item.data.firstWhere((element) => element.contains(".png"), orElse: () => "https://assets.stickpng.com/thumbs/585ac2114f6ae202fedf2943.png");
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
                                Text(data.title,textAlign: TextAlign.center),


                            ]))),


          );}).toList()))


                ],
              ))),
          );
        });
  }

  _showDialog(title,designation,variety,winery,country,region,province,description,location) async {

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AjoutBouteille(
              uid: widget.uid,
              bottleid: widget.id,
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
              locationin: location,
            )));


  }
}
