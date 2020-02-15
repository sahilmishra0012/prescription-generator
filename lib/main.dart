import 'dart:async';
import 'dart:io';

import 'package:cryptoutils/cryptoutils.dart';

import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

import 'package:googleapis/speech/v1.dart';
import 'package:googleapis_auth/auth_io.dart';


final _credentials = new ServiceAccountCredentials.fromJson(r'''
{
  "type": "service_account",
  "project_id": "aaria-263910",
  "private_key_id": "a634b71f005b397a370c72d40f0a5cc768deaf7b",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDLUIaNFnonQ1pl\nkoaXowkOPGI7wEte87MA+y0FtMEQj1h3UgjfZhZF2HpMkgKkwX+kZ9NpVdFWCm2F\nKzBVWmKsyDB4xWMgwdgLqSjtK4SlGZJspghknWu8YyeuKJzJzS2rtINrFWk6ly9X\nIhpKHyHMD8sXUi14GRAhtU2B0EFIgRUAwvlp7vss8iEslrZ1GV/03/f6Q+u9Q58+\nc7YUzm+9epKHLdR4fmQMhwXTu1A6MpeH5mMXjs3GL+hGsosYD7ltgxt5FlFoEe+J\nXcGcemnPFK9I/IjyK4KjzMA7231vU2xjj1wU04wFqdEW/GV1TZybexz6Mof6Qvtx\niYyjZOkrAgMBAAECggEASlfbm2OIryq1t0Zo6LG48feqg+bAqKu73LP7toZtwjxo\nQNlCXU3a/xc1QSJyzQPkRJ2idHXo4elWOsecGNnAEyXwc3jZ0nSPJ1RnnrG3Axfi\nrs/XadMWPgCT1d8L1c6s0IhlNZbSr5XwvY++xTO1DAUKYjCuZ6fiejDtcnZQKM5C\n8sHQ/mzIt6qhmL6Ajqd7idXFTc2FJXpnPN0pwv38ajO57sPGZ7g8c0cHBC+PocwW\nEcpyVs5JsrEK95BAK9yoo4krGGv+h7jL/NlAJpMM3nSTKc8FEzFJjtOEcO+qLNOE\nVJkrWGV95gP4leQCcCD/+THIV1WMkcpmwtEhYzbywQKBgQD5287mTo+5Mg6AdLAg\n59zZpvE10D+qqazlPzyE629tOI421Uf2op2LkA8hDVRphQUXWkiAeTzLL1fErfEh\njJku5u6iV+SaVahGrdeTEkOWOP9jD9QAYzMHa92cECD6vEpRQbBNOeOOmI1pKPqD\nJEk0jKAB1q/HWY+RYOkkqIK4KQKBgQDQT9jQqHM436JHavEKEO6lUBkSNBInJk9F\n58CLG7MyHonyotakU0PO63IZuhFmHckgp6Z5BHCvd6oOvNQhlcCWkt38FRxyR0ci\n4QXvpF+5zbQGdhGvNMiSdnsBxIhap8eAfQrxcJJXotimYdgXAIS50j6x7HQN2Wph\nrTxp/BORMwKBgFfhq00wNrcR1y3xXP3F79USNecSn0IcufZMHrI1yRRmfwbkT5J9\nMeKjwd6DPLx8kATduYCOpAZnWXyRHa4KMNrhWO/68CoklLJ/dMKC+wi8dX9XUt7s\nBUfH9cNtnNv0HEOmUidnhBVkrOBfDHXR7nmwOJtM8riwVKHyry44ovm5AoGBALW/\ntM/46O8KT7A4Ii5CL7WUeQtk2yHFTw0S8u9sL6De/ETyxouBCnyS+G5x5ZRPEJip\nLZoQwbCWm41YO01CN1Iouf2i/brHbc2Ev4UiyVJ3o0av5SYUy5rePNyB+OX/1RTK\nBK47JbPIpXYlkEAhd6wZQBJE18ztkN/AIiHmibv5AoGBAIDTvmlk8jmHkOG1R1bm\nzHKhWV3KrpRa0zV5K+BphLs6rpqWPQYh6kwG5Tf1Pc1r4OdTVa34aiR22chJGQZO\nXqNZd6FKKGsABApEV6cqL8EQsHlTYkLS7/oQW842LIi4OiivlNwrBs1vq2yGCLg8\nc8939x8AQ0luj8pwEybynPfk\n-----END PRIVATE KEY-----\n",
  "client_email": "stt-943@aaria-263910.iam.gserviceaccount.com",
  "client_id": "112593585926873164924",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/stt-943%40aaria-263910.iam.gserviceaccount.com"
}
''');

