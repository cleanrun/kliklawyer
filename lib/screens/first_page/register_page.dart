import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kliklawyer/screens/menu/dashboard.dart';
import 'package:kliklawyer/utils/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegisterPage extends StatefulWidget{
  final String stringNoHp;

  RegisterPage({this.stringNoHp});

  @override
  State<StatefulWidget> createState() {
    return _RegisterState(numberPhone: this.stringNoHp);
  }
}

class _RegisterState extends State<RegisterPage>{
  _RegisterState({this.numberPhone, this.uid});
  final String numberPhone, uid;

  TextEditingController fullnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  String dropdownValue = "One";
  int counter = 0;

  String imagesURL = "";

  final _formKey = GlobalKey<FormState>();

  File _image;

  Future getImageFromGallery() async {
    // for gallery
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });

    print("Ada Gambarnya $_image");
  }

  /* Save Input */
  Future _save() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    // String fileName = basename(_image.path);

    if (_image != null) {
      setState(() {
        _getImageUrl();
      });
    }
    final DatabaseReference dbs =
    FirebaseDatabase.instance.reference().child('users');
    setState(() {
      dbs.child(numberPhone).set({
        'id': user.uid,
        'fullName': fullnameController.text,
        'phoneNumber': numberPhone,
        'email': emailController.text,
        'imageURL': imagesURL
      });
    });

    print("Yeay jalan");
  }

  /* Save SharedPreference */
  void _saveHasUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setBool('hasUser', true);
      pref.setString('numberPhone', numberPhone);
      //pref.setString('userId', user.uid);
      pref.setString('fullName', fullnameController.text);
    });
  }

  /* For Upload Image into Firebase */
  Future<String> _getImageUrl() async {
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('users')
        .child(numberPhone)
        .child('photoprofile.jpg');
    ref.putFile(_image);
    //DatabaseReference dbf = FirebaseDatabase.instance.reference().child('users').child(noHp);
    var url = await ref.getDownloadURL() as String;
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString('imageFirebase', url.toString());
      imagesURL = url.toString();
    });

    return imagesURL;
  }

  void _showAlert(BuildContext context) {
    Fluttertoast.showToast(
      msg: "Account has been Registered",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Register Account")),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          //First Element
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                      child: Container(
                        width: 200,
                        height: 200.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: _image == null
                                  ? AssetImage("assets/user.png")
                                  : FileImage(_image),
                              fit: BoxFit.cover),
                        ),
                        // button text
                      ),
                      onTap: () {
                        getImageFromGallery();
                      }),
                  Text(
                    "Tap to Change Image",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  )
                ],
              ),
            ),
          ),

          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //First Element Form
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    controller: fullnameController,
                    style: null,
                    validator: (String arg) {
                      if (arg.isEmpty)
                        return 'Require Enter Full Name';
                      else
                        return null;
                    },
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      //updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: null,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                //Second Element Form
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    controller: emailController,
                    style: null,
                    keyboardType: TextInputType.emailAddress,
                    onTap: () {
                      if (counter == 0) {
                        Fluttertoast.showToast(
                          msg: "Wait a second",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1,
                        );
                        //signOutGoogle();
                        signInWithGoogle().then((s) {
                          setState(() {
                            emailController.text = email;
                            Fluttertoast.showToast(
                              msg: "Wait a second",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIos: 1,
                            );
                          });
                        });
                        counter = counter + 1;
                      }
                      print(emailController.text);
                    },
                    onChanged: (value) {
                      emailController.text = email;
                      print(emailController.text);
                    },
                    decoration: InputDecoration(
                        labelText: 'Email ID',
                        labelStyle: null,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 15, left: 50, right: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      textColor: Colors.white,
                      color: Color.fromRGBO(192, 57, 43, 1),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          //_getImageUrl();
                          _save();
                          _saveHasUser();
                          // print(numberPhone);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) {
                                return DashboardPage();
                              },
                            ),
                          );
                          _showAlert(context);
                        }
                      },
                      child: new Text(
                        "Submit",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Eight Element
        ],
      ),
    );
  }

}