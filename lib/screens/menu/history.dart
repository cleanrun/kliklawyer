import 'package:flutter/material.dart';
import 'package:kliklawyer/screens/video_call/video_call.dart';
import 'package:kliklawyer/screens/voice_call/voice_call.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dashboard.dart';

class HistoryPage extends StatefulWidget{
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>{
  final String _channelName = "KlikLaw2020";

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
                _contents(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _contents(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Call History',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600
            ),
          ),

          SizedBox(height: 20),

          ListTile(
            onTap: () async {
              //onJoin(_channelName);
              _showCallDialog(_channelName);
            },
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue,
            ),
            title: Text("Client 1"),
            subtitle: Text("Last contacted : 15:56 PM"),
          ),

          Divider(),

          ListTile(
            onTap: () async {
              //onJoin(_channelName);
              _showCallDialog(_channelName);
            },
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue,
            ),
            title: Text("Client 2"),
            subtitle: Text("Last contacted : 13:41 PM"),
          ),

          Divider(),

          ListTile(
            onTap: () async {
              //onJoin(_channelName);
              _showCallDialog(_channelName);
            },
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue,
            ),
            title: Text("Client 3"),
            subtitle: Text("Last contacted : 11:12 AM"),
          ),

          Divider(),

        ],
      ),
    );
  }

  Future<void> onJoinVideo(String channel) async {
    await _handleCameraAndMic();
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoCallPage(
          channelName: channel,
        ),
      ),
    );
  }

  Future<void> onJoinVoice(String channel) async {
    await _handleCameraAndMic();
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VoiceCallPage(
          channelName: channel,
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }

  Future<void> _showCallDialog(String channel){
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("Please select your call method"),
            actions: <Widget>[
              FlatButton(
                child: Text("Voice"),
                onPressed: () async {
                  onJoinVoice(channel);
                  Navigator.pop(context);
                },
              ),

              FlatButton(
                child: Text("Video"),
                onPressed: () async {
                  onJoinVideo(channel);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

}