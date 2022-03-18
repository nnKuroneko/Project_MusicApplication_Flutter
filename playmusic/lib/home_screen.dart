import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:playmusic/screen/playlistall.dart';
import 'package:playmusic/screen/userproflie.dart';
import 'package:playmusic/testcode.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:audioplayers/audioplayers.dart';

enum Section
{
  Home,
  Profile,
  Setting,
  Signout
}

List searchedList = Hive.box('cache').get('ytHome', defaultValue: []) as List;
List headList = Hive.box('cache').get('ytHomeHead', defaultValue: []) as List;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);



  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  int currentIndex = 0;
  List pages = [MainScreen(),PlayListScreen(),Search(),PlayListAllScreen()]; //array 0 1 2

  var drawerkey = GlobalKey<ScaffoldState>();

  final auth = FirebaseAuth.instance;
  //final auth = FirebaseAuth.instance;

  final user_email = FirebaseAuth.instance.currentUser!.email;
  //final uid = FirebaseAuth.instance.currentUser!.uid;
  final username = FirebaseAuth.instance.currentUser!.displayName;
  final avatarUrl = FirebaseAuth.instance.currentUser!.photoURL;

  //final photo = FirebaseAuth.instance.currentUser!;

  Widget currentWidget = ProfileScreen();



  @override
  Widget build(BuildContext context) {

    final Gradient _gradient = LinearGradient(
      colors: [Colors.pink, Colors.white],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );


    Widget body;



    var section;

    switch (section)
    {
    /// This is for example a login page since the user not logged in
      case Section.Home:
        body = HomeScreen();
        break;

    /// Display the home section, simply by
      case Section.Profile:
        body = ProfileScreen();
        break;

      case Section.Setting:
        body = ProfileScreen();
        break;

      case Section.Signout:
        body = HomeScreen();
        break;
    }

    Widget bottomNavBar =
    SalomonBottomBar(

        currentIndex: currentIndex,
        onTap: (int index){
          setState(() { // ตัวset ค่า
            currentIndex = index; //ตัวเลือกหน้า เช่น ถ้า 1 ก็เท่ากับ 1
          });
        },
        items: [
          SalomonBottomBarItem(
              selectedColor: Colors.white,
              icon: Icon(Icons.home,size: 20.0 , color: Colors.red),
              title: Text('หน้าหลัก', style: TextStyle(fontSize: 15.0) )
          ),
          SalomonBottomBarItem(
              selectedColor: Colors.white,
              icon: Icon(Icons.album, size: 20.0 , color: Colors.red)
              , title: Text('เพลงและศิลปิน', style: TextStyle(fontSize: 15.0),)
          ),
          SalomonBottomBarItem(
              selectedColor: Colors.white,
              icon: Icon(Icons.search, size: 20.0 , color: Colors.red)
              , title: Text('ค้นหาเพลง', style: TextStyle(fontSize: 15.0),)
          ),
          SalomonBottomBarItem(
              selectedColor: Colors.white,
              icon: Icon(Icons.my_library_music_rounded, size: 20.0 , color: Colors.red)
              , title: Text('เพลย์ลิส', style: TextStyle(fontSize: 15.0),)
          ),





        ]);


    return Scaffold(

        backgroundColor: Colors.black,
        bottomNavigationBar: bottomNavBar,

        body: Stack(
          children: [

            Scaffold(


              body: pages[currentIndex],




              appBar: AppBar(
                backgroundColor: Colors.black54,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black),



                //leading: Icon(Icons.music_note_sharp,color: Colors.white,),



                  title: Center(
                  child: ShaderMask(
                    blendMode: BlendMode.modulate,
                    shaderCallback: (size) => _gradient.createShader(
                      Rect.fromLTWH(0, 0, size.width, size.height),
                    ),
                    child: Text(
                      '   Musicly',

                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 33,
                      ),
                    ),
                  ),
                ),

                actions: <Widget>[

                  MaterialButton(
                    padding: const EdgeInsets.all(0),
                    elevation: 0,
                    shape: CircleBorder(),
                    onPressed: () => Navigator.of(context).pushNamed('/add'),


                    child: CircleAvatar(

                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(avatarUrl!),
                      child: IconButton(
                        onPressed: () {
                          drawerkey.currentState?.openDrawer();
                        },
                        icon: SizedBox()
                      ),

                    ),


                  ),

                ],

                flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          colors: [
                            Colors.black87,
                            //Color(0xff83565A),
                            Colors.black45,
                          ]),
                    )

                ),

              ),


              key: drawerkey,
              drawer: section != Section.Home ? Drawer(

                backgroundColor: Colors.black87,


                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [

                    UserAccountsDrawerHeader(

                      currentAccountPicture: new CircleAvatar(
                        radius: 50.0,
                        backgroundColor: const Color(0xFF778899),
                        backgroundImage: NetworkImage(avatarUrl!,
                        ),

                      ),


                      accountName: Text(
                        username!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0,color: Colors.white),
                      ),
                      accountEmail: Text(
                        user_email!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0,color: Colors.white),
                      ),

                      decoration: BoxDecoration(
                         image: DecorationImage(
                           image: NetworkImage("https://i.redd.it/czz1p3esbi341.png",

                           ),
                         ),
                        color: Colors.black87,
                      ),


                    ),

                    SizedBox(height: 10,),

                    ListTile(
                      leading: Icon(Icons.home , color: Colors.white),
                      title: const Text('หน้าหลัก' , style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                      subtitle: Text("หน้าแอปพลิเคชั่น", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                      onTap: () {

                        Navigator.pop(context);
                      },
                    ),

                    SizedBox(height: 10,),

                    ListTile(
                      leading: Icon(Icons.account_circle , color: Colors.white),
                      title: const Text('ข้อมูล' , style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),

                      subtitle: Text("ข้อมูลผู้ใช้" , style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)) ,

                      onTap: () {
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (context) => new ProfileScreen())
                        );
                      },

                    ),

                    SizedBox(height: 10,),


                    //  if(user_email == "oalo1234@gmail.com")

             //     ListTile(
             //       leading: Icon(Icons.settings , color: Colors.white),
             //       title: const Text('การตั้งค่า' , style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
             //       subtitle: Text("ตั้งค่าการใช้งาน" , style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
             //       onTap: () {
             //         if(user_email == "oalo1234@gmail.com"){
             //           Navigator.pushReplacement(
             //               context,
             //               MaterialPageRoute(
             //                 builder: (context) => TestCode(),
             //               )
             //           );
             //
             //         }else{
             //           Navigator.pop(context);
             //         }
             //
             //       },
             //     ),

                    SizedBox(height: 180,),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ListTile(
                          leading: Icon(Icons.exit_to_app , color: Colors.white,),
                          title: const Text('ออกจากระบบ' , style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                          subtitle: Text("" , style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                          onTap: () {
                            auth.signOut().then((value) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(title: ''),
                                  )
                              );
                            },
                            );

                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )

                  ],


                ),


              ) : null,


            ),



          ],

        )




    );

  }
}


