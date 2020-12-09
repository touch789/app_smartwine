import 'package:baby_names/screen/cellar.dart';
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
  AjoutBouteille({Key key, this.uid}) : super(key: key); //update this to include the uid in the constructor

  final String uid; //include this
  @override
  _AjoutBouteille createState() => _AjoutBouteille();
}

class _AjoutBouteille extends State<AjoutBouteille> {
  GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;
  String title, designation,description,country,province,region,variety,winery;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),

      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Add Your Bottle'),
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
            validator: validateAuthor,
            onSaved: (String val) {
              title = val;
            }
        ),

        new TextFormField(
            decoration: new InputDecoration(hintText: 'Designation'),
            validator: validateAuthor,
            onSaved: (String val) {
              designation = val;
            }
        ),
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Variety'),
            validator: validateAuthor,
            onSaved: (String val) {
              variety = val;
            }
        ),
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Winery'),
            validator: validateAuthor,
            onSaved: (String val) {
              winery = val;
            }
        ),
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Country'),
            validator: validateAuthor,
            onSaved: (String val) {
              country = val;
            }
        ),
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Region'),
            validator: validateAuthor,
            onSaved: (String val) {
              region = val;
            }
        ),
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Province'),
            validator: validateAuthor,
            onSaved: (String val) {
              province = val;
            }
        ),
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Description'),
            validator: validateAuthor,
            onSaved: (String val) {
              description = val;
            }
        ),
        new SizedBox(height: 15.0),
        new RaisedButton(onPressed: _sendToServer, child: new Text('Upload'),
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


  _sendToServer() {
    if (_key.currentState.validate()) {
      //No error in validator
      _key.currentState.save();
      Firestore.instance.runTransaction((Transaction transaction) async {
        CollectionReference reference = Firestore.instance.collection('users').document(widget.uid).collection("bottle");

        await reference.add({"title": "$title", "description": "$description","designation": "$designation","variety": "$variety",
          "winery": "$winery","country": "$country","region": "$region","province": "$province"});
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
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => cellar(
                uid: widget.uid,
                title: "My Wine Cellar",
              )));
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }
}