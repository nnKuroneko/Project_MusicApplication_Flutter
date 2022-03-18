import 'dart:typed_data';
import 'dart:ui';

import 'package:audio_manager/audio_manager.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playmusic/api/database.dart';
import 'package:playmusic/music.dart';
import 'package:playmusic/screen/listmusic.dart';
import 'package:playmusic/screen/mainscreen.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:playmusic/screen/musicplay.dart';

// ของเก่า audio player ไม่ได้ใช้

class Songkwidgetbottom extends StatefulWidget {
  String name, image, url, singer ;
  int duration;

  Songkwidgetbottom({required this.name,required this.image,required this.url,required this.singer,required this.duration});

  @override
  _SongkwidgetbottomState createState() => _SongkwidgetbottomState();
}

class _SongkwidgetbottomState extends State<Songkwidgetbottom> {


  double _sliderValue = 0;
  int maxduration = 100;
  int currentpos = 0;
  String currentpostlabel = "00:00";
  String audioasset = (currentSong.url);
  bool isplaying = false;
  bool audioplayed = false;
  late Uint8List audiobytes;

  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {

      ByteData bytes = await rootBundle.load(audioasset); //load audio from assets
      audiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      //convert ByteData to Uint8List

      player.onDurationChanged.listen((Duration d) { //get the duration of audio
        maxduration = d.inMilliseconds;
        setState(() {

        });
      });

      player.onAudioPositionChanged.listen((Duration  p){
        currentpos = p.inMilliseconds; //get the current position of playing audio

        //generating the duration label
        int shours = Duration(milliseconds:currentpos).inHours;
        int sminutes = Duration(milliseconds:currentpos).inMinutes;
        int sseconds = Duration(milliseconds:currentpos).inSeconds;

        int rhours = shours;
        int rminutes = sminutes - (shours * 60);
        int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

        currentpostlabel = "$rminutes:$rseconds";

        setState(() {
          //refresh the UI
        });
      });

    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(child:
        Icon(Icons.skip_previous_outlined,color: Colors.white, size: 20)
          ,onTap: (){



          },
        ),
        InkWell(child:
        Icon(isplaying?Icons.pause:Icons.play_arrow,color: Colors.white, size: 15)
          ,onTap: () async {
            if(!isplaying && !audioplayed){
              int result = await player.play(widget.url);
              if(result == 1){ //play success
                setState(() {
                  isplaying = true;
                  audioplayed = true;
                });
              }else{
                print("Error while playing audio.");
              }
            }else if(audioplayed && !isplaying){
              int result = await player.resume();
              if(result == 1){ //resume success
                setState(() {
                  isplaying = true;
                  audioplayed = true;
                });
              }else{
                print("Error on resume audio.");
              }
            }else{
              int result = await player.pause();
              if(result == 1){ //pause success
                setState(() {
                  isplaying = false;
                });
              }else{
                print("Error on pause audio.");
              }
            }
          },
        ),
        InkWell(child:
        Icon(Icons.skip_next_outlined,color: Colors.white, size: 20)
          ,onTap: (){



          },
        ),



      ],
    );
  }
}
