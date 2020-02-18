import 'package:flutter/material.dart';
import 'package:kliklawyer/screens/menu/profile.dart';
import 'package:kliklawyer/utils/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import 'history.dart';
import 'home.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage>
    with TickerProviderStateMixin {
  Choice _selectedChoice = choices[0];

  void _select(Choice choice) {
    setState(() {
      _selectedChoice = choice;
      signOutGoogle();
      _clearSharedPReference();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
            return MyApp();
          }), ModalRoute.withName('/'));
    });
  }

  int _selectedIndex = 0;

  void _clearSharedPReference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      signOutGoogle();
      pref.setString('numberPhone', null);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _list = <Widget>[
      HomePage(),
      HistoryPage(),
      ProfilePage(),
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text("APPS Bottom Navigation"),
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[Icon(choice.icon), Text(choice.title)],
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: _list.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          unselectedLabelStyle: TextStyle(fontFamily: 'RobotoBold'),
          selectedLabelStyle: TextStyle(
              color: Color.fromRGBO(45, 127, 238, 1), fontFamily: 'RobotoBold'),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              title: Text("History"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile"),
            ),
          ],
        ));
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Logout', icon: Icons.person),
];