import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:playmusic/api/database.dart';
import 'package:playmusic/screen/mainscreen.dart';
import 'package:playmusic/screen/miniplayer.dart';
import 'package:playmusic/screen/musicplay.dart';
import 'package:playmusic/widget/artistwidget.dart';
import 'package:playmusic/widget/songkwidgetbottom.dart';

class PlayListScreen extends StatefulWidget {



  @override
  _PlayListScreenState createState() => _PlayListScreenState();
}



class _PlayListScreenState extends State<PlayListScreen> with SingleTickerProviderStateMixin {

  var tabbarController;
  var selectIndex = 0;

  void initState() {
    super.initState();
    tabbarController = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(

        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: ListView(
              children: [


                TabBar(
                  controller: tabbarController,
                  indicatorColor: Colors.pink,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 5,
                  tabs: [
                    Tab(
                      child: Text("รายการเพลงทั้งหมด"),
                    ),
                    Tab(
                      child: Text("รายชื่อศิลปินทั้งหมด"),
                    ),

                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: LimitedBox(
                    maxHeight: 400,
                    child: TabBarView(
                      controller: tabbarController,

                      children: [

                        SongskWidget(
                          notifyParent: refresh,
                        ),


                        ArtistWidget(

                          notifyParent: refresh, tag: 'artist',
                        ),



                      ],
                    ),
                  ),
                ),


              ],
            ),
          ),

          //     Align(
          //       alignment: Alignment.bottomCenter,
          //
          //       child: PlayerHome(currentSong),
          //     ),

        ],
      ),
    );

  }
  refresh()
  {
    setState(() {});
  }
}



class SongskWidget extends StatelessWidget {


  final Function() notifyParent;

  SongskWidget({

    required this.notifyParent});


  final CollectionReference songs = FirebaseFirestore.instance.collection('songs');


  @override
  Widget build(BuildContext context) {


    return Container(

        child: StreamBuilder(

            stream: songs.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {

              if (streamSnapshot.hasData){


                return Container(

                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: streamSnapshot.data!.docs.length,
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



                            notifyParent();
                          },
                          child: Container(

                            child:  Column(
                              children: <Widget>[

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Hero(
                                          tag: "image",
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(documentSnapshot["image"].toString()),
                                            radius: 30,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(documentSnapshot["name"].toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700)),
                                            Text(documentSnapshot["singer"].toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500))
                                          ],
                                        ),
                                      ],
                                    ),

                                    //Expanded(child: MusicBarScreen(song)),

                                    //       Expanded(child: Songkwidgetbottom(
                                    //         name: documentSnapshot["name"].toString(),
                                    //         image : documentSnapshot["image"].toString(),
                                    //         url : documentSnapshot["url"].toString(),
                                    //         singer: documentSnapshot["singer"].toString(),
                                    //         duration: documentSnapshot["duration"].toInt(),
                                    //       ),
                                    //       )


                                  ],
                                ),

                                SizedBox(
                                  height: 20,
                                ),



                              ],





                            ),


                          ),


                        );



                      }


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


class ArtistWidget extends StatelessWidget {
  final tag;
  final Function() notifyParent;

  ArtistWidget(
      {

        required this.notifyParent,
         required this.tag}
      );

  final CollectionReference artist = FirebaseFirestore.instance.collection('artist');


  @override
  Widget build(BuildContext context) {

    return Container(

        child: StreamBuilder(
            stream: artist.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData){
                return Container(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      shrinkWrap: true,
                      itemCount: streamSnapshot.data!.docs.length,
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
                          notifyParent();
                        },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),

                            child: Container(
                              margin: new EdgeInsets.all(1.0),
                              child: Column(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Hero(tag: 'artist',
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(documentSnapshot["image_artist"].toString(),
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      documentSnapshot["singer"].toString(),
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold , color: Colors.white),
                                    ),

                                  ),
                                  Row(
                                    children: [

                                   //   Text(documentSnapshot["description"].toString(),
                                   //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold , color: Colors.white),
                                   //   ),

                                      Spacer(),

                                  //    Text(documentSnapshot["description"].toString(),
                                  //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold , color: Colors.white),
                                  //    )

                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
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



class PlaylistWidget extends StatelessWidget {

  final Function() notifyParent;

  PlaylistWidget(
      {

        required this.notifyParent}
      );

  final CollectionReference playlist = FirebaseFirestore.instance.collection('playlist');


  @override
  Widget build(BuildContext context) {

    return Container(

        child: StreamBuilder(

            stream: playlist.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {

              if (streamSnapshot.hasData){


                return Container(

                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: streamSnapshot.data!.docs.length,
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


                            notifyParent();
                          },
                          child: Container(

                            child:  Stack(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: NetworkImage(documentSnapshot['image_artist'].toString()),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(documentSnapshot['singer'].toString(),
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w700)),
                                                Text(documentSnapshot['description'].toString(),
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500)),

                                              ],

                                            ),

                                          ),

                                        ],

                                      ),

                                    ),
                                    SizedBox(
                                      height: 80.0,
                                    ),
                                  ],

                                ),

                              ],




                            ),

                          ),

                        );



                      }


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


