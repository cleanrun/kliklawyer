import 'package:flutter/material.dart';

import 'dashboard.dart';

class ProfilePage extends StatefulWidget{
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.fromLTRB(7, 10, 7, 0),
            child: ListView(
              children: <Widget>[
                _header(),

                SizedBox(height: 20),

                _contents(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(){
    return Container(
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height/8,
                  width: MediaQuery.of(context).size.height/8,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ),

          SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Lawyer',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                ),
              ),

              Text(
                'lawyer@example.com',
                style: TextStyle(
                    fontSize: 15
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _contents(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(),

          ListTile(
            leading: Icon(Icons.language, color: Colors.blue,),
            title: Text("Change Language", style: TextStyle(fontWeight: FontWeight.w600),),
          ),

          Divider(),

          ListTile(
            leading: Icon(Icons.lock_outline, color: Colors.blue,),
            title: Text("Privacy and Policy", style: TextStyle(fontWeight: FontWeight.w600),),
          ),

          Divider(),

          ListTile(
            leading: Icon(Icons.help_outline, color: Colors.blue,),
            title: Text("About KlikLawyer", style: TextStyle(fontWeight: FontWeight.w600),),
          ),

          Divider(),

          ListTile(
            title: Text("Logout", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),),
          ),

          Divider(),

        ],
      ),
    );
  }

}