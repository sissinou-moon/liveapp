import 'package:flutter/material.dart';
import 'package:launcher/components/tools.dart';
import 'package:launcher/pages/SuccessfullyChangedPasswordPage.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

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
                  child: MyTitle('Changez votre mot de passe',height*0.035, FontWeight.w600, Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: height*0.01),
                  child: subParagraph('veuillez entrer votre nouveau mot de passe.',height*0.015, Colors.white.withOpacity(0.5)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height*0.035,bottom: height*0.01),
                  child: TextField(
                    controller: _password,
                    style: TextStyle(color: Colors.white, fontSize: height*0.021,fontFamily: 'bold'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: LogTextField(height,width, 'Mot de passe'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height*0.035,bottom: height*0.01),
                  child: TextField(
                    controller: _confirmPassword,
                    style: TextStyle(color: Colors.white, fontSize: height*0.021,fontFamily: 'bold'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: LogTextField(height,width, 'Confirmer votre mot de passe'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if(_password.text == _confirmPassword.text) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {return SuccessfullyChangePasswordPage();}));
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: height*0.1,bottom: height*0.055),
                    child: OffButton(height*0.065,width,'Confirmer',height*0.019),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}