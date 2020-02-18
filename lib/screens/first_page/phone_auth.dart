import 'dart:collection';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kliklawyer/screens/first_page/code_auth.dart';
import 'package:kliklawyer/screens/first_page/register_page.dart';
import 'package:kliklawyer/screens/menu/dashboard.dart';
import 'package:kliklawyer/utils/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

String smsCodes = " ";

bool adaUser;
String fullName, email, noHp;
//AuthCredential credentials;
//String _smsCodes = " ";

String signature = "{{ app signature }}";
String codes = "";

String countryCode = "+62";

class AuthenticationPage extends StatefulWidget{
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<AuthenticationPage>{
  String phoneNo;
  String smsCode;
  String verificationId;

  var forceResendingToken;

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController codeNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> verifyNumber() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verID) {
      this.verificationId = verID;
    };

    final PhoneVerificationCompleted verificationSuccess =
        (AuthCredential credential) {
      print("Verified");
      DatabaseReference dbs = FirebaseDatabase.instance
          .reference()
          .child('users')
          .child('$phoneNo');
      LinkedHashMap map = new LinkedHashMap<String, dynamic>();
      dbs.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          setState(() {
            fullName = map['fullName'];
            email = map['email'];
            noHp = map['phoneNumber'];
            adaUser = true;
            //pref.setBool('udahDaftar',adaUser);
            _moveScreen(adaUser);
          });
        } else if (snapshot.value == null) {
          adaUser = false;
          setState(() {
            _moveScreen(adaUser);
          });
          //pref.setBool('udahDaftar',adaUser);

        }
      });
      //verifyNumber();
    };

    final PhoneCodeSent smsCodeSent = (String verID, [int forceCodeResend]) {
      this.verificationId = verID;
      this.forceResendingToken = forceCodeResend;
      print("forceresending $forceCodeResend verification ID :$verID");

      // smsCodeDialog(context);
      if (this.forceResendingToken != null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return CodeAuthOTPPage(
            smsCode: this.smsCode,
            verificationId: this.verificationId,
            phoneNo: this.phoneNo,
            forceResendingToken: forceResendingToken,
            codeCountry: countryCode,
          );
        }));
      }
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException exception) {
      print('${exception.message}');
      //verifyNumber();
    };

    print("SMS CODE SENT : $smsCodeSent");

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        //forceResendingToken: forceResendingToken,
        timeout: Duration(seconds: 5),
        verificationCompleted: verificationSuccess,
        verificationFailed: verificationFailed);
  }

  Future _moveScreen(bool udahDaftar) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(udahDaftar);
    if (udahDaftar == true) {
      setState(() {
        pref.setBool('hasUser', udahDaftar);
        pref.setString('numberPhone', this.phoneNo);
        print(pref.getBool('hasUser'));
      });

      //Navigator.of(context).pushReplacementNamed('/dashboard');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return DashboardPage();
      }));
    } else if (udahDaftar == false) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return RegisterPage(
          stringNoHp: this.phoneNo,
        );
      }));
    }
  }

  Widget _phoneAuthOTP() {
    return new SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Theme(
        data: ThemeData(
          hintColor: Colors.grey,
        ),
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              //padding: EdgeInsets.all(16.0),
              width: 200,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0)),
              child: ListTile(
                leading: CountryCodePicker(
                  showFlag: true,
                  onChanged: (s) {
                    print("COUNTRY CODE $s");
                    setState(() {
                      countryCode = s.toString();
                    });
                    print("country code $countryCode");
                  },
                  initialSelection: 'ID',
                  favorite: ['+62', 'ID'],
                  textStyle: TextStyle(color: Colors.white),
                ),
                title: TextFormField(
                  cursorColor: Colors.white,
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    debugPrint('Something changed in Title Text Field');
                    this.phoneNo = phoneNumberController.text;
                  },
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    fillColor: Colors.white,
                    //labelText: 'Phone Number',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(45, 127, 238, 1),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*  Image.asset(
                'images/TravelMed-Logo-3.png',
                width: 350,
              ), */
              _phoneAuthOTP(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: RaisedButton(
                      color: Color.fromRGBO(15, 71, 163, 1),
                      onPressed: () async {
                        signOutGoogle();
                        if (phoneNumberController.text.isNotEmpty) {
                          if (phoneNumberController.text.substring(0, 1) ==
                              "0") {
                            String zero = phoneNumberController.text
                                .replaceFirst('0', '');
                            setState(() {
                              if (countryCode.isEmpty) {
                                setState(() {
                                  countryCode = "+62";
                                });
                              }
                              String msgBody = "Enter: 943731";
                              String code = msgBody.substring(7);
                              //phoneNumberController.text = zero;
                              phoneNo = "$countryCode$zero";
                              print("COUNTY CODE $countryCode");
                              print("SMS CODE $code");
                              print(phoneNo);
                              verifyNumber();
                              /*  Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return CodeAuthOTP();
                              })); */
                            });
                          } else {
                            setState(() {
                              if (countryCode.isEmpty) {
                                setState(() {
                                  countryCode = "+62";
                                });
                              }
                              String msgBody = "Enter: 943731";
                              String code = msgBody.substring(7);
                              print("SMS CODE $code");
                              phoneNo =
                              "$countryCode${phoneNumberController.text.toString()}";
                              print(phoneNo);
                              print("tidak ada");
                              verifyNumber();
                              /*   Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return CodeAuthOTP();
                              })); */
                            });
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Please Enter your phone number',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER);
                        }
                      },
                      child: Text(
                        "NEXT",
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
              //_registerButton()
            ],
          ),
        ),
      ),
    );
  }

}