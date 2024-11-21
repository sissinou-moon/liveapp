import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:launcher/components/tools.dart';
import 'package:launcher/pages/main_pages/ChatRoomPage.dart';
import 'package:launcher/pages/main_pages/ProfilePage.dart';
import 'package:launcher/pages/main_pages/SourcePage.dart';
import 'package:launcher/providers/animateNavBarProvider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ChatPage extends StatefulWidget {
  final SourcePageState sourcePage;
  ChatPage({super.key, required this.sourcePage});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin  {

  late AnimationController animateController;

  TextEditingController searchController = TextEditingController();

  final DatabaseReference contactsRef = FirebaseDatabase.instance.ref("contacts").child(FirebaseAuth.instance.currentUser!.uid);

  bool dispalyChatRoom = false;

  Map friendData = {};

  @override
  void initState() {
    super.initState();
    
    animateController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this
    );
  }

  @override
  void dispose() {
    super.dispose();

    animateController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width; 

    return ClipRRect(
      borderRadius: BorderRadius.circular(height*0.025),
      child: Stack(
        children: [
          Padding(
            padding: mainPadding(width, height),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height*0.02,),
                  MyTitle('Discussions', height*0.033, FontWeight.w500, Colors.black),
                  //Padding(
                  //  padding: EdgeInsets.only(top: height*0.02),
                  //  child: TextField(
                  //    controller: searchController,
                  //    decoration: InputDecoration(
                  //      hintText: 'Rechercher des discussions...',
                  //      hintStyle: TextStyle(
                  //        color: Colors.grey,
                  //        fontFamily: 'bold',
                  //        fontSize: height*0.017,
                  //        fontWeight: FontWeight.w200
                  //      ),
                  //     border: GradientOutlineInputBorder(
                  //        borderRadius: BorderRadius.circular(height*0.011),
                  //        gradient: LinearGradient(colors: [
                  //          Colors.grey.withOpacity(0.7),
                  //          Colors.grey.withOpacity(0.7),
                  //        ]),
                  //        width: 0.7,
                  //      ),
                  //      prefixIcon: Icon(Icons.search_outlined,size: height*0.023,),
                  //    ),
                  //  ),
                  //),
                  StreamBuilder<DatabaseEvent>(
                    stream: contactsRef.onValue,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.withOpacity(0.8),
                          highlightColor: Colors.white,
                          child: Center(child: Padding(
                            padding: EdgeInsets.only(top: height*0.05,right: width*0.03,left: width*0.03),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: height*0.03),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: height*0.055,
                                        width: height*0.055,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.withOpacity(0.5)
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: width*0.03),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: height*0.023,
                                              width: width*0.15,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.3),
                                                borderRadius: BorderRadius.circular(height*0.008)
                                              ),
                                            ),
                                            SizedBox(height: height*0.01,),
                                            Container(
                                              height: height*0.023,
                                              width: width*0.55,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.21),
                                                borderRadius: BorderRadius.circular(height*0.008)
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: width*0.05,bottom: height*0.01),
                                        child: Container(
                                          height: height*0.023,
                                          width: width*0.08,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.13),
                                            borderRadius: BorderRadius.circular(height*0.008)
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: height*0.03),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: height*0.055,
                                        width: height*0.055,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.withOpacity(0.5)
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: width*0.03),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: height*0.023,
                                              width: width*0.15,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.3),
                                                borderRadius: BorderRadius.circular(height*0.008)
                                              ),
                                            ),
                                            SizedBox(height: height*0.01,),
                                            Container(
                                              height: height*0.023,
                                              width: width*0.55,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.21),
                                                borderRadius: BorderRadius.circular(height*0.008)
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: width*0.05,bottom: height*0.01),
                                        child: Container(
                                          height: height*0.023,
                                          width: width*0.08,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.13),
                                            borderRadius: BorderRadius.circular(height*0.008)
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: height*0.03),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: height*0.055,
                                        width: height*0.055,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.withOpacity(0.5)
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: width*0.03),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: height*0.023,
                                              width: width*0.15,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.3),
                                                borderRadius: BorderRadius.circular(height*0.008)
                                              ),
                                            ),
                                            SizedBox(height: height*0.01,),
                                            Container(
                                              height: height*0.023,
                                              width: width*0.55,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.21),
                                                borderRadius: BorderRadius.circular(height*0.008)
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: width*0.05,bottom: height*0.01),
                                        child: Container(
                                          height: height*0.023,
                                          width: width*0.08,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.13),
                                            borderRadius: BorderRadius.circular(height*0.008)
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                        return Center(child: Column(
                          children: [
                            Lottie.asset('assets/animations/empty_contact.json'),
                            Paragraph("Avec qui veux-tu discuter aujourd'hui ?", height*0.015, Colors.black, 1)
                          ],
                        ));
                      } else {
                        // Parse data into a usable format
                        final data = Map<String, dynamic>.from(
                          snapshot.data!.snapshot.value as Map,
                        );
                  
                        final contacts = data.entries.map((entry) {
                          return {
                            "id": entry.key,
                            ...Map<String, dynamic>.from(entry.value),
                          };
                        }).toList();
                        print(contacts.length);
                  
                        return Container(
                          alignment: Alignment.topCenter,
                          height: height*0.5,
                          width: width,
                          child: ListView.builder(
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {
                              final contact = contacts[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: height*0.02),
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(right: width*0.01,left: width*0.01),
                                  leading: ClipRRect(borderRadius: BorderRadius.circular(height),child: Image.asset(contact['avatar'])),
                                  title: subTitle(contact["with"],height*0.025,Colors.black),
                                  subtitle: Row(
                                    children: [
                                      SizedBox(
                                        width: contact['messages'] != null ? width*0.25 : width*0.25,
                                        child: Paragraph(contact['messages'] != null ? contact["messages"].last['content'] : 'Commencer à discuter',height*0.015,Colors.grey, 1),
                                      ),
                                      subParagraph(' ${contact["state"]}',height*0.015,Colors.grey),
                                    ],
                                  ),
                                  trailing: subTitle(contact['messages'] != null ? contact['messages'].last['time'] : '', height*0.017, Colors.black),
                                  onTap: () {
                                    setState(() {
                                      friendData = contact;
                                    });
                                    showChatRoom();
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          if(dispalyChatRoom) Animate(
            controller: animateController,
            autoPlay: false,
            effects: [
              SlideEffect(
                duration: Duration(milliseconds: 200),
                begin: Offset(1, 0),
                end: Offset(0, 0),
              ),
            ],
            child: ChatRoomPage(friendData: friendData,onTap: showChatRoom,)
          ),
        ],
      ),
    );
  }

  void showChatRoom() {
    Provider.of<AnimationProvider>(context, listen: false).triggerAnimation();
    if(dispalyChatRoom) {
      animateController.reverse();
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          dispalyChatRoom = !dispalyChatRoom;
        });
      });
    }else {
      animateController.forward();
        setState(() {
        dispalyChatRoom = !dispalyChatRoom;
      });
    }
  }

  void accessToSourcePage() {
    final state = context.findAncestorStateOfType<State<SourcePage>>() as SourcePageState;

    if(state.showNavBar) {
      state.animateController.forward();
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          state.showNavBar = false;
        });
      });
    }else {
      setState(() {
        state.showNavBar = true;
      });
      state.animateController.reverse();
    }
  }

  /*
    "contacts": {
      "4H3JK826JKFD826GFD" {
        "daniel": {
          "avatar": "assets/icons/AV5.png",
          "state": "Message envoyé",
          "messages": {
            "1": {
              "sender": "sissinou",
              "receiver": "daniel",
              "content": "Hi, how are you doing",
              "date": "15/11/2024",
              "time": "10/37",
            }
          },
        },
        "kaydo": {
          "avatar": "assets/icons/AV5.png",
          "state": "Message envoyé",
          "messages": {
            "1": {
              "sender": "sissinou",
              "receiver": "daniel",
              "content": "Hi, how are you doing",
              "date": "15/11/2024",
              "time": "10/37",
            }
          },
        },
      }
    }
  */
}