import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playmusic/forgetpassword.dart';
import 'package:playmusic/home_screen.dart';
import 'package:playmusic/model/profile.dart';
import 'package:playmusic/music.dart';
import 'package:playmusic/register.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:playmusic/screen/mainscreen.dart';
import 'package:google_sign_in/google_sign_in.dart';


void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {



  final _keyForm  = GlobalKey<FormState> ();
  Profile profile = Profile(AutofillHints.email , AutofillHints.password , AutofillHints.username , AutofillHints.photo);


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
          image: 'assets/picture/google_logo.png',
          onPressed:  () async {

            await _googleSignIn.signIn();
            setState(() {

            });

          },
        ),
        _buildLogoButton(
          image: 'assets/picture/apple_logo.png',
          onPressed: () {},
        ),
        _buildLogoButton(
          image: 'assets/picture/facebook_logo.png',
          onPressed: () {},
        )
      ],
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
          'เข้าสู่ระบบ',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        onPressed: () {

          // Profile profile = Profile(AutofillHints.email , AutofillHints.password);
          _saveForm();
          // print("email = ${profile.email} password ${profile.password}");

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



  final _password = TextEditingController();
  final _email = TextEditingController();


  Future<void> _saveForm() async {

    if(_keyForm.currentState!.validate()){
      _keyForm.currentState!.save();
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: profile.email,
            password: profile.password
        ).then((value){
          _keyForm.currentState!.reset();
          Navigator.pushNamedAndRemoveUntil(context
              , '/home', (route) => false);

        });
      }
      on FirebaseAuthException catch(e){

        Fluttertoast.showToast(
            msg: e.message!,
            gravity: ToastGravity.TOP
        );
      }



      print("email = ${profile.email} password ${profile.password}  ");

    }

  }

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Widget build(BuildContext context) {

    GoogleSignInAccount? user = _googleSignIn.currentUser;

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
                                  'Sing in',
                                  style: TextStyle(
                                    fontFamily: 'PT-Sans',
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(
                                  height: 110,
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
                                    controller: _email,
                                    validator: (value) {
                                      if (value!.isEmpty) return 'โปรดใส่อีเมลล์ของคุณ';

                                      return null;
                                    },
                                    onSaved: (newValue) => profile.email = newValue!,

                                    decoration: new InputDecoration(
                                      //fillColor: Colors.orange, filled: true, พื้นหลัง
                                      hintText: 'อีเมลล์ของคุณ',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(Icons.mail, color: Colors.white),
                                    ),
                                  ),

                                  obscureText: false,

                                ),



                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    'Password',
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
                                    controller: _password,
                                    validator: (value) {
                                      if (value!.isEmpty) return 'โปรดใส่พาสเวิร์ดของคุณ';

                                      return null;
                                    },
                                    onSaved: (newValue) => profile.password = newValue!,

                                    obscureText: true,
                                    decoration: new InputDecoration(
                                      //fillColor: Colors.orange, filled: true, พื้นหลัง

                                      hintText: 'พาสเวิร์ดของคุณ',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                                    ),



                                  ), obscureText: true,




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
                                      Text("หากคุณยังไม่มีแอคเคาท์  ", style: TextStyle(
                                          color: Colors.white
                                      ),
                                      ),
                                      GestureDetector(
                                        child: Text(
                                          "สมัครได้เลย !",
                                          style: TextStyle(
                                              color: Colors.red
                                          ),
                                        ),
                                        onTap: () {
                                          // Write Tap Code Here.
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => RegisterScreen(title: ''),
                                              )
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),


                                const SizedBox(
                                  height: 10,
                                ),

                                _buildSocialButtons(),

                                const SizedBox(
                                  height: 5,
                                ),

                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("ลืมพาสเวิร์ค  ", style: TextStyle(
                                          color: Colors.white
                                      ),
                                      ),
                                      GestureDetector(
                                        child: Text(
                                          "คลิกเพื่อกู้คืน !",
                                          style: TextStyle(
                                              color: Colors.orange
                                          ),
                                        ),
                                        onTap: () {
                                          // Write Tap Code Here.
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ForgetPasswordScreen(title: '',),
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


