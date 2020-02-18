import 'dart:async';
import 'dart:collection';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kliklawyer/screens/first_page/phone_auth.dart';
import 'package:kliklawyer/screens/first_page/register_page.dart';
import 'package:kliklawyer/screens/menu/dashboard.dart';
import 'package:kliklawyer/utils/sign_in.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';

class CodeAuthOTPPage extends StatefulWidget{
  final String smsCode;
  final String verificationId;
  final String phoneNo;
  final String codeCountry;
  var forceResendingToken;

  CodeAuthOTPPage(
      {this.smsCode,
        this.verificationId,
        this.phoneNo,
        this.codeCountry,
        this.forceResendingToken});

  @override
  _CodeAuthOTPState createState() => _CodeAuthOTPState(
      smsCode: this.smsCode,
      verificationId: this.verificationId,
      phoneNo: this.phoneNo);
}

class _CodeAuthOTPState extends State<CodeAuthOTPPage>{
  final String smsCode;
  final String verificationId;
  final String phoneNo;

  bool adaUser;
  String fullName, email, noHp;

  bool invalidCode = false, hasExpired = false;

  String smsCodes = " ";
  String verificationIds;

  _CodeAuthOTPState(
      {@required this.smsCode,
        @required this.verificationId,
        @required this.phoneNo});

  Timer _timer;
  int seconds;

  bool hasTimeout = false;
  var onTapRecognizer;

  int countResendCodeOTPl = 0;

  String numberPhone;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController codeAuthController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();
  String currentText = "";

  bool hasError = false;
  bool editPhoneNumber = false;

  String countryCode = "+62";

