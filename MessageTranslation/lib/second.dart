import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/cupertino.dart';
// import '../Audio/audiofile.dart';


class Second extends StatefulWidget {
  var messageone;
  Second({required this.messageone});
  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> {
  var translator;
  var translation='';
  @override
  void initState() {
    translator = GoogleTranslator();
    temp();
    super.initState();
  }

  Future temp() async{
    var translation = await translator.translate(widget.messageone, to: 'ta');
    setState(() {
      this.translation =  translation.toString();;
      print(this.translation);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("தமிழ் மொழியாக்கம் "),
        backgroundColor: Color.fromARGB(255, 246, 100, 2),
      ),

      
    
        body: Center(child: Column(children: <Widget>[  
            
            Container(
               padding: EdgeInsets.all(20),
        child: (this.translation!='')?ListTile(
          leading: Icon(Icons.message),
          subtitle: Text(this.translation),
        
        ):CircularProgressIndicator(),
        
      ), 
       (this.translation!='')?Container(  
              margin: EdgeInsets.all(25),  
              child: Audiofile(value: this.translation),
            ):CircularProgressIndicator(), 
          ]  
         )) 
    );
  }
}

class Audiofile extends StatefulWidget {
  String value;
  Audiofile({required this.value});
  @override
  AudiofileState createState() => AudiofileState();
}

enum TtsState { playing, stopped }

class AudiofileState extends State<Audiofile> {
  late FlutterTts _flutterTts;
  String? _tts;
  TtsState _ttsState = TtsState.stopped;

  @override
  void initState() {
    super.initState();
    setState(() {
      this._tts = widget.value;
    });
    initTts();
  }

  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
  }

  initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.awaitSpeakCompletion(true);

    _flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        _ttsState = TtsState.playing;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        _ttsState = TtsState.stopped;
      });
    });

    _flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        _ttsState = TtsState.stopped;
      });
    });

    _flutterTts.setErrorHandler((message) {
      setState(() {
        print("Error: $message");
        _ttsState = TtsState.stopped;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  
             Column(children: [button()]);
  }

  Widget button() {
    if (_ttsState == TtsState.stopped) {
      return RaisedButton(onPressed: speak, child: const Text('வாசிக்க'),color: Color.fromARGB(255, 239, 159, 106),);
    } else {
      return TextButton(onPressed: stop, child: const Text('நிறுத்து'));
    }
  }

  Future speak() async {
    await _flutterTts.setVolume(1);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1);
    await _flutterTts.setLanguage('ta');

    if (_tts != null) {
      if (_tts!.isNotEmpty) {
        await _flutterTts.speak(_tts!);
      }
    }
  }

  Future stop() async {
    var result = await _flutterTts.stop();
    if (result == 1) {
      setState(() {
        _ttsState = TtsState.stopped;
      });
    }
  }
}