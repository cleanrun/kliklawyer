import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kliklawyer/screens/first_page/phone_auth.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GettingStartedPage extends StatefulWidget{
  @override
  _GettingStartedState createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStartedPage>{
  PageController controller;

  GlobalKey<PageContainerState> key = GlobalKey();
  bool _isEnglish, _isIndo = true;

  int _radioValue1 = 0;
  int correctScore = 0;

  int counter = 0;

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void _handleRadioValueChange(int value){
    setState(() {
      _radioValue1 = value;
    });
    if (_radioValue1 == 0) {
      setState(() {
        _isIndo = true;
        _isEnglish = false;
      });
    } else if (_radioValue1 == 1) {
      setState(() {
        _isIndo = false;
        _isEnglish = true;
      });
    }
  }

  Future setOnBoarding() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setBool('onBoarding', true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(45, 127, 238, 1),
        child: Container(
          //height: 120.0,
          child: PageIndicatorContainer(
            key: key,
            child: PageView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      color: Color.fromRGBO(45, 127, 238, 1),
                    ),
                    Positioned(
                        bottom: 0.0,
                        //left: 10.0,
                        child: Container(
                          color: Color.fromRGBO(45, 127, 238, 0.5),
                          width: MediaQuery.of(context).size.width,
                          height: 35,
                          //child: Text(""),
                        )),
                    Positioned(
                      left: 42.0,
                      right: 42.0,
                      top: 200.0,
                      bottom: 200.0,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Color.fromRGBO(45, 127, 238, 0.5),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Pilih Bahasa yang akan digunakan",
                                  style: TextStyle(
                                      fontFamily: 'RobotoBold',
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                                Divider(
                                  thickness: 2.0,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Select the language to be used",
                                  style: TextStyle(
                                      fontFamily: 'RobotoBold',
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                ),
                                GestureDetector(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius:
                                        BorderRadius.circular(8.0)),
                                    child: Row(
                                      children: <Widget>[
                                        Theme(
                                          data: ThemeData.dark(),
                                          child: Radio(
                                            value: 0,
                                            activeColor: Colors.white,
                                            groupValue: _radioValue1,
                                            onChanged: _handleRadioValueChange,
                                          ),
                                        ),
                                        Text("Bahasa Indonesia",
                                            style: TextStyle(
                                                fontFamily: 'RobotoBold',
                                                color: Colors.white,
                                                fontSize: 18))
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _isIndo = true;
                                      _isEnglish = false;
                                    });
                                    _handleRadioValueChange(0);
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                ),
                                GestureDetector(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius:
                                        BorderRadius.circular(8.0)),
                                    child: Row(
                                      children: <Widget>[
                                        Theme(
                                          data: ThemeData.dark(),
                                          child: Radio(
                                            value: 1,
                                            activeColor: Colors.white,
                                            groupValue: _radioValue1,
                                            onChanged: _handleRadioValueChange,
                                          ),
                                        ),
                                        Text("English",
                                            style: TextStyle(
                                                fontFamily: 'RobotoBold',
                                                color: Colors.white,
                                                fontSize: 18))
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _isIndo = false;
                                      _isEnglish = true;
                                    });
                                    _handleRadioValueChange(1);
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                ),
                              ],
                            ),
                          )),
                    ),
                    Positioned(
                      bottom: 10.0,
                      right: 25.0,
                      child: GestureDetector(
                        child: _isIndo != true
                            ? Container(
                          padding: EdgeInsets.all(16.0),
                          //color: Colors.red,
                          child: Text(
                            "NEXT",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                            : Container(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "LANJUT",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          print("Lamaa");
                          if (_isEnglish == null && _isIndo == null) {
                            Fluttertoast.showToast(
                                msg: 'Pilih',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER);
                          } else {
                            controller.nextPage(
                                duration: _kDuration, curve: _kCurve);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      /* child: Center(
                          child: Image.asset(
                        'images/Icon-app-splash-screen-1.png',
                        width: 150,
                      )), */
                    ),
                    Positioned(
                      bottom: 150,
                      left: 20,
                      right: 20,
                      child: Center(
                        child: Text(
                            "Perawatan medis anda adalah priotitas kami, dan tim kami yang" +
                                " berdedikasi, berkomitmen untuk menjadikan setiap jurnal perawatan" +
                                " pribadi Anda",
                            style: TextStyle(
                                fontFamily: 'RobotoBold',
                                color: Colors.white,
                                fontSize: 16.0),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    Positioned(
                        bottom: 0.0,
                        //left: 10.0,
                        child: Container(
                          color: Color.fromRGBO(45, 127, 238, 0.5),
                          width: MediaQuery.of(context).size.width,
                          height: 35,
                          //child: Text(""),
                        )),
                    Positioned(
                      bottom: 10.0,
                      left: 25.0,
                      child: GestureDetector(
                        child: _isIndo != true
                            ? Container(
                          padding: EdgeInsets.all(16.0),
                          //color: Colors.red,
                          child: Text(
                            "SKIP",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                            : Container(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "LEWATI",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          setOnBoarding();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                                return AuthenticationPage();
                              }));
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      right: 25.0,
                      child: GestureDetector(
                        child: _isIndo != true
                            ? Container(
                          padding: EdgeInsets.all(16.0),
                          //color: Colors.red,
                          child: Text(
                            "NEXT",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                            : Container(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "LANJUT",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          controller.nextPage(
                              duration: _kDuration, curve: _kCurve);
                        },
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      /*  child: Center(
                          child: Image.asset(
                        'images/Icon-app-splash-screen-2.png',
                        width: 150,
                      )), */
                    ),
                    Positioned(
                      bottom: 150,
                      left: 20,
                      right: 20,
                      child: Center(
                        child: Text("Temukan dokter yang sesuai",
                            style: TextStyle(
                                fontFamily: 'RobotoBold',
                                color: Colors.white,
                                fontSize: 16.0),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      left: 25.0,
                      child: GestureDetector(
                        child: _isIndo != true
                            ? Container(
                          padding: EdgeInsets.all(16.0),
                          //color: Colors.red,
                          child: Text(
                            "SKIP",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                            : Container(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "LEWATI",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          setOnBoarding();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                                return AuthenticationPage();
                              }));
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      right: 25.0,
                      child: GestureDetector(
                        child: _isIndo != true
                            ? Container(
                          padding: EdgeInsets.all(16.0),
                          //color: Colors.red,
                          child: Text(
                            "NEXT",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                            : Container(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "LANJUT",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          controller.nextPage(
                              duration: _kDuration, curve: _kCurve);
                        },
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      /*  child: Center(
                          child: Image.asset(
                        'images/Icon-app-splash-screen-3.png',
                        width: 150,
                      )), */
                    ),
                    Positioned(
                      bottom: 150,
                      left: 20,
                      right: 20,
                      child: Center(
                        child: Text(
                            "Membuat janji pertemuan sekarang menjadi lebih mudah",
                            style: TextStyle(
                                fontFamily: 'RobotoBold',
                                color: Colors.white,
                                fontSize: 16.0),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      right: 25.0,
                      child: GestureDetector(
                        child: _isIndo != true
                            ? Container(
                          padding: EdgeInsets.all(16.0),
                          //color: Colors.red,
                          child: Text(
                            "NEXT",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                            : Container(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "LANJUT",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          setOnBoarding();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                                return AuthenticationPage();
                              }));
                        },
                      ),
                    ),
                  ],
                ),
              ],
              controller: controller,
              reverse: false,
            ),
            align: IndicatorAlign.bottom,
            length: 4,
            indicatorSpace: 10.0,
            indicatorColor: Colors.white,
            indicatorSelectorColor: Colors.black,
          ),
        ),
      ),
    );
  }

}