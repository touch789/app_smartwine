import '../smartwine/Services.dart';
import 'package:flutter/material.dart';
import '../smartwine/search.dart';
import '../model/classBouteille.dart';



class ListSearch extends StatefulWidget {
  ListSearchState createState() => ListSearchState();

}

class ListSearchState extends State<ListSearch> {

  TextEditingController _textController = TextEditingController();


  // Copy Main List into New List.
  List<Employee> newDataList =[];

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
      appBar: AppBar(
          title: Text('Search for a bottle')
      ),
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
                  title: Text(data.firstName.toString()),
                  subtitle: Text(data.lastName.toString()),
                  onTap: ()=> print(data.id),);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}