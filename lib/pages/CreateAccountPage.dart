import 'package:cherry_toast/cherry_toast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:launcher/components/tools.dart';
import 'package:launcher/pages/LoginPage.dart';
import 'package:launcher/pages/ProfileSetPage.dart';
import 'package:launcher/pages/main_pages/SourcePage.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {


  TextEditingController _email = TextEditingController();
  TextEditingController _phonenumber = TextEditingController();
  TextEditingController _code = TextEditingController();
  TextEditingController _password = TextEditingController();

  int index = 0;

  final key = GlobalKey<FormState>();

  bool valid = false; 

  String votrePays = '+213';
  List<String> pays = [
    '+213',
    '+216',
    '+1',
    '+33',
  ];

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
                    child: MyTitle('Créer un compte',height*0.035, FontWeight.w600, Colors.white),
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
                              valid = false;
                            });
                          },
                          child: index == 0 ? subButton(height*0.055, width*0.43, 'Numéro de Portable', height*0.015) : OffButton(height*0.055, width*0.43, 'Numéro de Portable', height*0.015)
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 1;
                              valid = false;
                            });
                          },
                          child: index == 1 ? subButton(height*0.055, width*0.43, 'E-mail', height*0.015) : OffButton(height*0.055, width*0.43, 'E-mail', height*0.015)
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: height*0.01),
                    child: subParagraph('Créez un nouveau compte si vous nen avez pas.',height*0.015, Colors.white.withOpacity(0.5)),
                  ),
                  index == 0 ? Padding(
                    padding: EdgeInsets.only(top: height*0.035,bottom: height*0.01),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: width*0.02),
                          child: Container(
                            padding: EdgeInsets.only(right: width*0.01),
                            height: height*0.065,
                            width: width*0.23,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(height*0.011),
                              border: GradientBoxBorder(
                                gradient: LinearGradient(colors: [
                                  Colors.white.withOpacity(0.27),
                                  Colors.white.withOpacity(0.21),
                                  Colors.white.withOpacity(0.07),
                                ], begin: Alignment.topCenter, end: Alignment.bottomLeft),
                                width: 2,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                items: pays.map((String pys) => DropdownMenuItem<String>(
                                  value: pys,
                                  child: Paragraph(pys, height*0.015, Colors.white, 1)
                                )).toList(),
                                value: votrePays,
                                onChanged: (String? value) {
                                  setState(() {
                                    votrePays = value!;
                                  });
                                },
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(height*0.023),
                                  )
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Icon(Icons.arrow_downward_outlined,size: height*0.013,color: Colors.white,)
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _phonenumber,
                            validator: (value) {
                              if(RegExp(r'[a-zA-Z]').hasMatch(value!) || value.isEmpty) {
                                return 'numéro portable incorrect';
                              }else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              if(value.isNotEmpty && !RegExp(r'[a-zA-Z]').hasMatch(value)) {
                                setState(() {
                                  valid = true;
                                });
                              }else {
                                setState(() {
                                  valid = false;
                                });
                              }
                            },
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) : Padding(
                    padding: EdgeInsets.only(top: height*0.035,bottom: height*0.01),
                    child: TextFormField(
                      controller: _email,
                      validator: (value) {
                        if(value!.contains('@')) {
                          if(value.contains('.com') || value.contains('.fr')) {
                            return null;
                          } else {
                            return 'addresse email incorrect';
                          }
                        }else {
                          return 'addresse email incorrect';
                        }
                      },
                      onChanged: (value) {
                        if(value.isNotEmpty && _password.text.isNotEmpty) {
                          setState(() {
                            valid = true;
                          });
                        }else {
                          setState(() {
                            valid = false;
                          });
                        }
                      },
                      style: TextStyle(color: Colors.white, fontSize: height*0.021,fontFamily: 'bold'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: LogTextField(height,width, 'Addresse Email'),
                    ),
                  ),
                  if(index != 0) Padding(
                    padding: EdgeInsets.only(top: height*0.01,bottom: height*0.01),
                    child: TextFormField(
                      controller: _password,
                      validator: (value) {
                        if(value!.length < 7) {
                          return 'password must be more than 7 words';
                        }else if(RegExp(r'\d').hasMatch(value)) {
                          return null;
                        } else {
                          return 'password must contains atleast 1 number';
                        }
                      },
                      onChanged: (value) {
                        if(value.isNotEmpty && _email.text.isNotEmpty) {
                          setState(() {
                            valid = true;
                          });
                        }else {
                          setState(() {
                            valid = false;
                          });
                        }
                      },
                      style: TextStyle(color: Colors.white, fontSize: height*0.021,fontFamily: 'bold'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: LogTextField(height,width, 'Mot De Passe'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (key.currentState!.validate()) {
                        if(index == 0) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return ConfirmCodePhoneNumberPage(height: height, width: width, phonenumber: '$votrePays${_phonenumber.text}');
                          }));
                        } else {
                          CreateAccountWithEmail();
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: height*0.1,bottom: height*0.055),
                      child: valid ? SubmitButton(height*0.065,width, index == 0 ? 'Envoyer le code de vérification' : 'Confirmer',height*0.019).animate().fade(duration: Duration(milliseconds: 300)) : OffButton(height*0.065,width, index == 0 ? 'Envoyer le code de vérification' : 'Confirmer',height*0.019),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void CreateAccountWithEmail() async {
    if(key.currentState!.validate()){
      try {
        final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email.text, password: _password.text);
        if(user != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context){return ProfileSetPage();}));
        }
      } catch (e) {
        CherryToast.warning(description: Paragraph(e.toString(), 15, Colors.black, 1),).show(context);
      }
    }
  }
}

