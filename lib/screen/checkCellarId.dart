import 'package:baby_names/screen/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;





class checkCellarId extends StatefulWidget {
  @override
  _checkCellarIdState createState() => _checkCellarIdState();
}

class _checkCellarIdState extends State<checkCellarId> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String email = "";
  String test ="";

  Future scanQRCode() async {
    await Permission.camera.request();
    String cameraScanResult = await scanner.scan();
    print(cameraScanResult);
    setState(() {
      email = cameraScanResult;

    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Votre Cave"),
            content: Text(email),
          );
        });
  }


  Future submit(String id) async {

    var docRef = Firestore.instance.collection("Cave").document(id.toString());

    docRef.get().then((doc) {
    if (doc.exists) {
    print("Document data:" + doc.data["idcellar"]);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => RegisterPage(

              caveid: doc.data["idcellar"],
            )),
            (_) => false);
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
         );
       });
    }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Validation"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Id de la cave'),
                    initialValue: test,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                    },
                  ),
                  // this is where the
                  // input goes
                  RaisedButton(
                    onPressed: () => submit(email),
                    child: Text("submit"),
                  ),
                  RaisedButton(
                    onPressed: () => scanQRCode(),
                    child: Text("Scan QR code"),
                  )
                ],
              ),
            ),
            // this is where
            // the form field
            // are defined

          ],
        ),
      ),
    );
  }
}
