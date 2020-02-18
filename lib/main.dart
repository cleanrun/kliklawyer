import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kliklawyer/screens/first_page/getting_started.dart';
import 'package:kliklawyer/screens/first_page/phone_auth.dart';
import 'package:kliklawyer/screens/menu/dashboard.dart';
import 'package:kliklawyer/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(MyApp());

FirebaseUser user;

//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      //home: MyHomePage(title: 'Flutter Demo Home Page'),
//    );
//  }
//}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => new _MyApp();
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyApp state = context.ancestorStateOfType(TypeMatcher<_MyApp>());

    state.setState(() {
      state.locale = newLocale;
    });
  }
}

class _MyApp extends State<MyApp> {
  Locale locale;
  //ThemeChanger _themeChanger;

  _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    String locales = prefs.getString('locale');
    String countyCodes = prefs.getString('countyrCode');

    if (locales == null) {
      locales = "en";
    }

    if (countyCodes == null) {
      countyCodes = "US";
    }
    return Locale(locales, countyCodes);
  }

  @override
  void initState() {
    super.initState();
    //_themeChanger = Provider.of<ThemeChanger>(context);
    this._fetchLocale().then((locale) {
      setState(() {
        this.locale = locale;
      });
    });
    //_getMode();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      builder: (_) => ThemeChanger(ThemeData.light()),
      child: MaterialAppWithTheme(
        locale: this.locale,
        ctx: context,
      ),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  final Locale locale;
  final BuildContext ctx;

  MaterialAppWithTheme({@required this.locale, this.ctx});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      locale: this.locale,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme.getTheme(),
      /* supportedLocales: [Locale('en', 'US'), Locale('id', 'ID')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      }, */
      home: CheckUser(
        ctx: ctx,
      ),
    );
  }
}

class CheckUser extends StatefulWidget {
  CheckUser({Key key, this.title, this.ctx}) : super(key: key);

  final String title;
  final BuildContext ctx;

  @override
  _CheckUser createState() => new _CheckUser();
}

class _CheckUser extends State<CheckUser> {
  bool hasUser, onBoarding;
  String nPhone;
  String fullName = " ", email = " ", noHp = " ", uid = " ", urlImage = " ";
  String imagefirebase = " ";

  FirebaseUser mCurrentUser;

  @override
  void initState() {
    super.initState();
    //onBoarding = false;
    //haveUser();
    //signOutGoogle();
    Future.delayed(Duration.zero, () {
      this.haveUser().then((value) {
        setState(() {
          hasUser = value;
        });
      });
      this._onBoard().then((value) {
        setState(() {
          onBoarding = value;
        });
      });
      this._getPhoneNumber().then((value) {
        setState(() {
          nPhone = value;
        });
      });
    });
  }

  Future<bool> _onBoard() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    onBoarding = pref.getBool('onBoarding');
    if (onBoarding == null) {
      onBoarding = false;
    }
    return onBoarding;
  }

  Future<String> _getPhoneNumber() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    nPhone = pref.getString('numberPhone');
    return nPhone;
  }

  Future<bool> haveUser() async {
    //hasUser = false;
    user = await FirebaseAuth.instance.currentUser();
    SharedPreferences pref = await SharedPreferences.getInstance();
    //FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    mCurrentUser = await FirebaseAuth.instance.currentUser();

    if (onBoarding == null) {
      setState(() {
        onBoarding = false;
      });
    }

//    _firebaseMessaging.getToken().then((value) {
//      print("tokent id : $value");
//    });

    if (nPhone != null) {
      hasUser = true;
      DatabaseReference dbf =
      FirebaseDatabase.instance.reference().child("users").child(nPhone);
      if (dbf != null) {
        LinkedHashMap map = new LinkedHashMap<String, dynamic>();
        dbf.once().then((DataSnapshot snapshot) {
          setState(() {
            map = snapshot.value;
            uid = map['id'];
            fullName = map['fullName'];
            email = map['email'];
            noHp = map['phoneNumber'];
            urlImage = map['imageURL'];
            if (urlImage != null && urlImage != " ") {
              pref.setString('imageFirebase', urlImage);
            }
          });
        });
        imagefirebase = pref.getString('imageFirebase');
      } else {
        hasUser = false;
      }
    } else if (nPhone == null) {
      hasUser = false;
    }
    return hasUser;
  }

  Widget _buildWidget() {
    haveUser();
    print("hasUser $hasUser && onBoarding: $onBoarding");
    Widget c;
    if (hasUser == true) {
      c = DashboardPage();
    } else if (hasUser == false) {
      if (onBoarding == null) {
        c = GettingStartedPage();
      } else if (onBoarding == false) {
        c = GettingStartedPage();
      } else if (onBoarding == true) {
        c = AuthenticationPage();
      }
    }
    return c;
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: _buildWidget(),
        title: Text("KlikLawyer"),
        backgroundColor: Color.fromRGBO(45, 127, 238, 1),
        styleTextUnderTheLoader: new TextStyle(),
        onClick: () => print("yeay"),
        loaderColor: Colors.white);
  }
}