class ConfirmCodePhoneNumberPage extends StatefulWidget {
  const ConfirmCodePhoneNumberPage({
    super.key,
    required this.height,
    required this.width,
    required this.phonenumber,
  });

  final double height;
  final double width;
  final String phonenumber;

  @override
  State<ConfirmCodePhoneNumberPage> createState() => _ConfirmCodePhoneNumberPageState();
}

class _ConfirmCodePhoneNumberPageState extends State<ConfirmCodePhoneNumberPage> {

  final TextEditingController _code = TextEditingController();
  String? _verificationId;

  @override
  void initState() {
    super.initState();

    _verifyPhoneNumber();
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: widget.height*0.05),
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/Lunche.png'),fit: BoxFit.cover)
        ),
        child: Padding(
          padding: mainPadding(widget.width, widget.height),
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
                    padding: EdgeInsets.only(top: widget.height*0.025, bottom: widget.height*0.035),
                    child: Icon(Icons.arrow_back_ios_new_outlined,size: widget.height*0.027,color: Colors.white,),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: widget.height*0.015),
                  child: MyTitle('Vérification du code',widget.height*0.035, FontWeight.w600, Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: widget.height*0.01),
                  child: SizedBox(
                    width: widget.width*0.7,
                    child: subParagraph('Nous vous avons envoyé un code de vérification au ${widget.phonenumber} .Renseignez Nous vous avons envoyé un code de vérification',widget.height*0.015, Colors.white.withOpacity(0.5))
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: widget.height*0.035,bottom: widget.height*0.01),
                  child: TextField(
                    controller: _code,
                    style: TextStyle(color: Colors.white, fontSize: widget.height*0.021,fontFamily: 'bold'),
                    keyboardType: TextInputType.number,
                    decoration: LogTextField(widget.height,widget.width, 'Entrer le code'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.only(bottom: widget.height*0.01),
                        child: subParagraph('Recevoir un nouveau code',widget.height*0.015, Colors.white.withOpacity(0.5)),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    _signInWithOtp();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: widget.height*0.07,bottom: widget.height*0.055),
                    child: OffButton(widget.height*0.065,widget.width,'Confirmer',widget.height*0.019),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // Request OTP
  Future<void> _verifyPhoneNumber() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: widget.phonenumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto sign-in with the received credential
        await auth.signInWithCredential(credential);
        print("Phone number automatically verified and user signed in");
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        print("OTP sent to phone number.");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("Code auto retrieval timeout.");
      },
    );
  }

  // Sign in with OTP
  Future<void> _signInWithOtp() async {
    if (_verificationId != null) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _code.text,
      );

      try {
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {return ProfileSetPage();}));
      } catch (e) {
        print("Failed to sign in: $e");
      }
    } else {
      print("Verification ID is null.");
    }
  }

}
