import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:launcher/components/tools.dart';
import 'package:launcher/pages/ForgetPasswordPage.dart';
import 'package:launcher/pages/main_pages/SourcePage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage>{

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool activated = false;
  bool showPassword = false;

  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width; 

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: height*0.05),
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/Lunche.png'),fit: BoxFit.cover)
        ),
        child: Padding(
          padding: mainPadding(width, height),
          child: SingleChildScrollView(
            child: Form(
              key: key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: height*0.025, bottom: height*0.035),
                      child: Icon(Icons.arrow_back_ios_new_outlined,size: height*0.027,color: Colors.white,),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height*0.015),
                    child: MyTitle('Connexion',height*0.035, FontWeight.w600, Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: height*0.01),
                    child: Paragraph('LivePulp',height*0.035, Colors.white, 1),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height*0.015,bottom: height*0.01),
                    child: TextFormField(
                      controller: _email,
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'please, enter your e-mail';
                        }else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        if(_email.text.isNotEmpty && _password.text.isNotEmpty) {
                          setState(() {
                            activated = true;
                          });
                        }else {
                          setState(() {
                            activated = false;
                          });
                        }
                      },
                      style: TextStyle(color: Colors.white, fontSize: height*0.021,fontFamily: 'bold'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: LogTextField(height,width, 'Addresse Email'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height*0.015,bottom: height*0.025),
                    child: TextFormField(
                      controller: _password,
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'please, enter your e-mail';
                        }else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        if(_email.text.isNotEmpty && _password.text.isNotEmpty) {
                          setState(() {
                            activated = true;
                          });
                        }else {
                          setState(() {
                            activated = false;
                          });
                        }
                      },
                      obscureText: showPassword,
                      style: TextStyle(color: Colors.white, fontSize: height*0.021,fontFamily: 'bold'),
                      decoration: PasswordTextField(height,width,() {setState(() {
                        showPassword = !showPassword;
                      });}),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if(key.currentState!.validate()) {
                        loginAgain();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: height*0.015,bottom: height*0.025),
                      child: !activated ? OffButton(height*0.065,width, 'Se Connecter', height*0.019) : SubmitButton(height*0.065, width, 'Se Connecter', height*0.019).animate().fade(duration: Duration(milliseconds: 300)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return ForgetPasswordPage();
                          }));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom: height*0.01),
                          child: subParagraph('Mot de passe oublié',height*0.015, Colors.white.withOpacity(0.5)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: height*0.25,bottom: height*0.055),
                        child: infoButton(height*0.065,width*0.8,'Comment fonctionne Livepulp',height*0.019),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginAgain() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.text, password: _password.text);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {return SourcePage(overlay: true,);}));
    } catch (e) {
      CherryToast.warning(description: Paragraph(e.toString(), 17, Colors.black, 4),).show(context);
    }
  }
}