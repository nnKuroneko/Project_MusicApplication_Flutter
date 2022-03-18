import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playmusic/home_screen.dart';
import 'package:playmusic/screen/musicplay.dart';



GlobalKey<ScaffoldState> scaffoldState = GlobalKey();


class PlaylistWidgetScreen extends StatefulWidget {




  @override
  _PlaylistWidgetScreenState createState() => _PlaylistWidgetScreenState();
}

class _PlaylistWidgetScreenState extends State<PlaylistWidgetScreen> {




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

    final CollectionReference playlist = FirebaseFirestore.instance.collection('playlist');

    Future<void> _deleteProduct(String productId) async {
      await playlist.doc(productId).delete();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('ทำการลบรายการเรียบร้อย')));

    }

    return Container(


        child: StreamBuilder(


            stream: playlist.snapshots(),
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
                            return SizedBox.shrink();
                          },


                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {

                            final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                            final uid = FirebaseAuth.instance.currentUser!.uid;

                            if(uid ==  documentSnapshot["uid"].toString()) {
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
                                    IconButton(
                                        icon: const Icon(Icons.delete,color: Colors.white,size: 20,),
                                        onPressed: () =>
                                            _deleteProduct(documentSnapshot.id)),
                                    // SizedBox(width: 24.0),
                                    //    Icon(
                                    //      Icons.more_horiz,
                                    //      color: Colors.grey,
                                    //    ),


                                  ],
                                ),


                              );
                            }else{
                              return SizedBox.shrink();
                            }


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
                "Playlist Music",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(("เพลย์ลิสของคุณ") , style: TextStyle(fontSize: 15))
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 8, left: 15),
            child: Icon(Icons.my_library_music, size: 30),
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
          NetworkImage("https://thumbs.dreamstime.com/b/illustration-style-cartoon-woman-listening-to-music-blue-background-musical-notes-person-listen-183792403.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }




}

