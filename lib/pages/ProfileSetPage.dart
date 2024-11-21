import 'package:cherry_toast/cherry_toast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:launcher/components/tools.dart';
import 'package:launcher/pages/main_pages/SourcePage.dart';

class ProfileSetPage extends StatefulWidget {
  const ProfileSetPage({super.key});

  @override
  State<ProfileSetPage> createState() => _ProfileSetPageState();
}

class _ProfileSetPageState extends State<ProfileSetPage> {

  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController schoolTrainner = TextEditingController();
  TextEditingController _interested = TextEditingController();
  TextEditingController _hobbies = TextEditingController();
  String avatarPath = '';
  String votrePays = 'Afghanistan';
  List<String> pays = [
    'Afghanistan',
    'United Arab Emirates',
    'Andorra',
    'Argentina',
    'Australia',
  ];

  bool valid = false;

  final key = GlobalKey<FormState>();

  List education = [];
  List interested = [];
  List hobbies = [];

  DateTime educationDate = DateTime.now();
  

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
                    child: MyTitle('Création du profil',height*0.035, FontWeight.w600, Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: height*0.01),
                    child: subParagraph('Ajoutez une photo de profil et un nom pour vous fondre dans vos vibrations !',height*0.015, Colors.white.withOpacity(0.5)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: height*0.015,bottom: height*0.01),
                        child: Container(
                          alignment: Alignment.center,
                          height: height*0.15,
                          width: height*0.15,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.white.withOpacity(0.25).withOpacity(0.12),
                              Colors.white.withOpacity(0.33).withOpacity(0.15),
                            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                            border: GradientBoxBorder(
                              gradient: LinearGradient(colors: [
                                Colors.white.withOpacity(0.31),
                                Colors.white.withOpacity(0.29),
                                Colors.transparent
                              ], begin: Alignment.topCenter, end: Alignment.bottomLeft),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(height)
                          ),
                          child: avatarPath.isEmpty ? Image.asset('assets/icons/AddAvatar.png',height: height*0.05,width: height*0.05,) : ClipRRect(borderRadius: BorderRadius.circular(height),child: Image.asset(avatarPath,fit: BoxFit.contain,height: height*0.17,width: height*0.17,)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: height*0.015,bottom: height*0.01),
                        child: Container(
                          height: height*0.065,
                          width: width*0.6,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.white.withOpacity(0.25).withOpacity(0.12),
                              Colors.white.withOpacity(0.33).withOpacity(0.15),
                            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                            border: GradientBoxBorder(
                              gradient: LinearGradient(colors: [
                                Colors.white.withOpacity(0.31),
                                Colors.white.withOpacity(0.29),
                                Colors.transparent
                              ], begin: Alignment.topCenter, end: Alignment.bottomLeft),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(height)
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return Scaffold(
                                  body: Container(
                                    padding: EdgeInsets.only(top: height*0.05),
                                    height: height,
                                    width: width,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage('assets/images/Lunche.png'),fit: BoxFit.cover),
                                    ),
                                    child: Padding(
                                      padding: mainPadding(width, height),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                            child: MyTitle("Choix d'avatar",height*0.035, FontWeight.w600, Colors.white),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: height*0.015),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    changeAvatar('assets/icons/AV1.png');
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    height: height*0.09,
                                                    child: ClipRRect(borderRadius: BorderRadius.circular(height),child: Image.asset('assets/icons/AV1.png',fit: BoxFit.contain,))
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    changeAvatar('assets/icons/AV2.png');
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    height: height*0.09,
                                                    child: ClipRRect(borderRadius: BorderRadius.circular(height),child: Image.asset('assets/icons/AV2.png',fit: BoxFit.contain,))
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    changeAvatar('assets/icons/AV3.png');
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    height: height*0.09,
                                                    child: ClipRRect(borderRadius: BorderRadius.circular(height),child: Image.asset('assets/icons/AV3.png',fit: BoxFit.contain,))
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: height*0.01),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    changeAvatar('assets/icons/AV4.png');
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    height: height*0.09,
                                                    child: ClipRRect(borderRadius: BorderRadius.circular(height),child: Image.asset('assets/icons/AV4.png',fit: BoxFit.contain,))
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    changeAvatar('assets/icons/AV5.png');
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    height: height*0.09,
                                                    child: ClipRRect(borderRadius: BorderRadius.circular(height),child: Image.asset('assets/icons/AV5.png',fit: BoxFit.contain,))
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    changeAvatar('assets/icons/AV6.png');
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    height: height*0.09,
                                                    child: ClipRRect(borderRadius: BorderRadius.circular(height),child: Image.asset('assets/icons/AV6.png',fit: BoxFit.contain,))
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: height*0.01),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    changeAvatar('assets/icons/AV7.png');
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    height: height*0.09,
                                                    child: ClipRRect(borderRadius: BorderRadius.circular(height),child: Image.asset('assets/icons/AV7.png',fit: BoxFit.contain,))
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    changeAvatar('assets/icons/AV8.png');
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    height: height*0.09,
                                                    child: ClipRRect(borderRadius: BorderRadius.circular(height),child: Image.asset('assets/icons/AV8.png',fit: BoxFit.contain,))
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    changeAvatar('assets/icons/AV9.png');
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    height: height*0.09,
                                                    child: ClipRRect(borderRadius: BorderRadius.circular(height),child: Image.asset('assets/icons/AV9.png',fit: BoxFit.contain,))
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: height*0.01),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    changeAvatar('assets/icons/AV10.png');
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    height: height*0.09,
                                                    child: ClipRRect(borderRadius: BorderRadius.circular(height),child: Image.asset('assets/icons/AV10.png',fit: BoxFit.contain,))
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    changeAvatar('assets/icons/AV2.png');
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    height: height*0.09,
                                                    child: ClipRRect(borderRadius: BorderRadius.circular(height),child: Image.asset('assets/icons/AV2.png',fit: BoxFit.contain,))
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    changeAvatar('assets/icons/AV7.png');
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    height: height*0.09,
                                                    child: ClipRRect(borderRadius: BorderRadius.circular(height),child: Image.asset('assets/icons/AV7.png',fit: BoxFit.contain,))
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(top: height*0.05,bottom: height*0.055),
                                              child: SubmitButton(height*0.065,width, 'Sauvgarder',height*0.019),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/icons/user-circle-add.png',height: height*0.025,width: height*0.025,),
                                subParagraph('Ou bien choisir un avatar', height*0.017, Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height*0.013,bottom: height*0.01),
                    child: TextFormField(
                      controller: name,
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'this field must be filled';
                        }else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        if(name.text.isNotEmpty && username.text.isNotEmpty && bio.text.isNotEmpty) {
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
                      decoration: LogTextField(height,width, 'Nom profil'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height*0.013,bottom: height*0.01),
                    child: TextFormField(
                      controller: username,
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'this field must be filled';
                        }else if(value.length < 3) {
                          return 'username must be more than 3 words';
                        }else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        if(name.text.isNotEmpty && username.text.isNotEmpty && bio.text.isNotEmpty) {
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
                      decoration: LogTextField(height,width, "Nom d'utilisateur"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height*0.013,bottom: height*0.01),
                    child: TextFormField(
                      controller: bio,
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'this field must be filled, write anything';
                        }else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        if(name.text.isNotEmpty && username.text.isNotEmpty && bio.text.isNotEmpty) {
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
                      decoration: LogTextField(height,width, "Bio"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height*0.013,bottom: height*0.01),
                    child: Container(
                      padding: EdgeInsets.only(right: width*0.05),
                      height: height*0.065,
                      width: width,
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
                            child: Padding(
                              padding: EdgeInsets.only(top: height*0.01),
                              child: Row(
                                children: [
                                  ClipRRect(borderRadius: BorderRadius.circular(0),child: Image.asset(pys == 'Afghanistan' ? 'assets/images/AF.png' : pys == 'United Arab Emirates' ? 'assets/images/AE.png' : pys == 'Andorra' ? 'assets/images/AD.png' : pys == 'Argentina' ? 'assets/images/AR.png' : 'assets/images/AU.png',height: height*0.031,width: height*0.031,)),
                                  SizedBox(width: width*0.05,),
                                  subTitle(pys, height*0.019, Colors.white),
                                ],
                              )
                            )
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
                            icon: Icon(Icons.arrow_downward_outlined,size: height*0.02,color: Colors.white,)
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height*0.013,bottom: height*0.01),
                    child: TextField(
                      controller: city,
                      onChanged: (value) {
                        if(name.text.isNotEmpty && username.text.isNotEmpty) {
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
                      decoration: LogTextField(height,width, 'Your city'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height*0.013,bottom: height*0.01),
                    child: Row(
                      children: [
                        SizedBox(
                          width: width*0.6,
                          child: TextField(
                            controller: schoolTrainner,
                            onChanged: (value) {
                              if(name.text.isNotEmpty && username.text.isNotEmpty && bio.text.isNotEmpty) {
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
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              hintText: 'Des formations',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  if(schoolTrainner.text.isNotEmpty) {
                                    setState(() {
                                      education.add({
                                        'date': DateFormat('dd/MM/yyyy').format(educationDate).toString(),
                                        'name': schoolTrainner.text,
                                      });
                                      schoolTrainner.clear();
                                    });
                                  }else {
                                    CherryToast.info(description: Paragraph('entrez les formation que vous avez fait', height*0.021, Colors.black, 1),).show(context);
                                  }
                                },
                                child: Icon(Icons.add,size: height*0.023,color: Colors.white,)
                              ),
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
                        Padding(
                          padding: EdgeInsets.only(left: width*0.05),
                          child: GestureDetector(
                            onTap: () {
                              showDatePicker(
                                context: context, 
                                initialDate: educationDate,
                                firstDate: DateTime(1950), 
                                lastDate: DateTime(2030)
                              ).then((value) {
                                setState(() {
                                  educationDate = value!;
                                });
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: height*0.065,
                              width: width*0.25,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(height*0.01),
                                border: GradientBoxBorder(
                                  gradient: LinearGradient(colors: [
                                    Colors.white.withOpacity(0.31),
                                    Colors.white.withOpacity(0.29),
                                    Colors.transparent
                                  ], begin: Alignment.topCenter, end: Alignment.bottomLeft),
                                  width: 2,
                                ),
                              ),
                              child: Paragraph(DateFormat('dd/MM/yyyy').format(educationDate).toString(), height*0.015, Colors.white, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(education.length != 0) SizedBox(
                    height: height*0.035,
                    width: width,
                    child: ListView.builder(
                      itemCount: education.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: width*0.03),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                education.removeAt(index);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: height*0.035,
                              width: education[index]['name'].toString().length*8,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(height*0.007),
                              ),
                              child: subParagraph(education[index]['name'], height*0.015, Colors.white),
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height*0.013,bottom: height*0.01),
                    child: TextField(
                      controller: _interested,
                      onChanged: (value) {
                        if(name.text.isNotEmpty && username.text.isNotEmpty && bio.text.isNotEmpty) {
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
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        hintText: 'Intéressé avec...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            if(_interested.text.isNotEmpty) {
                              setState(() {
                                interested.add(_interested.text);
                                _interested.clear();
                              });
                            }else {
                              CherryToast.info(description: Paragraph('quels sujets vous intéressent', height*0.021, Colors.black, 5),).show(context);
                            }
                          },
                          child: Icon(Icons.add,size: height*0.023,color: Colors.white,)
                        ),
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
                  if(interested.isNotEmpty) SizedBox(
                    height: height*0.035,
                    width: width,
                    child: ListView.builder(
                      itemCount: interested.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: width*0.03),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                interested.removeAt(index);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: height*0.035,
                              width: interested[index].toString().length*8,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(height*0.007),
                              ),
                              child: subParagraph(interested[index], height*0.015, Colors.white),
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height*0.013,bottom: height*0.01),
                    child: TextField(
                      controller: _hobbies,
                      onChanged: (value) {
                        if(name.text.isNotEmpty && username.text.isNotEmpty && bio.text.isNotEmpty) {
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
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        hintText: 'Vos loisires',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            if(_hobbies.text.isNotEmpty) {
                              setState(() {
                                hobbies.add(_hobbies.text);
                                _hobbies.clear();
                              });
                            }else {
                              CherryToast.info(description: Paragraph("Les choses que t'aime faire!", height*0.021, Colors.black, 5),).show(context);
                            }
                          },
                          child: Icon(Icons.add,size: height*0.023,color: Colors.white,)
                        ),
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
                  if(hobbies.isNotEmpty) SizedBox(
                    height: height*0.035,
                    width: width,
                    child: ListView.builder(
                      itemCount: hobbies.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: width*0.03),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                hobbies.removeAt(index);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: height*0.035,
                              width: hobbies[index].toString().length*8,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(height*0.007),
                              ),
                              child: subParagraph(hobbies[index], height*0.015, Colors.white),
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if(key.currentState!.validate()) {
                        if(avatarPath == '') {
                          CherryToast.info(description: Paragraph('Please, choose an avatar', 17, Colors.black, 1),).show(context);
                        }else if(interested.isEmpty || hobbies.isEmpty || education.isEmpty) {
                          CherryToast.info(description: Paragraph('Please, evrey field in this page must be filled', 17, Colors.black, 1),).show(context);
                        } else {
                          saveUserProfile();
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: height*0.05,bottom: height*0.055),
                      child: valid ? SubmitButton(height*0.065,width, 'Continuer',height*0.019) : OffButton(height*0.065,width, 'Continuer',height*0.019),
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

  void changeAvatar(String path) {
    setState(() {
      avatarPath = path;
    });
  }

  void saveUserProfile() async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).set({
        'name': name.text,
        'avatar': avatarPath,
        'username': username.text,
        'country': votrePays,
        'city': city.text.isEmpty ? '' : city.text,
        'collab': [],
        'education': education,
        'interested': interested,
        'hobbies': hobbies,
        'liveapps': [],
        'friends': [],
        'friendRequest': [],
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'email': FirebaseAuth.instance.currentUser!.email,
        'phonenumber': FirebaseAuth.instance.currentUser!.phoneNumber,
        'bio': bio.text,
      });
      FirebaseAuth.instance.currentUser!.updateProfile(
        displayName: username.text,
      );
      FirebaseAuth.instance.currentUser!.reload();
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(builder: (context){return SourcePage(overlay: true,);}));
    } catch (e) {
      CherryToast.warning(description: Paragraph(e.toString(), 17, Colors.black, 5),);
    }
  }
}