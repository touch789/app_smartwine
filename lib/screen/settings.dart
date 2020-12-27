import 'package:baby_names/screen/cellar.dart';
import 'package:baby_names/screen/home.dart';
import 'package:baby_names/screen/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';








class SettingsOnePage extends StatefulWidget {
  SettingsOnePage({Key key, this.uid}) : super(key: key); //update this to include the uid in the constructor

  final String uid;


  //include this
  @override
  _SettingsOnePage createState() => _SettingsOnePage();
}

class _SettingsOnePage extends State<SettingsOnePage> {
var textverif;
var colorverif;


  final TextStyle headerStyle = TextStyle(
    color: Colors.grey.shade800,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );

  @override
  void initState() {
    check();

    super.initState();
  }

  check() async {
    var currentuser= await FirebaseAuth.instance.currentUser();
    bool verified = currentuser.isEmailVerified;
    if (verified == false){
      setState(() {
        textverif = "Your email is not verified, please do it as soon as possible";
        colorverif = Colors.red;
      });
    }else{
      setState(() {
        textverif = "Your email is verified";
        colorverif = Colors.green;
      });
    }


  }

sendEmail() async {
  var currentuser= await FirebaseAuth.instance.currentUser();

  currentuser.sendEmailVerification();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Email Send"),
          content: Text(
              "An email was sent to : "+currentuser.email+" \n please check your SPAM folder and follow the instruction received."),
        );
      });
  }

changePassword() async {
  var currentuser= await FirebaseAuth.instance.currentUser();
  FirebaseAuth.instance.sendPasswordResetEmail(email: currentuser.email);
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Email Send"),
          content: Text(
              "An email was sent to : "+currentuser.email+" \n please check your SPAM folder and follow the instruction received."),
        );
      });
}


changeAccountinfo() async {
  String name, surname;



  await showDialog<String>(
    context: context,
      builder: (BuildContext context)
  {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data.... please wait...');
          name = snapshot.data["fname"];
          surname = snapshot.data["surname"];


          return AlertDialog(
            title: Text('Change your profile informations'),
            content: new Row(
              children: [
                new Expanded(
                    child: new TextFormField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'First Name'),
                      initialValue: snapshot.data["fname"],
                      onChanged: (value) {
                        name = value;
                      },
                    )),
                new Expanded(
                    child: new TextFormField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Surname'),
                      initialValue: snapshot.data["surname"],
                      onChanged: (value) {
                        surname = value;
                      },
                    ))
              ],
            ),
            actions: [
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Update'),
                onPressed: () {
                  Firestore.instance.collection("users").document(widget.uid).updateData(
                      {
                        "fname": name,
                        "surname": surname,
                      });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  });

}

changeCellar() async {
  String cellarid;



  await showDialog<String>(
      context: context,
      builder: (BuildContext context)
      {
        return StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(widget.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text('Loading data.... please wait...');
              cellarid = snapshot.data["cellarid"];



              return AlertDialog(
                title: Text('Change Your cellar ID'),
                content: new Row(
                  children: [
                    new Expanded(
                        child: new TextFormField(
                          autofocus: true,
                          decoration: new InputDecoration(
                              labelText: 'Cellar ID :'),
                          initialValue: snapshot.data["cellarid"],
                          onChanged: (value) {
                            cellarid = value;
                          },
                        )),
                  ],
                ),
                actions: [
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text('Update'),
                    onPressed: () {

                     checkcellar(cellarid);
                    },
                  ),
                ],
              );
            });
      });

}

checkcellar(String id) async {

  var docRef = Firestore.instance.collection("Cave").document(id.toString());

  docRef.get().then((doc) {
    if (doc.exists) {
      Firestore.instance.collection("users").document(widget.uid).updateData(
          {
            "cellarid": id,
          });
      Navigator.pop(context);
    } else {
      // doc.data() will be undefined in this case
      print("No such document!");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Wrong Cellar ID"),
              content: Text(
                  "The cellar id you entered does not correspond to an existing cellar, try entering a valid cellar ID or call the customer service."),
              actions: <Widget>[FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.pop(context),
              )],
            );
          });
    }
  });
}





  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data.... please wait...');
          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: HexColor("#EB54A8")),
                onPressed: () => Navigator.pushNamed(context, "/splash"),
              ),
              title: Text(
                'Settings',
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "ACCOUNT",
                    style: headerStyle,
                  ),
                  const SizedBox(height: 10.0),
                  Card(
                    elevation: 0.5,
                    margin: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 0,
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            child : Icon(
                              Icons.grain,
                            ),
                          ),
                          title: Text(snapshot.data["fname"]+" "+snapshot.data["surname"]),
                          subtitle: Text(snapshot.data["email"]),
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            Icons.account_circle,
                            color: HexColor("#EB54A8"),
                          ),
                          title: Text("Change account informations"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            changeAccountinfo();
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            Icons.lock_outline,
                            color: HexColor("#EB54A8"),
                          ),
                          title: Text("Change Password"),

                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            changePassword();
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            Icons.email,
                            color: HexColor("#EB54A8"),
                          ),
                          title: Text("verify email"),
                          subtitle: Text(textverif,style: TextStyle(color: colorverif) ,),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            sendEmail();


                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            Icons.create,
                            color: HexColor("#EB54A8"),
                          ),
                          title: Text("Change cellar ID"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            changeCellar();
                          },
                        ),


                      ],
                    ),
                  ),


                  Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 0,
                    ),
                    child: ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text("Logout"),
                      onTap: () {
                        FirebaseAuth.instance
                            .signOut()
                            .then((result) =>
                            Navigator.pushReplacementNamed(
                                context, "/splash"))
                            .catchError((err) => print(err));
                      },
                    ),
                  ),
                  const SizedBox(height: 60.0),
                ],
              ),
            ),
          );
        }
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }
}

