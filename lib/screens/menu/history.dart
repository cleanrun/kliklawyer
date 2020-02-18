import 'package:flutter/material.dart';

import 'dashboard.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPage createState() => _HistoryPage();
}

class _HistoryPage extends State<HistoryPage> {
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
            child: Text("History"),
          ),
        ),
      ),
    );
  }
}