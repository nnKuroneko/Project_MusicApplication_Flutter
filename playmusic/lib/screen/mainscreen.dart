import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:playmusic/api/database.dart';
import 'package:playmusic/screen/miniplayer.dart';
import 'package:playmusic/home_screen.dart';
import 'package:playmusic/screen/listmusic.dart';
import 'package:playmusic/screen/miniplayer.dart';
import 'package:playmusic/screen/musicbar.dart';
import 'package:playmusic/screen/musicplay.dart';
import 'package:audio_manager/audio_manager.dart';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:playmusic/widget/artistwidget.dart';
import 'package:playmusic/widget/playerhome.dart';


class MainScreen extends StatefulWidget {


  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>  with SingleTickerProviderStateMixin {




  @override
  Widget build(BuildContext context) {

    return Scaffold(

        backgroundColor: Colors.black,


        body: Stack(
          children: [

            SingleChildScrollView(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width ,
                    height: 20,
                    color: Colors.black,
                  ),

                  Text(
                    "  เพลงยอดนิยม",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold , color: Colors.white,),
                  ),
                  const SizedBox(
                    height: 15,
                  ),


                  BannerMusickWidget(

                    notifyParent: refresh,
                  ),



                  const SizedBox(height: 10.0),
                  Container(
                    width: MediaQuery.of(context).size.width ,
                    height: 10,
                    color: Colors.black,
                  ),

                  // Text(
                  //   "  รายการเพลง",
                  //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold , color: Colors.white,),
                  // ),
                  const SizedBox(
                    height: 15,
                  ),

                  CircleTrackWidget(

                    title: "รายชื่อเพลง",
                    subtitle: "เพลง & ศิลปิน",
                    notifyParent: refresh,
                  ),
                  SizedBox(height: 30,
                  ),

                  ArtistCircleWidget(

                    title: "ศิลปิน",
                    subtitle: "ศิลปิน & แนะนำ",
                    notifyParent: refresh,
                  ),

                  SizedBox(height: 100,

                  ),

                ],
              ),
            ),



            Align(
              alignment: Alignment.bottomCenter,
              //child: PlayerHome(),
            ),



          ],
        )
    );

  }

  refresh()
  {
    setState(() {});
  }


}


Song currentSong = Song(
    name: "",
    singer: "",
    url: "assets/songs/",
    image: "",
    duration: 100
);


double currentSlider = 0;


class CircleTrackWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function() notifyParent;

  CircleTrackWidget(
      {
        required this.title,
        required this.subtitle,
        required this.notifyParent}
      );

  AudioPlayer player = AudioPlayer();

  final CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 210,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, bottom: 20),
            child: Text(
              subtitle,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),

          StreamBuilder(

              stream: songs.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot)

              {

                if (streamSnapshot.hasData){

                  return Container(
                    height: 120,
                    child: ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];

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

                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(documentSnapshot['image'].toString()),
                                  radius: 40,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  documentSnapshot['name'].toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  documentSnapshot['singer'].toString(),
                                  style: TextStyle(color: Colors.white54),
                                )
                              ],
                            ),
                          ),

                        );
                      },


                    ),
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),

                );

              }

          )

        ],
      ),
    );
  }
}


class ArtistCircleWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function() notifyParent;

  ArtistCircleWidget(
      {
        required this.title,
        required this.subtitle,
        required this.notifyParent}
      );

  AudioPlayer player = AudioPlayer();

  final CollectionReference artist = FirebaseFirestore.instance.collection('artist');

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 210,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, bottom: 20),
            child: Text(
              subtitle,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),

          StreamBuilder(

              stream: artist.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot)

              {

                if (streamSnapshot.hasData){

                  return Container(
                    height: 120,
                    child: ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];

                        return GestureDetector(
                          onTap: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArtistScreen(

                                  singer: documentSnapshot["singer"].toString(),
                                  image_artist : documentSnapshot["image_artist"].toString(),
                                  description: documentSnapshot["description"].toString(),


                                ),
                                //pageBuilder: (context, _, __) => MusicBarScreen(widget.song)

                              ),
                            );

                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(documentSnapshot['image_artist'].toString()),
                                  radius: 40,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  documentSnapshot['singer'].toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  documentSnapshot['description'].toString(),
                                  style: TextStyle(color: Colors.white54),
                                )
                              ],
                            ),
                          ),

                        );
                      },


                    ),
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),

                );

              }

          )

        ],
      ),
    );
  }
}


class BannerMusickWidget extends StatelessWidget {


  final Function() notifyParent;

  BannerMusickWidget(
      {

        required this.notifyParent}
      );

  final CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  @override
  Widget build(BuildContext context) {

    return Container(

        child: StreamBuilder(

            stream: songs.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot)

            {
              if (streamSnapshot.hasData){

                return Container(
                  height: 200,
                  child: Swiper(
                    viewportFraction: 0.8,
                    scale: 0.9,
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {

                      final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];

                      return GestureDetector(

                          child: Stack(

                              children: <Widget>
                              [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        image: NetworkImage(documentSnapshot['image'].toString()),
                                        fit: BoxFit.cover,
                                      )),
                                ),

                                //    Container(
                                //      alignment: Alignment.center,
                                //      decoration: BoxDecoration(
                                //          borderRadius: BorderRadius.circular(10.0),
                                //          color: Colors.white.withOpacity(0.3)),
                                //      child: Text(
                                //        (documentSnapshot['singer'].toString()),
                                //        style: TextStyle(
                                //          color: Colors.black,
                                //          fontWeight: FontWeight.bold,
                                //          fontSize: 24.0,
                                //        ),
                                //      ),
                                //    )

                              ]
                          )

                      );



                      return const Center(
                        child: CircularProgressIndicator(),

                      );

                    },

                  ),
                );





              }

              return const Center(
                child: CircularProgressIndicator(),

              );

            }


        )


    );










  }
}