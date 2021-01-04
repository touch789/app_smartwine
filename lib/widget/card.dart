import 'package:baby_names/screen/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PlanetRow extends StatelessWidget {
  PlanetRow({@required this.title, this.id, this.usid,this.variety});

  final title;
  final id;
  final usid;
  final variety;


  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BottlePage(
                      id: id,
                      uid: usid,
                    )));
      },
      onLongPress: () {
        print('Button Clicked.');
      },
      child: Container(

          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0,
          ),
          child: new Stack(
            children: <Widget>[
              planetCard(title, variety),
              planetThumbnail("fiollewhite"),
            ],
          )),
    );
  }


  Widget planetThumbnail(String test) {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 20.0),
      alignment: FractionalOffset.centerLeft,
      child: new Image(
        image: new AssetImage("lib/assets/img/"+test+".png"),
        height: 80.0,
        width: 80.0,
      ),
    );
  }


  Widget planetCard(String title, String variety) {
    return new Container(
      padding: const EdgeInsets.only(left : 40.0, top: 22),
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
        new Text(title,

        ),
        new Container(height: 10.0),
        new Text(variety,

        ),

      ],
    ),
    );
  }
}



