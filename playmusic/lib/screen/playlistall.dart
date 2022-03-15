import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:playmusic/api/database.dart';
import 'package:playmusic/screen/mainscreen.dart';
import 'package:playmusic/screen/miniplayer.dart';
import 'package:playmusic/screen/musicplay.dart';
import 'package:playmusic/screen/playlist.dart';
import 'package:playmusic/testcode/example_playlist.dart';
import 'package:playmusic/widget/artistwidget.dart';
import 'package:playmusic/widget/playlistwidget.dart';
import 'package:playmusic/widget/songkwidgetbottom.dart';

class PlayListAllScreen extends StatefulWidget {



  @override
  _PlayListAllState createState() => _PlayListAllState();
}



class _PlayListAllState extends State<PlayListAllScreen> with SingleTickerProviderStateMixin {

  final CollectionReference playlist = FirebaseFirestore.instance.collection('playlist');

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions:[

        ],
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),

        // leading: Icon(Icons.menu),

          title: Padding(
            padding: const EdgeInsets.only(top: 3.0, bottom: 3),
            child: Container(
              height: 40,
              padding: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white.withOpacity(0.1)),

              child: Center(
                child: Text(
                  "เพลย์ลิสเพลงของฉัน",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold , color: Colors.white ),
                ),
              ),
            ),
          ),


        flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                    Colors.black87,
                    //Color(0xff83565A),
                    Colors.black,
                  ]),
            )

        ),

      ),

      body: Stack(
        children: [
          GestureDetector(
          onTap: () {

              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new MyApp())
              );

        },

      child: Container(
        child:  Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [


                Row(
                  children: [

                    SizedBox(
                      height: 100,
                    ),

                    Hero(
                      tag: "image",
                      child: CircleAvatar(
                        backgroundImage: NetworkImage("https://static.thenounproject.com/png/258896-200.png"),
                        radius: 30,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("เพลย์ลิสเริ่มต้น",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                        Text("คลิกเพื่อใช้งาน",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500))
                      ],
                    ),
                  ],
                ),

              ],
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    ),

          SizedBox(
            height: 300,
          ),

          GestureDetector(
            onTap: () {

              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new PlaylistWidgetScreen(


                  ))
              );

            },

            child: Container(
              child:  Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [


                      Row(
                        children: [

                          SizedBox(
                            height: 250,
                          ),
                          Hero(
                            tag: "image",
                            child: CircleAvatar(
                              backgroundImage: NetworkImage("https://w7.pngwing.com/pngs/399/769/png-transparent-computer-icons-music-playlist-apple-text-logo-number.png"),
                              radius: 30,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("เพลย์ลิสเพลงของคุณ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                              Text("คลิกเพื่อใช้งาน",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ],
                      ),

                    ],
                  ),

                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          )


        ],
      ),
    );

  }
  refresh()
  {
    setState(() {});
  }
}




