import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playmusic/forgetpassword.dart';
import 'package:playmusic/home_screen.dart';
import 'package:playmusic/login.dart';
import 'package:playmusic/model/profile.dart';
import 'package:playmusic/music.dart';
import 'package:playmusic/register.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:playmusic/screen/mainscreen.dart';


void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}


class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  final _keyForm  = GlobalKey<FormState> ();

  Profile profile = Profile(AutofillHints.email , AutofillHints.password , AutofillHints.username , AutofillHints.url);

  //final String _emailsend;

  bool isActive = true;
  bool? isChecked = false;


  Widget _buildTextField(
      {

        required bool obscureText,
        Widget? prefixedIcon,
        String? hintText, TextStyle? style,

      }
      )

  {return Material(
    color: Colors.transparent,
    elevation: 2,
    child: TextField(
      cursorColor: Colors.white,
      cursorWidth: 2,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        //fillColor: Color(0xFF5180ff),
        prefixIcon: prefixedIcon,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white54,
          fontWeight: FontWeight.bold,
          fontFamily: 'PTSans',
        ),
      ),
    ),
  );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLogoButton(
          image: 'assets/images/google_logo.png',
          onPressed: () {},
        ),
        _buildLogoButton(
          image: 'assets/images/apple_logo.png',
          onPressed: () {},
        ),
        _buildLogoButton(
          image: 'assets/images/facebook_logo.png',
          onPressed: () {},
        )
      ],
    );
  }

  Widget tabs() {
    return DefaultTabController(
      length: 2,
      child: TabBar(

        tabs: [
          Tab(
            child: Text(
                "Sign in"
            ),

          ),

          Tab(
            child: Text(
                "Register"
            ),
          ),
        ],
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
      ),

    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.white,
          ),
          elevation: MaterialStateProperty.all(6),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
        child: const Text(
          'ส่งคำขอแก้ไขรหัสผ่าน',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        onPressed: () {

          FirebaseAuth.instance.sendPasswordResetEmail(email: _email.toString());



        },

      ),
    );
  }

  Widget _buildLogoButton({
    required String image,
    required VoidCallback onPressed,
  })

  {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: onPressed,
      child: SizedBox(
        height: 30,
        child: Image.asset(image),
      ),
    );
  }



  late  String _email;


  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {


    //Profile profile = Profile(AutofillHints.email , AutofillHints.password);
    return FutureBuilder(

        future: firebase,
        builder: (context,snapshot) {

          if(snapshot.hasError){
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error.toString()}"),
              ),
            );
          }

          if(snapshot.connectionState == ConnectionState.done){

            return SafeArea(
              child: Scaffold(
                body: Container(

                    child: Form(
                      key: _keyForm ,
                      child: Container(

                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/picture/logintheme.jpeg"),
                              fit: BoxFit.cover),
                        ),

                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                            ).copyWith(top: 60),
                            child: Column(
                              children: [
                                const Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    fontFamily: 'PT-Sans',
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),


                                const SizedBox(
                                  height: 15,
                                ),

                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    'Email',
                                    style: TextStyle(
                                      fontFamily: 'PT-Sans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 5,
                                ),


                                _buildTextField(
                                  prefixedIcon: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: new InputDecoration(
                                      //fillColor: Colors.orange, filled: true, พื้นหลัง
                                      hintText: 'อีเมลล์ของคุณ',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(Icons.mail, color: Colors.white),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _email = value.trim();
                                      });
                                    },
                                  ),

                                  obscureText: false,

                                ),


                                const SizedBox(
                                  height: 10,
                                ),

                                _buildLoginButton(),


                                const SizedBox(
                                  height: 10,
                                ),

                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("กลับไปหน้าล็อคอิน  ", style: TextStyle(
                                          color: Colors.white
                                      ),
                                      ),
                                      GestureDetector(
                                        child: Text(
                                          "คลิกเพื่อกลับ !",
                                          style: TextStyle(
                                              color: Colors.black
                                          ),
                                        ),
                                        onTap: () {
                                          // Write Tap Code Here.
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => LoginScreen(title: ''),
                                              )
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),



                      ),


                    )


                ),
              ),
            );
          }

          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );

        }
    );






  }



}

