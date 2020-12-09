import '../screen/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  CustomCard(
      {@required this.title,
      this.id,
      this.usid});

  final title;
  final id;
  final usid;

  void deleteBottle(String id, BuildContext context) async {
    Firestore.instance
        .collection("users")
        .document(usid)
        .collection('bottle')
        .document(id)
        .delete();
    DocumentSnapshot variable = await Firestore.instance
        .collection('users')
        .document(usid)
        .collection('compteur')
        .document('count')
        .get();
    int nb = int.parse(variable.data["count"]);

    Firestore.instance
        .collection('users')
        .document(usid)
        .collection('compteur')
        .document('count')
        .setData({"count": (nb - 1).toString()});
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            child: Column(children: <Widget>[
      Padding(
        key: ValueKey(title),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text(title),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottlePage(
                          id: id,
                          usid: usid)));
            },
            onLongPress: () => _showMyDialog(context, id),
          ),
        ),
      )
    ])));
  }

  Future<void> _showMyDialog(BuildContext context, String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'If you really want to delete this bottle please press "Yes", otherwise press "No".'),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('Yes'),
              onPressed: () {
                deleteBottle(id, context);
              },
            ),
            RaisedButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
