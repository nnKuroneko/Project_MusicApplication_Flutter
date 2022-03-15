import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:playmusic/home_screen.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:playmusic/model/profile.dart';



class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final auth = FirebaseAuth.instance;
  //final auth = FirebaseAuth.instance;

  final user_email = FirebaseAuth.instance.currentUser!.email;
  final namepictureuid = FirebaseAuth.instance.currentUser!.uid;
  final username = FirebaseAuth.instance.currentUser!.displayName;
  //final avatarUrl = FirebaseAuth.instance.currentUser!.photoURL;


  late Profile currentUser;


  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image ;
      print('Image Path $_image');
    });
  }



  Future uploadPic(BuildContext context) async{
    FirebaseStorage storage = FirebaseStorage.instance;
    String fileName = basename("images/Profile_${namepictureuid}");
    Reference ref = storage.ref().child('Profile/$fileName');
    UploadTask uploadTask = ref.putFile(File(_image!.path ));

    TaskSnapshot taskSnapshot =await uploadTask.whenComplete(() =>
        setState(() {
          print("Profile Picture uploaded");
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
        }
        ),
    );
   // Uri downloadUri = taskSnapshot.getMetadata().getDownloadUrl();

    final avatarUrl = await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    print('Url = $avatarUrl');

    return avatarUrl;

  }









  @override
  Widget build(BuildContext context) {






    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('ข้อมูลส่วนตัว'),
      ),
      body: Builder(

        builder: (context) =>  Container(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child:
                      SizedBox(
                       width: 180.0,
                       height: 180.0,
                       child: (_image!=null)?
                       Container(
                         decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           image: DecorationImage(
                               image: FileImage(File(_image!.path)),//Selected Image
                               fit: BoxFit.fill),
                         ),
                       ) :
                       Image.network(

                         "https://th.bing.com/th/id/R.699638bb6587498159882d713b113bd1?rik=FHlvtdFSitSBwg&pid=ImgRaw&r=0",
                         fit: BoxFit.fill,
                       ),
                     ),



                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.camera,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        getImage();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                margin: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Username',
                        style:
                        TextStyle(color: Colors.white, fontSize: 18.0)),
                    SizedBox(width: 20.0),
                    Text((username!),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                margin: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('uid',
                        style:
                        TextStyle(color: Colors.white, fontSize: 18.0)),
                    SizedBox(width: 20.0),
                    Text((namepictureuid),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                ],
              ),
              Container(
                margin: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Email',
                        style:
                        TextStyle(color: Colors.white, fontSize: 18.0)),
                    SizedBox(width: 20.0),
                    Text((user_email!),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    elevation: 4.0,
                    splashColor: Colors.white,
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.white,
                    onPressed: () {
                      uploadPic(context);
                     // FirebaseAuth.instance.currentUser!.updateProfile(photoURL: _image!.path);
                    },

                    elevation: 4.0,
                    splashColor: Colors.white,
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );


  }
}

