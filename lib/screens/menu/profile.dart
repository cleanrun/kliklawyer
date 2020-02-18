import 'package:flutter/material.dart';

import 'dashboard.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  Future<bool> _onWillPop() {
    return Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) {
      return DashboardPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          child: Center(
            child: Text("Profile"),
          ),
        ),
      ),
    );
  }
}