import 'package:baby_names/screen/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';

class PlanetRow extends StatelessWidget {
  PlanetRow(
      {@required this.title, this.id, this.usid, this.variety, this.color});

  final title;
  final id;
  final usid;
  final variety;
  final color;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BottlePage(
                      id: id,
                      uid: usid,
                    )));
      },
      onLongPress: () {
        _showMyDialog(context, id);
      },
      child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0,
          ),
          child: new Stack(
            children: <Widget>[
              planetCard(title, variety),
              planetThumbnail(color),
            ],
          )),
    );
  }

  Widget planetThumbnail(String test) {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 20.0),
      alignment: FractionalOffset.centerLeft,
      child: new Image(
        image: new AssetImage("lib/assets/img/" + test + ".png"),
        height: 80.0,
        width: 80.0,
      ),
    );
  }

  Widget planetCard(String title, String variety) {
    return new Container(
      padding: const EdgeInsets.only(left: 50.0, top: 22),
      //alignment: Alignment.center,
      height: 120.0,
      margin: new EdgeInsets.only(left: 46.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(3, 3),
          ),
        ],
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          new Container(height: 10.0),
          new Text(
            variety,
          ),
        ],
      ),
    );
  }


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