const _SCOPES = const [SpeechApi.CloudPlatformScope];
List ll=['  ','  ','  ','  ','  '];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Audio Recorder Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Vaidya.AI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterAudioRecorder _recorder;
  Recording _recording;
  Timer _t;
  Widget _buttonIcon = Icon(Icons.do_not_disturb_on);
  String _alert;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _prepare();
    });
  }

  void _opt() async {
    switch (_recording.status) {
      case RecordingStatus.Initialized:
        {
          await _startRecording();
          break;
        }
      case RecordingStatus.Recording:
        {
          await _stopRecording();
          break;
        }
      case RecordingStatus.Stopped:
        {
          await _prepare();
          break;
        }

      default:
        break;
    }

    setState(() {
      _buttonIcon = _playerIcon(_recording.status);
    });
  }

  Future _init() async {
    String customPath = '/flutter_audio_recorder_';
    io.Directory appDocDirectory;
    if (io.Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }

    customPath = appDocDirectory.path +
        customPath +
        DateTime.now().millisecondsSinceEpoch.toString();

    // .wav <---> AudioFormat.WAV
    // .mp4 .m4a .aac <---> AudioFormat.AAC
    // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.

    _recorder = FlutterAudioRecorder(customPath,
        audioFormat: AudioFormat.WAV, sampleRate: 22050);
    await _recorder.initialized;
  }

  Future _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _init();
      var result = await _recorder.current();
      setState(() {
        _recording = result;
        _buttonIcon = _playerIcon(_recording.status);
        _alert = "";
      });
    } else {
      setState(() {
        _alert = "Permission Required.";
      });
    }
  }

  Future _startRecording() async {
    await _recorder.start();
    ll=['  ','  ','  ','  ','  '];
    var current = await _recorder.current();
    setState(() {
      _recording = current;
    });

    _t = Timer.periodic(Duration(milliseconds: 10), (Timer t) async {
      var current = await _recorder.current();
      setState(() {
        _recording = current;
        _t = t;
      });
    });
  }

  Future _stopRecording() async {
    var result = await _recorder.stop();
    _t.cancel();

    setState(() {
      _recording = result;
    });
  }

Future<void> _speechToText() async {
  var bytes = await new File(_recording.path).readAsBytesSync();
  // Do something with the bytes. For example, convert to base64.
  String content = CryptoUtils.bytesToBase64(bytes);
  clientViaServiceAccount(_credentials, _SCOPES).then((httpClient) {
    var speech = new SpeechApi(httpClient);
    RecognizeRequest r = new RecognizeRequest();
    RecognitionAudio audio = new RecognitionAudio.fromJson({ 'content': content});
    r.audio = audio;
    
    final _json = {
        "encoding": "LINEAR16",
        "sampleRateHertz": 22050,
        "languageCode": "en-IN"
 
    };
    RecognitionConfig config = new RecognitionConfig.fromJson(_json);
    r.config = config;
    var count=0;
    speech.speech.recognize(r).then((response) {
      for (var result in response.results) {
        var res=result.toJson();
        var res0=res.values.toList();
        var res1=res0[0].toString();
        var res2=res1.split(":");
        var res3=res2[res2.length-1];
        ll.insert(count,res3.substring(0,res3.length-2));
        count++;
      }
    });
  });
}

  Widget _playerIcon(RecordingStatus status) {
    switch (status) {
      case RecordingStatus.Initialized:
        {
          return Icon(Icons.fiber_manual_record);
        }
      case RecordingStatus.Recording:
        {
          return Icon(Icons.stop);
        }
      case RecordingStatus.Stopped:
        {
          return Icon(Icons.replay);
        }
      default:
        return Icon(Icons.do_not_disturb_on);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Name of the Patient',
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                ll.elementAt(0),
                style: Theme.of(context).textTheme.body1,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Age of the Patient',
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                ll.elementAt(1),
                style: Theme.of(context).textTheme.body1,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Assumed Disease',
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                ll.elementAt(2),
                style: Theme.of(context).textTheme.body1,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Prescription',
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                ll.elementAt(3),
                style: Theme.of(context).textTheme.body1,
              ),
              SizedBox(
                height: 20,
              ),

              SizedBox(
                height: 200,
              ),
              RaisedButton(
                child: Text('Generate Prescription'),
                disabledTextColor: Colors.white,
                disabledColor: Colors.grey.withOpacity(0.5),
                onPressed: _recording?.status == RecordingStatus.Stopped
                    ? _speechToText
                    : null,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '${_alert ?? ""}',
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _opt,
        child: _buttonIcon,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}