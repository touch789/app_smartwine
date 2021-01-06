import 'package:baby_names/screen/bottleinfo.dart';
import 'package:baby_names/smartwine/image.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../smartwine/Services.dart';
import 'package:flutter/material.dart';
import '../model/classBouteille.dart';
import 'ajoutbouteille.dart';
import 'cellar.dart';
import 'package:hexcolor/hexcolor.dart';

class ListSearch extends StatefulWidget {
  ListSearchState createState() => ListSearchState();
  ListSearch({this.uid});
  final uid;
}

class ListSearchState extends State<ListSearch> {
  TextEditingController _textController = TextEditingController();

  // Copy Main List into New List.
  List<myBottle> newDataList = [];

  onItemChanged(String value) {
    Services.getspecificBottles(value).then((bottles) {
      setState(() {
        newDataList = bottles.toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: HexColor("#EB54A8"),
        title: Text(
          'MY CELLAR',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(

        children: <Widget>[
          new Container(
            color: HexColor("#FEF3FF"),
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: _textController,
                    decoration: new InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
                     onChanged: onItemChanged,
                  ),
                  trailing: new IconButton(
                    icon: new Icon(Icons.cancel),
                    onPressed: () {
                      _textController.clear();
                      // onSearchTextChanged('');
                    },
                    
                  ),
                ),
              ),
            ),
          ),
          new Expanded(

            child : Container(
              color: HexColor("#FEF3FF"),
            child: ListView(

              padding: EdgeInsets.all(12.0),

              children: newDataList.map((data) {
                return Card(
                    semanticContainer: true,
                    clipBehavior:
                    Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),

                    child :ListTile(

                      leading: SizedBox(
                        height: 50.0,
                        width: 50.0, // fixed width and height
                        child: FutureBuilder<List<String>>(
                          future: Datahelper.loadImagesFromGooglephp(data.title),
                          builder: (context, item) {
                            if (item.hasData) {
                              String url = item.data.first;
                              // return Expanded(flex:1,child: Image.network(item.data[0],fit: BoxFit.cover, filterQuality: FilterQuality.low));
                              return CachedNetworkImage(
                                useOldImageOnUrlChange: true,
                                imageUrl: url,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              );
                            } else if (item.hasError) {
                              return Text("${item.error}");
                            }

                            // By default, show a loading spinner.
                            return CircularProgressIndicator();
                          },
                        ),
                      ),
                      title: Text(data.title.toString()),
                      subtitle: Text(data.variety.toString()),
                      onTap: () => Navigator.push(
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
                                tempCons: data.tempCons.toString(),
                                tempService: data.tempService.toString(),
                              ))),
                    )
                );

              }).toList(),
            ),
          )
          )
        ],
      ),
    );
  }
}
