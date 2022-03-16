import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playmusic/home_screen.dart';
import 'package:playmusic/screen/musicplay.dart';



GlobalKey<ScaffoldState> scaffoldState = GlobalKey();


class ArtistScreen extends StatefulWidget {


  String singer, image_artist, description ;

  ArtistScreen({required this.singer,required this.image_artist,required this.description});




  @override
  _ArtistScreenState createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {




  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      key: scaffoldState,
      body: Stack(
        children: <Widget>[

          _buildWidgetAlbumCover(mediaQuery),
          _buildWidgetActionAppBar(mediaQuery),
          _buildWidgetArtistName(mediaQuery),
          _buildWidgetFloatingActionButton(mediaQuery),
          _buildWidgetListSong(mediaQuery),
        ],
      ),
    );
  }

  Widget _buildWidgetArtistName(MediaQueryData mediaQuery) {
    return SizedBox(
      height: mediaQuery.size.height / 1.8,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: <Widget>[
                Positioned(
                  child: Text(
                    "",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "CoralPen",
                      fontSize: 72.0,
                    ),
                  ),
                  top: constraints.maxHeight - 100.0,
                ),
                Positioned(
                  child: Text(
                    "",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "CoralPen",
                      fontSize: 72.0,
                    ),
                  ),
                  top: constraints.maxHeight - 140.0,
                ),
                Positioned(
                  child: Text(
                    "",
                    style: TextStyle(
                      color: Color(0xFF7D9AFF),
                      fontSize: 14.0,
                      fontFamily: "Campton_Light",
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  top: constraints.maxHeight - 160.0,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWidgetListSong(MediaQueryData mediaQuery) {

    final CollectionReference artist = FirebaseFirestore.instance.collection('songs');

    return Container(


        child: StreamBuilder(


            stream: artist.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {

              if (streamSnapshot.hasData){

                return Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    top: mediaQuery.size.height / 1.8 + 48.0,
                    right: 20.0,
                    bottom: mediaQuery.padding.bottom + 16.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      _buildWidgetHeaderSong(),
                      SizedBox(height: 16.0),
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          separatorBuilder: (BuildContext context, int index) {
                            return Opacity(
                              opacity: 0.5,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Divider(
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];

                            if (documentSnapshot["singer"] == widget.singer ){
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
                                child: Row(

                                  children: <Widget>[

                                    SizedBox(height: 24.0),

                                    Expanded(


                                      child: Text(
                                        documentSnapshot["name"].toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Campton_Light",
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      documentSnapshot["singer"].toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                   // SizedBox(width: 24.0),
                               //    Icon(
                               //      Icons.more_horiz,
                               //      color: Colors.grey,
                               //    ),


                                  ],
                                ),
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
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

  Widget _buildWidgetHeaderSong() {

    return Row(

      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[

        Text(
          "รวมเพลงทั้งหมด",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24.0,
            fontFamily: "Campton_Light",
          ),
        ),
        Text(
          "ศิลปิน",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: "Campton_Light",
          ),
        ),

      ],

    );

  }

  Widget _buildWidgetFloatingActionButton(MediaQueryData mediaQuery) {
    return Align(

      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: mediaQuery.size.height / 1.8 - 32.0,
          right: 32.0,
        ),
        child: FloatingActionButton(
          child: Icon(
            Icons.play_arrow,
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          onPressed: () {

          },
        ),
      ),
    );
  }


  Widget _buildWidgetActionAppBar(MediaQueryData mediaQuery) {
    return  Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon:Icon(Icons.arrow_back_ios,),
          onPressed: (){
            Navigator.pop(context);

          },
        ),
        backgroundColor: Colors.black12,
        elevation: 0,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Artist About",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text((widget.singer ) , style: TextStyle(fontSize: 15))
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 8, left: 15),
            child: Icon(Icons.notifications_active_outlined, size: 30),
          )
        ],
      ),

    );
  }

  Widget _buildWidgetAlbumCover(MediaQueryData mediaQuery) {
    return Container(

      width: double.infinity,
      height: mediaQuery.size.height / 1.8,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(48.0),
        ),

        image: DecorationImage(
          image:
          NetworkImage(widget.image_artist),
          fit: BoxFit.cover,
        ),
      ),
    );
  }




}

