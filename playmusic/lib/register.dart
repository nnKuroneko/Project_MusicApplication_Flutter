import 'package:flutter/material.dart';
import 'package:playmusic/home_screen.dart';
import 'package:playmusic/model/register.dart';


class RegisterScreen extends StatefulWidget {

  const RegisterScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _keyForm  = GlobalKey<FormState> ();
  Register register = Register(
      AutofillHints.email ,
      AutofillHints.password ,
      AutofillHints.password );


  bool isActive = true;
  bool? isChecked = false;

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
          'สมัครสมาชิก',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onPressed: () {

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
  final _cfpassword = TextEditingController();


  void _saveForm(){

    if(_keyForm.currentState!.validate()){

      _keyForm.currentState!.save();
      _keyForm.currentState!.reset();


      print("email = ${register.email} password ${register.password} cfpassword ${register.cfpassword} ");

    }

  }
  

  @override
  Widget build(BuildContext context) {
    
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
                  tabs(),
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
                    ), obscureText: true,



                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Comfirm Password',
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
                      controller: _cfpassword,
                      validator: (value) {
                        if (value!.isEmpty) return 'โปรดใส่พาสเวิร์ดของคุณอีกครั้ง';

                        return null;
                      },
                      onSaved: (newValue) => register.cfpassword = newValue!,

                      obscureText: true,
                      decoration: new InputDecoration(
                        //fillColor: Colors.orange, filled: true, พื้นหลัง
                        hintText: 'ยืนยันพาสเวิร์ดของคุณ',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                      ),
                    ), obscureText: true,



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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(title: ''),
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

}
