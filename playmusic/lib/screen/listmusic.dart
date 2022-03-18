import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playmusic/api/database.dart';
import 'package:playmusic/screen/musicplay.dart';
import 'package:playmusic/service/DataController.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);


  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController searchController = TextEditingController();
  late QuerySnapshot snapshotData;
  late bool isExcecuted = false;


  @override
  Widget build(BuildContext context) {
    
    Widget searchedData(){
      return ListView.builder(
          itemCount: snapshotData.docs.length,
          itemBuilder: (BuildContext context, int index) {

            final DocumentSnapshot documentSnapshot = snapshotData.docs[index];

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

                child:  Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
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
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            );
          }
      );
    }

    return Scaffold(

    // floatingActionButton: FloatingActionButton(child: Icon(Icons.clear), onPressed: () {
    //   setState(() {
    //     isExcecuted = false;
    //   });
    //
    // }),

        appBar: AppBar(
          actions:[
          GetBuilder<DataController>(
            init: DataController(),
            builder: (val) {
              return IconButton(icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 20,
              ),
                  onPressed: () {
                val.queryData(searchController.text).then((value) {
                  snapshotData = value;
                  setState(() {
                    isExcecuted = true;
                  });
                });

                  });
            },
          )

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

               child: TextField(
                 style: TextStyle(color: Colors.white),
                 decoration: InputDecoration(

                     hintText: "   ค้นหาเพลงที่ต้องการ...",
                     hintStyle: TextStyle(
                       color: Colors.white,
                     )),
                 controller: searchController,
               ),
             ),
           ),

          leading: IconButton(icon: Icon(
            Icons.refresh,
            color: Colors.white,
            size: 20,
          ),
              onPressed: () {
    setState(() {
         isExcecuted = false;
       });

              }),
          
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
        backgroundColor: Colors.black,

        body: isExcecuted ? searchedData() : Container(

          child: Center(
            child: Text('ค้นหาเพลงที่คุณต้องการ',style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500)
            ),
          ),
        ),

    );
  }
}
