import 'package:baby_names/screen/cellar.dart';
import 'package:baby_names/screen/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




/*class AjoutBouteille extends StatefulWidget {
  AjoutBouteille({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AjoutBouteille createState() => new _AjoutBouteille();
}

class _AjoutBouteille extends State<AjoutBouteille> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];
  String _color = '';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text ('Welcome'),
            actions: <Widget>[


            ]
        ),
        body:  new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.add),
            backgroundColor: new Color(0xFFE57373),
            onPressed: (){
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new UploadFormField()),
              );

            }
        )
    );
  }

}*/



// UPLOAD TO FIRESTORE



class AjoutBouteille extends StatefulWidget {
  AjoutBouteille({Key key,this.action, this.add,this.uid, this.bottleid,this.titlein,this.locationin,this.designationin,this.descriptionin,this.countryin,this.provincein,this.regionin,this.varietyin,this.wineryin}) : super(key: key); //update this to include the uid in the constructor

  final String uid;
  String titlein, designationin,descriptionin,countryin,provincein,regionin,locationin,varietyin,wineryin,bottleid, action;
  bool add;
  //include this
  @override
  _AjoutBouteille createState() => _AjoutBouteille();
}

class _AjoutBouteille extends State<AjoutBouteille> {
  GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;

  String title, designation,description,country,province,region,variety,winery, emplacement;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),

      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.action+' your Bottle'),
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
          ),
        ),

        body: new SingleChildScrollView(
          child: new Container(
            margin: new EdgeInsets.all(15.0),
            child: new Form(
              key: _key,
              autovalidate: _validate,
              child: FormUI(),

            ),
          ),
        ),
      ),
    );
  }

  Widget FormUI() {
    return new Column(
      children: <Widget>[
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Title'),
            initialValue: widget.titlein,

            onSaved: (String val) {
              title = val;
            }
        ),

        new TextFormField(
            decoration: new InputDecoration(hintText: 'Designation'),
            validator: validateAuthor,
            initialValue: widget.designationin,
            onSaved: (String val) {
              designation = val;
            }
        ),
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Variety'),
            validator: validateAuthor,
            initialValue: widget.varietyin,
            onSaved: (String val) {
              variety = val;
            }
        ),
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Winery'),
            validator: validateAuthor,
            initialValue: widget.wineryin,
            onSaved: (String val) {
              winery = val;
            }
        ),
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Country'),
            validator: validateAuthor,
            initialValue: widget.countryin,
            onSaved: (String val) {
              country = val;
            }
        ),
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Region'),
            validator: validateAuthor,
            initialValue: widget.regionin,
            onSaved: (String val) {
              region = val;
            }
        ),
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Province'),
            validator: validateAuthor,
            initialValue: widget.provincein,
            onSaved: (String val) {
              province = val;
            }
        ),
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Description'),
            validator: validateAuthor,
            initialValue: widget.descriptionin,
            onSaved: (String val) {
              description = val;
            }
        ),
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Cellar location'),
            initialValue: widget.locationin,
            onSaved: (String val) {
              emplacement = val;
            }
        ),
        new SizedBox(height: 15.0),
        new RaisedButton(onPressed: _checkCellarCapacity, child: new Text(widget.action),
        )
      ],
    );
  }

  String validateTitle(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Title is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Title must be a-z and A-Z";
    }
    return null;
  }

  String validateAuthor(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Please enter something";
    }
    return null;
  }

   _checkCellarCapacity() async {
    DocumentSnapshot variable = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('compteur')
        .document('count')
        .get();
    int nb = int.parse(variable.data["count"]);
    if(nb<=5 || widget.add == false){
      _sendToServer();
    }
    else{
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Wine cellar full"),
              content: Text(
                  "You can not add another bottle because your Wine cellar is full. Please delete a bottle before adding another one"),
            );
          });
    }

  }


  _sendToServer() {
    if (_key.currentState.validate()) {
      //No error in validator
      _key.currentState.save();
      Firestore.instance.runTransaction((Transaction transaction) async {
        CollectionReference reference = Firestore.instance.collection('users')
            .document(widget.uid)
            .collection("bottle");
        if (widget.add == false) {
          reference.document(widget.bottleid).updateData({
            "title": title,
            "description": description,
            "country": country,
            "designation": designation,
            "province": province,
            "region": region,
            "variety": variety,
            "winery": winery,
            "location" : emplacement
          })
              .then((result) =>
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BottlePage(
                        id: widget.bottleid,
                        uid: widget.uid)))
          });

        } else {



          await reference.add({"title": "$title", "description": "$description","designation": "$designation","variety": "$variety",
            "winery": "$winery","country": "$country","region": "$region","province": "$province","location":"$emplacement"});
          DocumentSnapshot variable = await Firestore.instance
              .collection('users')
              .document(widget.uid)
              .collection('compteur')
              .document('count')
              .get();
          int nb = int.parse(variable.data["count"]);
          await Firestore.instance
              .collection('users')
              .document(widget.uid)
              .collection('compteur')
              .document('count')
              .setData({"count": (nb + 1).toString()});


        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    cellar(
                      uid: widget.uid,
                      title: "My Wine Cellar",
                    )));
        }
      });
    }else {
      // validation error
      setState(() {
        _validate = true;
      });
    }}
      }

