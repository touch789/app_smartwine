import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PlanetRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 24.0,
        ),
        child: new Stack(
          children: <Widget>[
            planetCard,
            planetThumbnail,
          ],
        ));
  }
}

final planetThumbnail = new Container(
  margin: new EdgeInsets.symmetric(vertical: 16.0),
  alignment: FractionalOffset.centerLeft,
  child: new Image(
    image: new AssetImage("assets/img/mars.png"),
    height: 92.0,
    width: 92.0,
  ),
);

final planetCard = new Container(
  height: 124.0,
  margin: new EdgeInsets.only(left: 46.0),
  color: Colors.white,
  padding: const EdgeInsets.all(8.0),
    child: FlatButton(
    color: HexColor("#EB54A8"),
    textColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24.0),
    ),
    child: Text(
      "My Bottles",
      style:
      TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
    ),
    onPressed: () => ,
),
);
