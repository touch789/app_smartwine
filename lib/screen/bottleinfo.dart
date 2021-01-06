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
  BottleInfo({ this.id, this.uid,this.title,this.province,this.region,this.country,this.winery,this.variety,this.description,this.designation,this.tempService, this.tempCons} );

  String title;
  String description;
  String designation;
  String country;
  String province;
  String region;
  String variety;
  String winery;
  String tempService;
  String tempCons;

  final id;
  final uid;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Bottle informations: ',
            style: TextStyle(color: HexColor("#EB54A8"))),
        leading: new IconButton(
          icon:
          new Icon(Icons.arrow_back_ios, color: HexColor("#EB54A8")),
          onPressed: () => Navigator.pop(context)
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
                    child: Text(title,
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
                        title),
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
                        leading:
                        Icon(
                          Icons.local_drink,
                          color: HexColor("#EB54A8"),

                        ),
                        title: Text("Variety : "),
                        subtitle: Text(variety, style: TextStyle(fontWeight: FontWeight.w600),textAlign: TextAlign.justify,),
                      ),
                      
                      ListTile(
                        leading:
                        Icon(
                          Icons.local_drink,
                          color: HexColor("#EB54A8"),

                        ),
                        title: Text("Winery :"),
                        subtitle: Text(winery, style: TextStyle(fontWeight: FontWeight.w600),textAlign: TextAlign.justify,),
                      ),
                      ListTile(
                        leading:
                        Icon(
                          Icons.local_drink,
                          color: HexColor("#EB54A8"),

                        ),
                        title: Text("Description : "),
                        subtitle: Text(description, style: TextStyle(fontWeight: FontWeight.w600),textAlign: TextAlign.justify,),
                      ),
                      ListTile(
                        leading:
                        Icon(
                          Icons.local_drink,
                          color: HexColor("#EB54A8"),

                        ),
                        title: Text("Localisation :"),
                        subtitle: Text(country+", "+region+", "+province, style: TextStyle(fontWeight: FontWeight.w600),textAlign: TextAlign.justify,),
                      ),
                      
                      ListTile(
                        leading:
                        Icon(
                          Icons.local_drink,
                          color: HexColor("#EB54A8"),

                        ),
                        title: Text("Temperature :"),
                        subtitle: Text("Serving temperature : "+tempService+" °C \nConservation temperature: "+ tempCons+" °C", style: TextStyle(fontWeight: FontWeight.w600),textAlign: TextAlign.justify,),
                      ),
                      SizedBox(height: 15),
                      Center(
                          child:
                          SizedBox(
                            height: 40,
                            width: 200,
                            child: RaisedButton(
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




                      )



                    ],
                  ),
                ),
              ),
            ],
            staggeredTiles: [
              StaggeredTile.extent(4, 70.0),
              StaggeredTile.extent(4, 300.0),
              StaggeredTile.extent(4, 650.0),
              
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
              tempConsin: tempCons,
              tempServicein: tempService,
            )));


  }
}