  @override
  void initState() {
    super.initState();
    readSMS();
    numberPhone = widget.phoneNo;
    print("Country code ${widget.codeCountry}");

    phoneNumberController.text = numberPhone.replaceAll(widget.codeCountry, '');

    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          countResendCodeOTPl = countResendCodeOTPl + 1;

          if (countResendCodeOTPl < 4) {
            var oneMinutes = DateTime.now()
                .add(Duration(seconds: 20))
                .difference(DateTime.now());

            seconds = oneMinutes.inSeconds;
            startTimer();
            hasTimeout = false;
            verifyNumber();
          } else {
            Fluttertoast.showToast(
                msg:
                'Anda sudah mencapai limit, silahkan tunggu 30 menit ke depan',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
                  return AuthenticationPage();
                }));
          }
        });
        /*  showDialog(
            context: context,
            builder: (context) {
              return DialogResendCodeOTp(
                resendOTP: countResendCodeOTPl,
              );
            }); */
        //Navigator.pop(context);
      };
    print("forceResendingTokne = ${widget.forceResendingToken}");
    var oneMinutes =
    DateTime.now().add(Duration(seconds: 20)).difference(DateTime.now());

    seconds = oneMinutes.inSeconds;
    startTimer();
  }

  void startTimer() {
    // Set 1 second callback
    const period = const Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      // Update interface
      setState(() {
        // minus one second because it calls back once a second
        seconds--;
      });
      if (seconds == 0) {
        // Countdown seconds 0, cancel timer
        cancelTimer();
      }
    });
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
      setState(() {
        hasTimeout = true;
      });
    }
  }

  String constructTime(int seconds) {
    int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return formatTime(hour) +
        ":" +
        formatTime(minute) +
        ":" +
        formatTime(second);
  }

  String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  void readSMS() {
    SmsReceiver receiver = new SmsReceiver();
    receiver.onSmsReceived.listen((SmsMessage msg) {
      if (msg.body != null) {
        if (msg.body.contains('Enter')) {
          String msgBody = msg.body;
          String code = msgBody.substring(7);
          setState(() {
            codeAuthController.text = code;
            smsCodes = code;
            _delayed();
          });
        }
      }
    });
  }

  Future<void> verifyNumber() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verID) {
      this.verificationIds = verID;
    };

    final PhoneVerificationCompleted verificationSuccess =
        (AuthCredential credential) {
      print("Verified");
      //verifyNumber();
    };

    final PhoneCodeSent smsCodeSent = (String verID, [int forceCodeResend]) {
      this.verificationIds = verID;
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException exception) {
      print('${exception.message}');
      //verifyNumber();
    };

    print("SMS CODE SENT : $smsCodeSent");

    if (editPhoneNumber) {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: numberPhone,
          codeAutoRetrievalTimeout: autoRetrieve,
          codeSent: smsCodeSent,
          timeout: Duration(seconds: 5),
          verificationCompleted: verificationSuccess,
          verificationFailed: verificationFailed);
      editPhoneNumber = !editPhoneNumber;
    } else {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: numberPhone,
          codeAutoRetrievalTimeout: autoRetrieve,
          codeSent: smsCodeSent,
          forceResendingToken: widget.forceResendingToken,
          timeout: Duration(seconds: 5),
          verificationCompleted: verificationSuccess,
          verificationFailed: verificationFailed);
    }
  }

  Future<Null> _delayed() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      FirebaseAuth.instance.currentUser().then((user) {
        if (user == null) {
          //Navigator.pop(context);
          signIn();
          print('smsCode');
        }
      });
    });
  }

  Future signIn() async {
    AuthCredential credential;
    if (verificationIds == null) {
      credential = PhoneAuthProvider.getCredential(
        verificationId: this.verificationId,
        smsCode: this.smsCodes,
      );
    } else {
      credential = PhoneAuthProvider.getCredential(
        verificationId: this.verificationIds,
        smsCode: this.smsCodes,
      );
    }
    invalidCode = false;
    hasExpired = false;

    AuthResult result;
    print("CREDENTIAL : $credential");
    print("SMS CODE : $smsCode");

    SharedPreferences pref = await SharedPreferences.getInstance();
    await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      result = user;
      DatabaseReference dbf = FirebaseDatabase.instance
          .reference()
          .child("users")
          .child(this.numberPhone);
      LinkedHashMap map = new LinkedHashMap<String, dynamic>();
      dbf.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          setState(() {
            fullName = map['fullName'];
            email = map['email'];
            noHp = map['phoneNumber'];
            adaUser = true;
            //pref.setBool('udahDaftar',adaUser);
            pref.setBool('hasUser', true);
            _moveScreen(adaUser);
          });
        } else if (snapshot.value == null) {
          adaUser = false;
          //pref.setBool('udahDaftar',adaUser);
          _moveScreen(adaUser);
        }
      });

      print("yeah");
      print("SMS CODE : $smsCode");
    }).catchError((exception) {
      print("EXCEPTION $exception");

      if (exception.toString().contains("ERROR_INVALID_VERIFICATION_CODE")) {
        setState(() {
          invalidCode = true;
        });
      } else {
        setState(() {
          hasExpired = true;
        });
      }
    });
    if (result == null) {
      print("RESULT KOSONG");
    }
    print("UDAH DAFTAR :$adaUser");
  }

  Future _moveScreen(bool udahDaftar) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(udahDaftar);
    if (udahDaftar == true) {
      pref.setBool('hasUser', udahDaftar);
      pref.setString('numberPhone', this.numberPhone);
      print(pref.getBool('hasUser'));
      //Navigator.of(context).pushReplacementNamed('/dashboard');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return DashboardPage();
      }));
    } else if (udahDaftar == false) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return RegisterPage(
          stringNoHp: this.numberPhone,
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              //SizedBox(height: 30),
              Container(
                  height: 200,
                  child: ClipPath(
                    clipper: ClippingClass(),
                    child: Container(
                      color: Color.fromRGBO(45, 127, 238, 1),
                      /* child: Center(
                        child: Image.asset(
                          'images/logo_travelmed_3.png',
                          width: 200,
                        ),
                      ), */
                    ),
                  )),
              // Image.asset(
              //   'assets/verify.png',
              //   height: MediaQuery.of(context).size.height / 3,
              //   fit: BoxFit.fitHeight,
              // ),
              SizedBox(height: 8),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  'Masukkan Kode OTP yang dikirim ke',
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: "RobotoMedium"),
                  textAlign: TextAlign.center,
                ),
              ),
              editPhoneNumber
                  ? Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        //color: Colors.red,
                          width: 200.0,
                          margin:
                          EdgeInsets.only(left: 16.0, right: 24.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0),
                          child: TextField(
                            controller: phoneNumberController,
                            enabled: editPhoneNumber,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefix: CountryCodePicker(
                                onChanged: (s) {
                                  print("COUNTRY CODE $s");
                                  setState(() {
                                    countryCode = s.toString();
                                  });
                                  print("country code $countryCode");
                                },
                                initialSelection: 'ID',
                                favorite: ['+62', 'ID'],
                                textStyle: TextStyle(color: Colors.black),
                              ),
                            ),
                          )),
                    ),
                    GestureDetector(
                      child: Container(
                          color: Colors.red.withOpacity(0),
                          padding: EdgeInsets.all(10.0),
                          height: 60.0,
                          margin: EdgeInsets.only(right: 24.0),
                          child: Center(
                            child: Text(
                              "Kirim Ulang",
                              textAlign: TextAlign.center,
                              style:
                              TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                      onTap: () {
                        setState(() {
                          FirebaseAuth.instance.signOut();
                          if (phoneNumberController.text !=
                              numberPhone.replaceAll(
                                  widget.codeCountry, '')) {
                            cancelTimer();
                            numberPhone = phoneNumberController.text;
                            numberPhone.replaceAll('$countryCode', '');
                            print("numberPhone $numberPhone");
                            countResendCodeOTPl = 0;
                            var oneMinutes = DateTime.now()
                                .add(Duration(minutes: 1))
                                .difference(DateTime.now());
                            hasTimeout = false;
                            seconds = oneMinutes.inSeconds;
                            startTimer();
                            signOutGoogle();
                            if (phoneNumberController.text.isNotEmpty) {
                              if (phoneNumberController.text
                                  .substring(0, 1) ==
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
                                  numberPhone = "$countryCode$zero";
                                  print("COUNTY CODE $countryCode");
                                  print("SMS CODE $code");
                                  print(phoneNo);
                                  verifyNumber();
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
                                  numberPhone =
                                  "$countryCode${phoneNumberController.text.toString()}";
                                  print(phoneNo);
                                  print("tidak ada");
                                  verifyNumber();
                                });
                              }
                            } else {
                              FirebaseAuth.instance.signOut();
                              Fluttertoast.showToast(
                                  msg: 'Please Enter your phone number',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER);
                            }
                          } else {
                            setState(() {
                              editPhoneNumber = !editPhoneNumber;
                            });
                            Fluttertoast.showToast(
                                msg: 'Tidak ada perubahan',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER);
                          }
                        });
                      },
                    )
                  ],
                ),
              )
                  : Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '$numberPhone',
                        style: TextStyle(
                            color: Color(0xFFEC5F70),
                            fontSize: 18,
                            fontFamily: "RobotoMedium"),
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        child: Container(
                            color: Colors.red.withOpacity(0),
                            width: 80.0,
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text("Edit",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                            )),
                        onTap: () {
                          setState(() {
                            editPhoneNumber = true;
                            //cancelTimer();
                          });
                        },
                      )
                    ],
                  )),

              SizedBox(
                height: 20,
              ),
              !editPhoneNumber
                  ? hasTimeout == true
                  ? RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Belum terima kode? ",
                    style: TextStyle(
                        color: Colors.black54, fontSize: 15),
                    children: [
                      TextSpan(
                          text: " KIRIM ULANG",
                          recognizer: onTapRecognizer,
                          style: TextStyle(
                              color: Color(0xFFEC5F70),
                              fontWeight: FontWeight.bold,
                              fontSize: 16))
                    ]),
              )
                  : Text(
                constructTime(seconds),
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.black54, fontSize: 15.0),
              )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: PinCodeTextField(
                    length: 6,
                    obsecureText: false,
                    animationType: AnimationType.fade,
                    shape: PinCodeFieldShape.box,
                    animationDuration: Duration(milliseconds: 300),
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    textInputType: TextInputType.number,
                    backgroundColor: Colors.white,
                    fieldWidth: 40,
                    controller: codeAuthController,
                    onCompleted: (v) {
                      print("Completed");
                    },
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError
                      ? "*Please fill up all the cells properly"
                      : invalidCode
                      ? "*Wrong Code"
                      : hasExpired ? "Code has Expired" : "",
                  style: TextStyle(color: Color(0xFFEC5F70), fontSize: 15),
                ),
              ),

              Container(
                margin:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: FlatButton(
                    onPressed: () {
                      if (currentText.length != 6) {
                        setState(() {
                          hasError = true;
                        });
                      } else {
                        setState(() {
                          hasError = false;
                          smsCodes = codeAuthController.text.toString();
                          if (codeAuthController.text.isNotEmpty) {
                            if (codeAuthController.text.length > 5) {
                              signOutGoogle();
                              FirebaseAuth.instance.currentUser().then((user) {
                                if (user == null) {
                                  //Navigator.pop(context);
                                  signIn();
                                  print('smsCode');
                                }
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Require 6 Character',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER);
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Require 6 Character',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER);
                          }
                        });
                      }
                    },
                    child: Center(
                        child: Text(
                          "VERIFY".toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(45, 127, 238, 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}