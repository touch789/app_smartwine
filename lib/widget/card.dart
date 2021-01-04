import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PlanetRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
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
    image: new AssetImage("lib/assets/img/fiollered.png"),
    height: 92.0,
    width: 92.0,
  ),
);

final planetCard = new Container(
  height: 124.0,
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
);
