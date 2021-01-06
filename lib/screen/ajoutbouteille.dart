import 'package:baby_names/screen/cellar.dart';
import 'package:baby_names/screen/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AjoutBouteille extends StatefulWidget {
  AjoutBouteille(
      {Key key,
      this.action,
      this.add,
      this.uid,
      this.anneein,
      this.bottleid,
      this.titlein,
      this.locationin,
      this.designationin,
      this.descriptionin,
      this.colorin,
      this.countryin,
      this.provincein,
      this.regionin,
      this.varietyin,
      this.wineryin,
      this.tempConsin,
      this.tempServicein})
      : super(key: key); //update this to include the uid in the constructor

  final String uid;
  String titlein,
      designationin,
      descriptionin,
      anneein,
      countryin,
      provincein,
      regionin,
      locationin,
      varietyin,
      wineryin,
      bottleid,
      action,
      tempServicein,
      tempConsin,
      colorin;
  bool add;
  static const IconData wine_bar_sharp =
      IconData(0xf023, fontFamily: 'MaterialIcons');
  //include this
  @override
  _AjoutBouteille createState() => _AjoutBouteille();
}

class _AjoutBouteille extends State<AjoutBouteille> {
  GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;

  String title,
      designation,
      description,
      country,
      province,
      region,
      variety,
      winery,
      emplacement,
      tempService,
      tempCons,
      annee,
      color;
  @override
  void initState() {
    super.initState();
    emplacement = widget.locationin;
    color = widget.colorin;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.action + ' your Bottle'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
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
        ListTile(
          leading: Icon(
            Icons.local_offer,
            color: HexColor("#EB54A8"),
          ),
          subtitle: TextFormField(
              minLines: 1,
              maxLines: 6,

              decoration: new InputDecoration(
                hintText: 'Title',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#EB54A8")),
                ),
              ),
              initialValue: widget.titlein,
              onSaved: (String val) {
                title = val;
              }),
        ),
        ListTile(
          leading: Icon(
            Icons.local_bar,
            color: HexColor("#EB54A8"),
          ),
          subtitle: TextFormField(
              decoration: new InputDecoration(
                hintText: 'Variety',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#EB54A8")),
                ),
              ),
              initialValue: widget.varietyin,
              onSaved: (String val) {
                variety = val;
              }),
        ),
        ListTile(
          leading: Icon(
            Icons.date_range,
            color: HexColor("#EB54A8"),
          ),
          subtitle: TextFormField(
              decoration: new InputDecoration(
                hintText: 'Year',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#EB54A8")),
                ),
              ),
              initialValue: widget.anneein,
              onSaved: (String val) {
                annee = val;
              }),
        ),
        ListTile(
          leading: Icon(
            Icons.grain,
            color: HexColor("#EB54A8"),
          ),
          subtitle: TextFormField(
              decoration: new InputDecoration(
                hintText: 'Winery',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#EB54A8")),
                ),
              ),
              initialValue: widget.wineryin,
              onSaved: (String val) {
                winery = val;
              }),
        ),
        ListTile(
          leading: Icon(
            Icons.location_on,
            color: HexColor("#EB54A8"),
          ),
          subtitle: TextFormField(
              decoration: new InputDecoration(
                hintText: 'Country',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#EB54A8")),
                ),
              ),
              initialValue: widget.countryin,
              onSaved: (String val) {
                country = val;
              }),
        ),
        ListTile(
          leading: Icon(
            Icons.location_on,
            color: HexColor("#EB54A8"),
          ),
          subtitle: TextFormField(
              decoration: new InputDecoration(
                hintText: 'Region',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#EB54A8")),
                ),
              ),
              initialValue: widget.regionin,
              onSaved: (String val) {
                region = val;
              }),
        ),
        ListTile(
          leading: Icon(
            Icons.location_city,
            color: HexColor("#EB54A8"),
          ),
          subtitle: TextFormField(
              decoration: new InputDecoration(
                hintText: 'Province',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#EB54A8")),
                ),
              ),
              initialValue: widget.provincein,
              onSaved: (String val) {
                province = val;
              }),
        ),
        ListTile(
          leading: Icon(
            Icons.description,
            color: HexColor("#EB54A8"),
          ),
          subtitle: TextFormField(
              minLines: 1,
              maxLines: 20,
              decoration: new InputDecoration(
                hintText: 'Description',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#EB54A8")),
                ),
              ),
              initialValue: widget.descriptionin,
              onSaved: (String val) {
                description = val;
              }),
        ),
        ListTile(
          leading: Icon(
            Icons.room_service,
            color: HexColor("#EB54A8"),
          ),
          subtitle: TextFormField(
              decoration: new InputDecoration(
                hintText: 'Serving temperature',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#EB54A8")),
                ),
              ),
              initialValue: widget.tempServicein,
              onSaved: (String val) {
                tempService = val;
              }),
        ),
        ListTile(
          leading: Icon(
            Icons.ac_unit,
            color: HexColor("#EB54A8"),
          ),
          subtitle: TextFormField(
              decoration: new InputDecoration(
                hintText: 'Conservation temperature',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#EB54A8")),
                ),
              ),
              initialValue: widget.tempConsin,
              onSaved: (String val) {
                tempCons = val;
              }),
        ),
        ListTile(
          leading: Icon(
            Icons.invert_colors,
            color: HexColor("#EB54A8"),
          ),
          subtitle: new DropdownButton(
            //value: shopId,
            //isDense: true,
            isExpanded: true,

            value: widget.colorin,
            onChanged: (String val) {
              color = val;
              setState(() {
                widget.colorin = val;
              });
            },
            hint: Text('Select your bottle color'),
            items: <String>['red', 'white', 'rose'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.gps_fixed,
            color: HexColor("#EB54A8"),
          ),
          subtitle: new StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("Cave")
                .document("1")
                .collection('cellar')
                .where("buttonState", isEqualTo: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return DropdownButton(
                    //value: shopId,
                    //isDense: true,
                    isExpanded: true,
                    value: widget.locationin,
                    onChanged: (String val) {
                      emplacement = val;
                      setState(() {
                        widget.locationin = val;
                      });
                    },
                    hint: Text('Choose from available location'),
                    items: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return DropdownMenuItem<String>(
                        value: document.data['location'].toString(),
                        child: Text(document.data['location'].toString()),
                      );
                    }).toList(),
                  );
              }
            },
          ),
        ),
        new SizedBox(height: 15.0),
        Center(
            child: SizedBox(
          height: 40,
          width: 200,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Theme.of(context).primaryColor)),
            child: Text(widget.action),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () => _checkCellarCapacity(),
          ),
        ))
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
    if (nb <= 5 || widget.add == false) {
      _sendToServer();
    } else {
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
        CollectionReference reference = Firestore.instance
            .collection('users')
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
            "location": emplacement,
            "tempService": tempService,
            "tempCons": tempCons,
            "year": annee,
            "color": color
          }).then((result) => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottlePage(
                              id: widget.bottleid,
                            )))
              });
        } else {
          await reference.add({
            "title": "$title",
            "description": "$description",
            "designation": "$designation",
            "variety": "$variety",
            "winery": "$winery",
            "country": "$country",
            "region": "$region",
            "province": "$province",
            "location": "$emplacement",
            "tempService": "$tempService",
            "tempCons": "$tempCons",
            "year": "$annee",
            "color": "$color"
          });
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
                  builder: (context) => cellar(
                        uid: widget.uid,
                        title: "My Wine Cellar",
                      )));
        }
      });
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }
}

Widget _buildDivider() {
  return Container(
    margin: const EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
    width: double.infinity,
    height: 1.0,
    color: Colors.grey.shade300,
    child: Divider(),
  );
}
