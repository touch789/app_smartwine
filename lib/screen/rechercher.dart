import 'package:baby_names/screen/bottleinfo.dart';

import '../smartwine/Services.dart';
import 'package:flutter/material.dart';
import '../model/classBouteille.dart';
import 'ajoutbouteille.dart';

class ListSearch extends StatefulWidget {
  ListSearchState createState() => ListSearchState();
  ListSearch({@required this.uid});
  final uid;
}

class ListSearchState extends State<ListSearch> {
  TextEditingController _textController = TextEditingController();

  // Copy Main List into New List.
  List<Employee> newDataList = [];

  onItemChanged(String value) {
    Services.getspecificEmployees(value).then((employees) {
      setState(() {
        newDataList = employees.toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search for a bottle')),
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
                  title: Text(data.title.toString()),
                  subtitle: Text(data.variety.toString()),
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
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
