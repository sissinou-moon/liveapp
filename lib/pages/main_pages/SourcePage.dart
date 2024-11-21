import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:launcher/components/tools.dart';
import 'package:launcher/main.dart';
import 'package:launcher/pages/main_pages/ChatPage.dart';
import 'package:launcher/pages/main_pages/LiveSessions.dart';
import 'package:launcher/pages/main_pages/NewsPage.dart';
import 'package:launcher/pages/main_pages/ProfilePage.dart';
import 'package:launcher/pages/main_pages/SearchPage.dart';
import 'package:launcher/providers/animateNavBarProvider.dart';
import 'package:provider/provider.dart';

class SourcePage extends StatefulWidget {
  final bool overlay;
  SourcePage({super.key, required this.overlay});

  @override
  State<SourcePage> createState() => SourcePageState();
}

class SourcePageState extends State<SourcePage> with TickerProviderStateMixin, WidgetsBindingObserver  {

  late AnimationController animateController;

  int index = 1;

  bool showNavBar = true;

  void shownavBar() {
    if(showNavBar) {
      animateController.forward();
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          showNavBar = false;
        });
      });
    }else {
      setState(() {
        showNavBar = true;
      });
      animateController.reverse();
    }
  }

  Future<void> setUserStatus(String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'status': status});
    } catch (e) {
      print("Error updating user status: $e");
    }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setUserStatus('Online');
    WidgetsBinding.instance.addObserver(this);

    animateController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this
    );


    Provider.of<AnimationProvider>(context, listen: false)
        .initializeController(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    setUserStatus('Offline');
    WidgetsBinding.instance.removeObserver(this);

    animateController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.detached) {
      setUserStatus("Offline"); // User leaves the app
    } else if (state == AppLifecycleState.resumed) {
      setUserStatus("Online"); // User returns to the app
    }
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width; 

    final animationProvider = Provider.of<AnimationProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          LiveSessions(),
          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(
              color: Colors.black.withOpacity(0.1), // Transparent layer
            ),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: Container(
              height: height*0.9,
              width: width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(height*0.025),
              ),
              child: index == 0 ? NewsPage() : index == 1 ? ChatPage(sourcePage: SourcePageState(),) : index == 2 ? SearchPage() : index == 3 ? Container() : ProfilePage(overlay: widget.overlay,),
            ),
          ),
          if(animationProvider.show) Animate(
            controller: animationProvider.animationController,
            autoPlay: false,
            effects: [
              SlideEffect(
                begin: Offset(0, 0),
                end: Offset(0, 1),
              ),
              FadeEffect(
                begin: 1,
                end: 0
              ),
            ],
            child: Align(
              alignment: Alignment(0, 1),
              child: GestureDetector(
                onTap: () {
                  //FirebaseAuth.instance.signOut();
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) {return FirstPage();}));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: height*0.08,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 17,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      index != 0 ? Container(
                        height: height*0.55,
                        width: height*0.055,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 0;
                            });
                          },
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/homefade.png',height: height*0.035,width: height*0.035,),
                            ],
                          )),
                      ) : Container(
                        height: height*0.55,
                        width: height*0.055,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              HexColor('1726C5'),
                              HexColor('4147FA'),
                            ]
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/home.png',height: height*0.035,width: height*0.035,),
                          ],
                        ),
                      ),
                      index != 1 ? Container(
                        height: height*0.55,
                        width: height*0.055,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 1;
                            });
                          },
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/chatfade.png',height: height*0.035,width: height*0.035,),
                            ],
                          )),
                      ) : Container(
                        alignment: Alignment.center,
                        height: height*0.55,
                        width: height*0.055,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              HexColor('1726C5'),
                              HexColor('4147FA'),
                            ]
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/chat.png',height: height*0.035,width: height*0.035,),
                          ],
                        ),
                      ),
                      index != 2 ? Container(
                        height: height*0.55,
                        width: height*0.055,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 2;
                            });
                          },
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/usersfade.png',height: height*0.037,width: height*0.037,),
                            ],
                          )),
                      ) : Container(
                        height: height*0.55,
                        width: height*0.055,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              HexColor('1726C5'),
                              HexColor('4147FA'),
                            ]
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/users.png',height: height*0.035,width: height*0.035,),
                          ],
                        ),
                      ),
                      index != 3 ? Container(
                        height: height*0.55,
                        width: height*0.055,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 3;
                            });
                          },child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/cartfade.png',height: height*0.037,width: height*0.037,),
                            ],
                          )),
                      ) : Container(
                        height: height*0.55,
                        width: height*0.055,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              HexColor('1726C5'),
                              HexColor('4147FA'),
                            ]
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/cart.png',height: height*0.035,width: height*0.035,),
                          ],
                        ),
                      ),
                      index != 4 ? Container(
                        height: height*0.55,
                        width: height*0.055,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 4;
                            });
                          },
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/profilesfade.png',height: height*0.037,width: height*0.037,),
                            ],
                          )),
                      ) : Container(
                        height: height*0.55,
                        width: height*0.055,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              HexColor('1726C5'),
                              HexColor('4147FA'),
                            ]
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/profiles.png',height: height*0.035,width: height*0.035,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}