import 'dart:developer';

import 'package:baby_names/screen/cellar.dart';
import 'package:baby_names/smartwine/image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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

 /* @override
  Widget build(BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Bottle : ' + title),
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
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

  }*/

  @override
  Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Bottle : ' + title),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
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
                      child: Container (
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 8,
                          ),
                          borderRadius: BorderRadius.circular(30),

                        ),

                        child: Center (
                          child :Text(title, textAlign: TextAlign.center,style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white,)),

                        ),),


                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child:
                      Text('variety : ' + variety),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  Container(
                        height: 300,

                        child: FutureBuilder<List<String>>(
                          future: Datahelper.loadImagesFromGoogleTask(title),
                          builder: (context, item) {
                            if (item.hasData) {
                              String url = item.data.firstWhere((element) => element.contains(".png"), orElse: () => "https://assets.stickpng.com/thumbs/585ac2114f6ae202fedf2943.png");

                                return CachedNetworkImage(
                                  useOldImageOnUrlChange: true,
                                  imageUrl: url,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
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
                      child:
                      Text('winery : ' + winery),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child:
                      Text('designation : ' + designation),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child:
                      Text('Country : ' + country),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child:
                      Text('Region : ' + region),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child:
                      Text('Province : ' + province),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child:
                      Text('description : ' + description),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child:
                      Text('Température de service : 10 - 12 °C' ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all( 11.0),
                      child:RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Theme.of(context).primaryColor)
                          ),
                          child: Text("Add bottle to my cellar "),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () => _showDialog(context,title,designation,variety,
                              winery,country,region,province,
                              description)),
                    ),

                  ],
                  staggeredTiles: [
                    StaggeredTile.extent(4, 70.0),
                    StaggeredTile.extent(2, 50.0),
                    StaggeredTile.extent(2, 600.0),


                    StaggeredTile.extent(2, 50.0),
                    StaggeredTile.extent(2, 50.0),
                    StaggeredTile.extent(2, 50.0),
                    StaggeredTile.extent(2, 50.0),
                    StaggeredTile.extent(2, 50.0),
                    StaggeredTile.extent(2, 50.0),
                    StaggeredTile.extent(2, 200.0),
                    StaggeredTile.extent(4, 60.0),




                  ],
                ),
              ),
            ),
          );
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
