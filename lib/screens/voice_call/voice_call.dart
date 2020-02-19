import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:all_sensors/all_sensors.dart';
import 'package:flutter/material.dart';
import 'package:kliklawyer/utils/agora_settings.dart';
import 'package:screen/screen.dart';

class VoiceCallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;

  /// Creates a call page with given channel name.
  const VoiceCallPage({Key key, this.channelName}) : super(key: key);

  @override
  _VoiceCallPageState createState() => _VoiceCallPageState();
}

class _VoiceCallPageState extends State<VoiceCallPage> {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool speaker = false;

  bool _proximityValues = true;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
  <StreamSubscription<dynamic>>[];

  var swatch = Stopwatch();
  final dur = const Duration(seconds: 1);
  String stopTimeToDisplay = "00:00:00";
  void startimer() {
    Timer(dur, keeprunning);
  }

  void keeprunning() {
    if (swatch.isRunning) {
      startimer();
    }
    setState(() {
      stopTimeToDisplay = swatch.elapsed.inHours.toString().padLeft(2, "0") +
          ":" +
          (swatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
          ":" +
          (swatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
    });
  }

  void _onToogleSpeaker() {
    setState(() {
      speaker = !speaker;
    });
    AgoraRtcEngine.setEnableSpeakerphone(speaker);
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();

    _streamSubscriptions.add(proximityEvents.listen((ProximityEvent event) {
      setState(() {
        _proximityValues = event.getValue();
        if (_proximityValues) {
          Screen.setBrightness(0.0);
        } else if (!_proximityValues) {
          Screen.setBrightness(0.1);
        }
      });
    }));
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.enableAudio();
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
        String channel,
        int uid,
        int elapsed,
        ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
        int uid,
        int width,
        int height,
        int elapsed,
        ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  /// Video view wrapper

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  @override
  Widget build(BuildContext context) {
    final views = _getRenderViews();
    if (views.length == 2) {
      setState(() {
        swatch.start();
        startimer();
      });
    }
    return WillPopScope(
        child: Scaffold(
          body: SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.brown,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(top: 16.0),
                                child: Center(
                                  child: Text(
                                    "KLIKLAWYER VOICE CALL".toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white60),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(32.0),
                                child: Center(
                                  child: Text(
                                    "Client ",
                                    style: TextStyle(
                                        fontSize: 24.0, color: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(bottom: 16.0),
                                child: Center(
                                  child: Text(
                                    views.length == 2
                                        ? "$stopTimeToDisplay"
                                        : "Ringing",
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white60),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.green,
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: GestureDetector(
                                    child: Container(
                                      width: 80.0,
                                      height: 80.0,
                                      margin: EdgeInsets.only(bottom: 48.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.call_end,
                                          size: 40.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      _onCallEnd(context);
                                    },
                                  )),
                            )),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: IconButton(
                                      icon: Icon(
                                        speaker
                                            ? Icons.volume_off
                                            : Icons.volume_up,
                                        size: 30.0,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        _onToogleSpeaker();
                                      })),
                              Expanded(
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.videocam,
                                        size: 30.0,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        /*   Fluttertoast.showToast(
                                        msg: 'Coming Soon',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER); */
                                        /* setState(() {
                                  _dismiss();
                                }); */
                                      })),
                              Expanded(
                                  child: IconButton(
                                      icon: Icon(
                                        muted ? Icons.mic_off : Icons.mic,
                                        size: 30.0,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        _onToggleMute();
                                      }))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  _proximityValues
                      ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black,
                  )
                      : Container()
                ],
              )),
        ),
        onWillPop: () async => Navigator.of(context).pop());
  }
}