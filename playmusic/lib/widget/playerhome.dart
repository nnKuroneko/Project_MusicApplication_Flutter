import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:playmusic/api/database.dart';
import 'package:playmusic/login.dart';
import 'package:playmusic/screen/listmusic.dart';
import 'package:playmusic/screen/mainscreen.dart';
import 'package:playmusic/screen/musicbar.dart';
import 'package:playmusic/screen/musicplay.dart';
import 'package:playmusic/screen/playlist.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:playmusic/screen/userproflie.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:audioplayers/audioplayers.dart';


// ส่วนของ Miniplayer ไม่ได้ใช้

class PlayerHome extends StatefulWidget {

  String name, image, url, singer ;
  int duration;

  PlayerHome({required this.name,required this.image,required this.url,required this.singer,required this.duration});

  @override
  _PlayerHomeState createState() => _PlayerHomeState();
}

class _PlayerHomeState extends State<PlayerHome> with SingleTickerProviderStateMixin {

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


  late List<DocumentSnapshot> _list;

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('playlist')
          .orderBy('name')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          _list = snapshot.data!.docs;

          return ListView.custom(
              childrenDelegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return buildlist(context, _list[index]);
                },
                childCount: _list.length,
              )

          );

        }
      },
    );

  }

  Widget buildlist(BuildContext context, DocumentSnapshot documentSnapshot) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MusicPlayer(

              name: documentSnapshot["name"].toString(),
              image : documentSnapshot["image"].toString(),
              url : documentSnapshot["url"].toString(),
              singer: documentSnapshot["singer"].toString(),
              duration: documentSnapshot["duration"].toInt(),


            ),
            //pageBuilder: (context, _, __) => MusicBarScreen(widget.song)

          ),
        );

        setState(() {
          player.stop();
        });

      },
      //บรรทัดใส่ Musicbar
      child: Container(
          height: 80,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(topRight: Radius.circular(10))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: "image",
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.image),
                          radius: 30,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Text(widget.singer,
                              style: TextStyle(
                                color: Colors.white54,
                              ))
                        ],
                      ),
                    ],
                  ),

                  //Expanded(child: MusicBarScreen(song)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(child:
                      Icon(Icons.skip_previous_outlined,color: Colors.white, size: 40)
                        ,onTap: (){

                          player.stop();

                        },
                      ),
                      InkWell(child:
                      Icon(isplaying?Icons.pause:Icons.play_arrow,color: Colors.white, size: 40)
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
                      Icon(Icons.skip_next_outlined,color: Colors.white, size: 40)
                        ,onTap: (){

                          player.stop();

                        },
                      ),



                    ],
                  ),

                ],
              ),




            ],
          )
      ),
    );
  }

}
