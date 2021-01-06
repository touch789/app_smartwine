import 'dart:developer';

import 'package:baby_names/model/classBouteille.dart';
import 'package:baby_names/screen/cellar.dart';
import 'package:baby_names/smartwine/Services.dart';
import 'package:baby_names/smartwine/image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
  var uid;
}

class BottlePageState extends State<BottlePage> {
  FirebaseAuth auth;
  @override
  void initState() {
    auth = FirebaseAuth.instance;
    //getCurrentUser();
    onItemChanged();
    super.initState();
  }

  List<myBottle> newDataList = [];

  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      widget.uid = user.uid;
    });
  }

  onItemChanged() async {
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      widget.uid = user.uid;
    });
    await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection("bottle")
        .document(widget.id)
        .get()
        .then((value) => widget.variety = value.data["variety"]);
    Services.getspecificBottles(widget.variety).then((employees) {
      setState(() {
        newDataList = employees.toList();
      });
    });
  }

  void detectBottle(String location) async {
    await Firestore.instance
        .collection("users")
        .document(widget.uid)
        .get()
        .then(
            (DocumentSnapshot result) => widget.caveid = result.data["caveid"]);
    await Firestore.instance
        .collection("Cave")
        .document(widget.caveid)
        .collection("cellar")
        .document(location)
        .updateData({"detect": true});
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
              centerTitle: true,
              title: Text('MY CELLAR',
                  style: TextStyle(color: HexColor("#EB54A8"))),
              leading: new IconButton(
                icon:
                    new Icon(Icons.arrow_back_ios, color: HexColor("#EB54A8")),
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => cellar(
                              title: "My Wine Cellar",
                              uid: widget.uid,
                            )),
                    (_) => false),
              ),
              backgroundColor: Colors.white,
              elevation: 2,
            ),
            body: Center(
              child: Container(
                color: Colors.white,
                child: StaggeredGridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 12.0,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 7,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(snapshot.data['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: FutureBuilder<List<String>>(
                          future: Datahelper.loadImagesFromGoogleTask(
                              snapshot.data['title']),
                          builder: (context, item) {
                            if (item.hasData) {
                              String url = item.data.firstWhere(
                                  (element) => element.contains(".png"),
                                  orElse: () =>
                                      "https://images.vivino.com/thumbs/J7S2JZOERkW0yLU9yL2hNg_pb_x960.png");

                              return CachedNetworkImage(
                                useOldImageOnUrlChange: true,
                                imageUrl: url,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              );
                              // return Expanded(flex:1,child: Image.network(item.data[0],fit: BoxFit.cover, filterQuality: FilterQuality.low));

                            } else if (item.hasError) {
                              return Text("${item.error}");
                            }

                            // By default, show a loading spinner.
                            return CircularProgressIndicator();
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Card(
                        elevation: 0.5,
                        margin: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 0,
                        ),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.local_drink,
                                color: HexColor("#EB54A8"),
                              ),
                              title: Text("Variety : "),
                              subtitle: Text(
                                snapshot.data["variety"],
                                style: TextStyle(fontWeight: FontWeight.w600),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.invert_colors,
                                color: HexColor("#EB54A8"),
                              ),
                              title: Text("Color :"),
                              subtitle: Text(
                                snapshot.data["color"],
                                style: TextStyle(fontWeight: FontWeight.w600),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.date_range,
                                color: HexColor("#EB54A8"),
                              ),
                              title: Text("Year :"),
                              subtitle: Text(
                                snapshot.data["year"],
                                style: TextStyle(fontWeight: FontWeight.w600),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.grain,
                                color: HexColor("#EB54A8"),
                              ),
                              title: Text("Winery :"),
                              subtitle: Text(
                                snapshot.data["winery"],
                                style: TextStyle(fontWeight: FontWeight.w600),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.description,
                                color: HexColor("#EB54A8"),
                              ),
                              title: Text("Description : "),
                              subtitle: Text(
                                snapshot.data["description"],
                                style: TextStyle(fontWeight: FontWeight.w600),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.location_on,
                                color: HexColor("#EB54A8"),
                              ),
                              title: Text("Localisation :"),
                              subtitle: Text(
                                snapshot.data["country"] +
                                    ", " +
                                    snapshot.data["region"] +
                                    ", " +
                                    snapshot.data["province"],
                                style: TextStyle(fontWeight: FontWeight.w600),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.gps_fixed,
                                color: HexColor("#EB54A8"),
                              ),
                              title: Text("Location in cellar :"),
                              subtitle: Text(
                                snapshot.data["location"],
                                style: TextStyle(fontWeight: FontWeight.w600),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.thermo,
                                color: HexColor("#EB54A8"),
                              ),
                              title: Text("Temperature :"),
                              subtitle: Text(
                                "Serving temperature : " +
                                    snapshot.data["tempService"] +
                                    " °C \nConservation temperature: " +
                                    snapshot.data["tempCons"] +
                                    " °C",
                                style: TextStyle(fontWeight: FontWeight.w600),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SizedBox(
                                    height: 40,
                                    width: 160,
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        child: Text("MODIFY"),
                                        color: Theme.of(context).primaryColor,
                                        textColor: Colors.white,
                                        elevation: 0,
                                        onPressed: () => _showDialog(
                                            snapshot.data["title"],
                                            snapshot.data['designation'],
                                            snapshot.data['variety'],
                                            snapshot.data['winery'],
                                            snapshot.data['country'],
                                            snapshot.data['region'],
                                            snapshot.data['province'],
                                            snapshot.data['description'],
                                            snapshot.data['location'],
                                            snapshot.data["tempService"],
                                            snapshot.data["tempCons"],
                                            snapshot.data["year"],
                                            snapshot.data["color"]))),
                                SizedBox(
                                  height: 40,
                                  width: 160,
                                  child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      splashColor: Colors.pinkAccent[800],
                                      color: HexColor("#EB54A8"),
                                      textColor: Colors.white,
                                      child: Text('DETECT'),
                                      elevation: 0,
                                      onPressed: () => detectBottle(
                                          snapshot.data["location"])),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                          height: 300.0,
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: newDataList.map((data) {
                                return Container(
                                  width: 160.0,
                                  child: InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => BottleInfo(
                                                    uid: widget.uid,
                                                    title:
                                                        data.title.toString(),
                                                    variety:
                                                        data.variety.toString(),
                                                    country:
                                                        data.country.toString(),
                                                    province: data.province
                                                        .toString(),
                                                    designation: data
                                                        .designation
                                                        .toString(),
                                                    description: data
                                                        .description
                                                        .toString(),
                                                    winery:
                                                        data.winery.toString(),
                                                    region:
                                                        data.region.toString(),
                                                    tempService: data
                                                        .tempService
                                                        .toString(),
                                                    tempCons: data.tempCons
                                                        .toString(),
                                                  ))),
                                      child: Card(
                                          semanticContainer: true,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          elevation: 5,
                                          margin: EdgeInsets.all(10),
                                          child: Column(children: <Widget>[
                                            Container(
                                              height: 200,
                                              child:
                                                  FutureBuilder<List<String>>(
                                                future: Datahelper
                                                    .loadImagesFromGooglephp(
                                                        data.title),
                                                builder: (context, item) {
                                                  if (item.hasData) {
                                                    String url =
                                                        item.data.first;

                                                    // return Expanded(flex:1,child: Image.network(item.data[0],fit: BoxFit.cover, filterQuality: FilterQuality.low));
                                                    return CachedNetworkImage(
                                                      useOldImageOnUrlChange:
                                                          true,
                                                      imageUrl: url,
                                                      placeholder: (context,
                                                              url) =>
                                                          CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    );
                                                  } else if (item.hasError) {
                                                    return Text(
                                                        "${item.error}");
                                                  }

                                                  // By default, show a loading spinner.
                                                  return CircularProgressIndicator();
                                                },
                                              ),
                                            ),
                                            Text(
                                              data.title,
                                              textAlign: TextAlign.center,
                                            ),
                                          ]))),
                                );
                              }).toList())),
                    ),
                  ],
                  staggeredTiles: [
                    StaggeredTile.extent(4, 70.0),
                    StaggeredTile.extent(4, 300.0),
                    StaggeredTile.extent(4, 650.0),
                    StaggeredTile.extent(4, 316.0),
                  ],
                ),
              ),
            ),
          );
        });
  }

/*
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
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 300.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider),
                                ),
                                    child: Column(
                                      children: <Widget>[
                                        Text(snapshot.data["title"]),
                                      ],
                                    )
                              ),

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
  } */

  _showDialog(title, designation, variety, winery, country, region, province,
      description, location, tempservice, tempcons, annee, color) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AjoutBouteille(
                  uid: widget.uid,
                  bottleid: widget.id,
                  action: "Update",
                  add: false,
                  titlein: title,
                  descriptionin: description,
                  designationin: designation,
                  varietyin: variety,
                  wineryin: winery,
                  countryin: country,
                  regionin: region,
                  provincein: province,
                  locationin: location,
                  tempServicein: tempservice,
                  tempConsin: tempcons,
                  anneein: annee,
                  colorin: color,
                )));
  }
}
