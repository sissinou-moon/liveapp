import 'package:flutter/material.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:launcher/components/tools.dart';
import 'package:launcher/pages/ChangePasswordPage.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {


  TextEditingController _email = TextEditingController();
  TextEditingController _phonenumber = TextEditingController();
  TextEditingController _code = TextEditingController();

  int index = 0;
  
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
                  child: MyTitle('Connexion',height*0.035, FontWeight.w600, Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height*0.0),
                  child: subParagraph('Mot de passe oublié',height*0.035, Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height*0.025,bottom: height*0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 0;
                          });
                        },
                        child: index == 0 ? subButton(height*0.055, width*0.43, 'Numéro de Portable', height*0.015) : OffButton(height*0.055, width*0.43, 'Numéro de Portable', height*0.015)
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 1;
                          });
                        },
                        child: index == 1 ? subButton(height*0.055, width*0.43, 'E-mail', height*0.015) : OffButton(height*0.055, width*0.43, 'E-mail', height*0.015)
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: height*0.01),
                  child: subParagraph('veuillez entrer votre numéro de mobile pour obtenir OTP.',height*0.015, Colors.white.withOpacity(0.5)),
                ),
                index == 0 ? Padding(
                  padding: EdgeInsets.only(top: height*0.035,bottom: height*0.01),
                  child: TextField(
                    controller: _phonenumber,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white, fontSize: height*0.021,fontFamily: 'bold'),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      hintText: 'Numéro de mobile',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                      border: GradientOutlineInputBorder(
                        borderRadius: BorderRadius.circular(height*0.011),
                        gradient: LinearGradient(colors: [
                          Colors.white.withOpacity(0.27),
                          Colors.white.withOpacity(0.21),
                          Colors.white.withOpacity(0.07),
                        ], begin: Alignment.topCenter, end: Alignment.bottomLeft),
                        width: 2,
                      ),
                      prefixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              subParagraph('  US +1 ', height*0.019, Colors.white),
                              SizedBox(width: width*0.02,),
                              Container(
                                height: height*0.03,
                                width: 2,
                                color: Colors.white,
                              ),
                              SizedBox(width: width*0.02,)
                            ],
                          ),
                        ],
                      )
                    ),
                  ),
                ) : Padding(
                  padding: EdgeInsets.only(top: height*0.035,bottom: height*0.01),
                  child: TextField(
                    controller: _email,
                    style: TextStyle(color: Colors.white, fontSize: height*0.021,fontFamily: 'bold'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: LogTextField(height,width, 'Addresse Email'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if(index == 0) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
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
                                      child: MyTitle('Vérification du code',height*0.035, FontWeight.w600, Colors.white),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: height*0.01),
                                      child: SizedBox(
                                        width: width*0.7,
                                        child: subParagraph('Nous vous avons envoyé un code de vérification au ${_phonenumber.text} .Renseignez Nous vous avons envoyé un code de vérification',height*0.015, Colors.white.withOpacity(0.5))
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: height*0.035,bottom: height*0.01),
                                      child: TextField(
                                        controller: _code,
                                        style: TextStyle(color: Colors.white, fontSize: height*0.021,fontFamily: 'bold'),
                                        keyboardType: TextInputType.number,
                                        decoration: LogTextField(height,width, 'Entrer le code'),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: Padding(
                                            padding: EdgeInsets.only(bottom: height*0.01),
                                            child: subParagraph('Recevoir un nouveau code',height*0.015, Colors.white.withOpacity(0.5)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {return ChangePasswordPage();}));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(top: height*0.07,bottom: height*0.055),
                                        child: OffButton(height*0.065,width,'Confirmer',height*0.019),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }));
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: height*0.1,bottom: height*0.055),
                    child: OffButton(height*0.065,width,'Envoyer le code de vérification',height*0.019),
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