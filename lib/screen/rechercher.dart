import 'package:baby_names/screen/bottleinfo.dart';
import 'package:baby_names/smartwine/image.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../smartwine/Services.dart';
import 'package:flutter/material.dart';
import '../model/classBouteille.dart';
import 'ajoutbouteille.dart';
import 'cellar.dart';

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
      appBar: AppBar(title: Text('Search for a bottle'),
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
    ),),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Search Here...',
              ),
              onChanged: onItemChanged,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(12.0),
              children: newDataList.map((data) {
                return ListTile(

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
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
