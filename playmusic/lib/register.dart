import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:playmusic/home_screen.dart';
import 'package:playmusic/login.dart';
import 'package:playmusic/model/register.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';



void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _keyForm  = GlobalKey<FormState> ();
  Register register = Register(AutofillHints.email ,AutofillHints.password ,AutofillHints.username , AutofillHints.url  );


  bool isActive = true;
  bool? isChecked = false;

  late String username;
  late String avatarUrl = "https://i1.sndcdn.com/avatars-000241167684-al6jq6-t500x500.jpg";


  Widget _buildTextField(
      {
        required bool obscureText,
        Widget? prefixedIcon,
        String? hintText,
      }
      )

  {
    return Material(
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
          'สมัครสมาชิก',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onPressed: () async {

          _saveForm();


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
  final _username = TextEditingController();
  final _avatarUrl = TextEditingController();


  Future<void> _saveForm() async {

    if(_keyForm.currentState!.validate())

      {

      _keyForm.currentState!.save();
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: register.email,
            password: register.password
        ).then((value) async {
          _keyForm.currentState!.reset();
          Fluttertoast.showToast(
              msg: "สร้างปัญชีผู้ใช้เรียบร้อยแล้ว",
              gravity: ToastGravity.TOP
          );
          await value.user?.updateProfile(photoURL: avatarUrl , displayName: username).then(
                  (value) =>
              Navigator.pushNamedAndRemoveUntil(context
              , '/auth', (route) => false)
             );
           }
        );
      }

      on FirebaseAuthException catch(e){
        print(e.code);
        //print(e.message);

        String message;
        if(e.code == 'email-already-in-use'){
          message = "มีอีเมลนี้ในระบบแล้วครับ โปรดใช้อีเมลอื่นแทน";
        }else if(e.code == 'weak-password'){
          message = "รหัสผ่านต้องมีความยาว 6 ตัวอักษรขึ้นไป";
        }else if(e.code == 'invalid-email'){
          message = "อีเมลล์ของคุณไม่ถุกต้อง โปรดลองใหม่";
        }else {
          message = e.message!;
        }

        Fluttertoast.showToast(

          msg: message,
          gravity: ToastGravity.TOP
        );

    }


      print("email = ${register.email} password ${register.password} username ${register.username} ");

    }

  }

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {

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
                              image: AssetImage("assets/picture/registertheme.jpeg"),
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
                                  'สมัครสมาชิก',
                                  style: TextStyle(
                                    fontFamily: 'PT-Sans',
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),




                                const SizedBox(
                                  height: 20,
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
                                  height: 15,
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
                                    onSaved: (newValue) => register.email = newValue!,

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
                                  height: 15,
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
                                    onSaved: (newValue) => register.password = newValue!,

                                    obscureText: true,
                                    decoration: new InputDecoration(
                                      //fillColor: Colors.orange, filled: true, พื้นหลัง
                                      hintText: 'พาสเวิร์ดของคุณ',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                                    ),
                                  ), obscureText: false,

                                ),

                                const SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    'Username',
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
                                    onChanged: (value) => username = value.trim(),
                                    style: TextStyle(color: Colors.white),
                                    controller: _username,
                                    validator: (value) {
                                      if (value!.isEmpty) return 'โปรดใส่ยูสเซอร์เนมของคุณอีกครั้ง';

                                      return null;
                                    },
                                    onSaved: (newValue) => register.username = newValue!,


                                    obscureText: false,
                                    decoration: new InputDecoration(
                                      //fillColor: Colors.orange, filled: true, พื้นหลัง
                                      hintText: 'ใส่ยูสเซอร์เนมของคุณ',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(Icons.account_circle, color: Colors.white),
                                    ),
                                  ), obscureText: false,

                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                const SizedBox(
                                  height: 25,
                                ),
                                _buildLoginButton(),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("คุณมีแอคเคาท์แล้วใช่มั้ย  ", style: TextStyle(
                                          color: Colors.grey
                                      ),
                                      ),
                                      GestureDetector(
                                        child: Text(
                                          " เข้าสู่ระบบ เลยซิ!!!",
                                          style: TextStyle(
                                              color: Color(0xffF5591F)
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
