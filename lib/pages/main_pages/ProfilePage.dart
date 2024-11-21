import 'dart:ui';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:launcher/components/Components.dart';
import 'package:launcher/components/tools.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timelines_plus/timelines_plus.dart';

class ProfilePage extends StatefulWidget {
  final bool overlay;
  ProfilePage({super.key, required this.overlay});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>  with TickerProviderStateMixin  {

  late AnimationController animateController4;
  late AnimationController animateController1;
  late AnimationController animateControllerP;
  ScrollController _scrollController = ScrollController();
  bool show4 = false;
  bool show1 = false;
  bool showP = false;

  Map<String, dynamic> user = {};

  Future<void> fetchDataOnce() async {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('Users');
      QuerySnapshot snapshot = await collection.get();

      for (var document in snapshot.docs) {
        final d = document.data() as Map<String, dynamic>;
        if(d['email'] != null) {
          if(d['email'] == FirebaseAuth.instance.currentUser!.email) {
            setState(() {
              user = d;
            });
          } // Access each document's data
        }else {
          if(d['phonenumber'] == FirebaseAuth.instance.currentUser!.phoneNumber) {
            setState(() {
              user = d;
            });
          } // Access each document's data
        }
      }
    } catch (e) {
      CherryToast.error(description: Paragraph(e.toString(), 17, Colors.black, 1),).show(context);
    }
  }

  @override
  void initState() {
    super.initState();

    animateController4 = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this
    );

    animateController1 = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this
    );

    animateControllerP = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this
    );
    Future.delayed(Duration(milliseconds: 30), () {
      fetchDataOnce();
    });
  }


  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width; 

    return ClipRRect(
      borderRadius: BorderRadius.circular(height*0.025),
      child: user.isEmpty ? LoadingPage(height: height, width: width) : Stack(
        children: [
          MainProfilePage(user: user, height: height, width: width, show4: Show4, show1: Show1, showP: ShowP, overlay: widget.overlay,),
          if(show4) Animate(
            controller: animateController4,
            autoPlay: false,
            effects: [
              SlideEffect(
                begin: Offset(1, 0),
                end: Offset(0, 0),
              ),
            ],
            child: FriendRequestPage(height: height, width: width, friendRequest: user['friendRequest'], onTap:  Show4, thisUser: user,)
          ),
          if(show1) Animate(
            controller: animateController1,
            autoPlay: false,
            effects: [
              SlideEffect(
                begin: Offset(1, 0),
                end: Offset(0, 0),
              ),
            ],
            child: FriendsPage(height: height, width: width, friends: user['friends'], onTap:  Show1,)
          ),
          if(showP) Animate(
            controller: animateControllerP,
            effects: [
              SlideEffect(
                duration: Duration(milliseconds: 200),
                begin: Offset(1, 0),
                end: Offset(0, 0),
              )
            ],
            child: UserProfil(height: height, width: width, user: user, onTap: ShowP, owner: true, friend: false, sent: false,)
          ),
        ],
      ),
    );
  }
  void Show4() {
    //_scrollController.jumpTo(_scrollController.initialScrollOffset);
    if (show4) {
      animateController4.reverse();
      Future.delayed(Duration(milliseconds: 400), () {
        setState(() {
          show4 = false;
        });
      });
    }else{
      animateController4.forward();
      setState(() {
        show4 = true;
      });
    }
  }
  void Show1() {
    //_scrollController.jumpTo(_scrollController.initialScrollOffset);
    if (show1) {
      animateController1.reverse();
      Future.delayed(Duration(milliseconds: 400), () {
        setState(() {
          show1 = false;
        });
      });
    }else{
      animateController1.forward();
      setState(() {
        show1 = true;
      });
    }
  }
  void ShowP() {
    //_scrollController.jumpTo(_scrollController.initialScrollOffset);
    if (showP) {
      animateControllerP.reverse();
      Future.delayed(Duration(milliseconds: 400), () {
        setState(() {
          showP = false;
        });
      });
    }else{
      animateControllerP.forward();
      setState(() {
        showP = true;
      });
    }
  }

}

class UserProfil extends StatefulWidget {
  UserProfil({super.key, required this.height, required this.width, required this.user, required this.onTap, required this.owner, required this.friend, required this.sent});

  final double height;
  final double width;
  final VoidCallback onTap;
  Map user;
  final bool owner;
  final bool friend;
  final bool sent;

  @override
  State<UserProfil> createState() => _UserProfilState();
}

class _UserProfilState extends State<UserProfil> with TickerProviderStateMixin  {

  bool show = false;

  late AnimationController animateController1;

  late Map<String, dynamic> thisUserInfo;
  late Map<String, dynamic> friendUserInfo;

  void showInshow() {
    if(show) {
      animateController1.reverse();
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          show = false;
        });
      });
    }else {
      setState(() {
        show = true;
      });
      animateController1.forward();
    }
  }

  Future<Map<String, dynamic>?> getUserInfo(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference userRef = firestore.collection("Users").doc(userId);

    try {
      // Fetch the user document
      DocumentSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        // Convert document data to Map and return
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        return userData;
      } else {
        print("No user found with ID: $userId");
        return null;
      }
    } catch (e) {
      print("Failed to fetch user info: $e");
      return null;
    }
  }

  void storeTheData() async {
    thisUserInfo = (await getUserInfo(FirebaseAuth.instance.currentUser!.uid))!;
    if(widget.friend) {
      Future.delayed(Duration(milliseconds: 200), () async {
        final d = (await getUserInfo(widget.user['uid']))!;
        setState(() {
          widget.user = d;
        });
      });
    }
  }

  Future<void> sendFriendRequest(String userId, Map newInvitation) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference userRef = firestore.collection("Users").doc(userId);

    try {
      await firestore.runTransaction((transaction) async {
        // Get the current user document
        DocumentSnapshot snapshot = await transaction.get(userRef);

        if (snapshot.exists) {
          // Fetch the current invitations list
          List<dynamic> invitations = snapshot.get("friendRequest") ?? [];

          // Check if the `uid` exists in any invitation
          bool exists = invitations.any((invitation) {
            return invitation['uid'] == newInvitation['uid'];
          });

          if (exists) {
            CherryToast.warning(title: subTitle("L'invitation existe déjà!", widget.height*0.021, Colors.black),description: subParagraph('Vous avez déja envoyer une invitation', widget.height*0.017, Colors.black),).show(context);
          } else {
            // Add the new invitation to the list
            invitations.add(newInvitation);

            // Update Firestore
            transaction.update(userRef, {"friendRequest": invitations});

            // Add it to news field 
            await transaction.update(userRef, {
              'news': FieldValue.arrayUnion([{
                'type': 'friendRequest',
                'from': newInvitation['from'],
                'state': newInvitation['state'],
                'date': newInvitation['date'],
                'time': newInvitation['time'],
              }])
            });
            CherryToast.success(description: subParagraph("l'invitation a été envoyée avec succès", widget.height*0.017, Colors.black),).show(context);
          }
        } else {
          print("User document does not exist!");
        }
      });
    } catch (e) {
      print("Failed to add invitation: $e");
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    animateController1 = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this
    );

    storeTheData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: mainPadding(widget.width, widget.height),
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.height*0.025),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: widget.friend ? widget.height*0.03 : widget.height*0.01,),
                  Row(
                    children: [
                      IconButton(onPressed: widget.onTap,icon: Icon(Icons.arrow_back_ios_new_outlined,size: widget.height*0.023,color: Colors.black,)),
                      SizedBox(width: widget.width*0.05,),
                      MyTitle(widget.owner ? 'Mon profil' : 'Profil', widget.height*0.023, FontWeight.bold, Colors.black),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.02),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: widget.width*0.015),
                          child: Container(
                            alignment: Alignment.center,
                            height: widget.height*0.21,
                            width: widget.height*0.21,
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
                              borderRadius: BorderRadius.circular(widget.height)
                            ),
                            child: ClipRRect(borderRadius: BorderRadius.circular(widget.height),child: Image.asset(widget.user['avatar'],fit: BoxFit.contain,height: widget.height*0.20,width: widget.height*0.20,)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: widget.width*0.01),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyTitle(widget.user['name'], widget.height*0.03, FontWeight.bold, Colors.black),
                              Padding(
                                padding: EdgeInsets.only(bottom: widget.width*0.025),
                                child: MyTitle('@${widget.user['username']}', widget.height*0.017, FontWeight.w200, Colors.black),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: widget.width*0.025),
                                child: MyTitle('${widget.user['country']}, ${widget.user['city']}', widget.height*0.017, FontWeight.w400, Colors.black),
                              ),
                              widget.owner ? Container(
                                alignment: Alignment.center,
                                height: widget.height*0.035,
                                width: widget.width*0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(widget.height*0.01),
                                  color: HexColor('4147FA'),
                                ),
                                child: Paragraph('Edit profile', widget.height*0.013, Colors.white, 1),
                              ) : Row(
                                children: [
                                  if(!widget.friend) GestureDetector(
                                    onTap: () {
                                      if(!widget.sent) {
                                        sendFriendRequest(
                                          widget.user['uid'], 
                                          {
                                            'from' : thisUserInfo,
                                            'date' : DateFormat('dd/MM/yyyy').format(DateTime.now()),
                                            'time' : TimeOfDay.now().format(context),
                                            'state' : 'waiting',
                                          }
                                        );
                                      }else {
                                        CherryToast.info(description: subParagraph("Cet utilisateur vous a déjà envoyé une demande d'amitié", widget.height*0.017, Colors.black87),).show(context);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: widget.width*0.01),
                                      child: Opacity(
                                        opacity: widget.sent ? 0.5 : 1,
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: widget.height*0.035,
                                          width: widget.height*0.045,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(widget.height*0.01),
                                            color: HexColor('4147FA'),
                                          ),
                                          child: Icon(Icons.add, color: Colors.white,size: widget.height*0.021,),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        show = true;
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: widget.height*0.035,
                                      width: widget.width*0.2,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(widget.height*0.01),
                                        color: HexColor('4147FA'),
                                      ),
                                      child: Paragraph('Collaborer', widget.height*0.013, Colors.white, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              
                  Padding(
                    padding: EdgeInsets.only(top: widget.height*0.01,bottom: widget.height*0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            subTitle(widget.user['friends'].length.toString(), widget.height*0.021, Colors.black),
                            Paragraph('Amies', widget.height*0.017, Colors.black54, 1),
                          ],
                        ),
                        Column(
                          children: [
                            subTitle(widget.user['collab'].length.toString(), widget.height*0.021, Colors.black),
                            Paragraph('Collaborateurs', widget.height*0.017, Colors.black54, 1),
                          ],
                        ),
                        Column(
                          children: [
                            subTitle(widget.user['liveapps'].length.toString(), widget.height*0.021, Colors.black),
                            Paragraph('Liveapps', widget.height*0.017, Colors.black54, 1),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.025),
                    child: subParagraph(widget.user['bio'], widget.height*0.019, Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.01),
                    child: Divider(color: Colors.grey,thickness: 0.5,),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.01),
                    child: subTitle('Loisirs', widget.height*0.021, Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.025),
                    child: SizedBox(
                      width: widget.width*0.9,
                      height: widget.height*0.035,
                      child: ListView.builder(
                        itemCount: widget.user['hobbies'].length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: widget.width*0.02),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(right: widget.width*0.02,left: widget.width*0.02),
                              width: widget.user['hobbies'][index].toString().length*11 < widget.width*0.3 ? widget.user['hobbies'][index].toString().length*11 : widget.width*0.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(widget.height*0.01),
                                color: mainColor.withOpacity(0.1),
                              ),
                              child: Paragraph(widget.user['hobbies'][index], widget.height*0.013, Colors.black87, 1),
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.01),
                    child: Divider(color: Colors.grey,thickness: 0.5,),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.01),
                    child: subTitle('Je suis intéressé', widget.height*0.021, Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.025),
                    child: SizedBox(
                      width: widget.width*0.9,
                      height: widget.height*0.035,
                      child: ListView.builder(
                        itemCount: widget.user['interested'].length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: widget.width*0.02),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(right: widget.width*0.02,left: widget.width*0.02),
                              width: widget.user['interested'][index].toString().length*11 < widget.width*0.3 ? widget.user['interested'][index].toString().length*14 : widget.width*0.35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(widget.height*0.01),
                                color: mainColor.withOpacity(0.1),
                              ),
                              child: Paragraph(widget.user['interested'][index], widget.height*0.013, Colors.black87, 1),
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.01),
                    child: Divider(color: Colors.grey,thickness: 0.5,),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.01),
                    child: subTitle('Les formations', widget.height*0.021, Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.1),
                    child: Container(
                      alignment: Alignment.topLeft,
                      height: widget.height*0.3,
                      child: FixedTimeline.tileBuilder(
                        theme: TimelineThemeData(
                          color: mainColor
                        ),
                        builder: TimelineTileBuilder.connectedFromStyle(
                          contentsAlign: ContentsAlign.reverse,
                          nodePositionBuilder: (context, index) => 0.3,
                          firstConnectorStyle: ConnectorStyle.transparent,
                          lastConnectorStyle: ConnectorStyle.transparent,
                          oppositeContentsBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.user['education'][index]['name']),
                          ),
                          contentsBuilder: (context, index) => Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.user['education'][index]['date']),
                            ),
                          ),
                          connectorStyleBuilder: (context, index) => ConnectorStyle.dashedLine,
                          indicatorStyleBuilder: (context, index) => IndicatorStyle.outlined,
                          itemCount: widget.user['education'].length,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if(show) Animate(
              controller: animateController1,
              effects: [
                SlideEffect(
                  begin: Offset(1, 0),
                  end: Offset(0, 0),
                ),
              ],
              child: CollabWidget(height: widget.height, width: widget.width, showInshow: showInshow, user: widget.user,)
            ),
          ],
        ),
      ),
    );
  }
}

class CollabWidget extends StatefulWidget {
  double height;
  double width;
  VoidCallback showInshow;
  Map user;
  CollabWidget({super.key, required this.height, required this.width, required this.showInshow, required this.user});

  @override
  State<CollabWidget> createState() => _CollabWidgetState();
}

class _CollabWidgetState extends State<CollabWidget> {

  int index = 0;

  bool show = false;

  int itemIndex = 0;

  List typeCollaborationChoosen = [];
  List skillsChoosen = [];
  List languageChoosen = [];

  List typeCollaboration = [
    ['Brainstorming', false],
    ['Réunion', false],
    ['Gestion de projet', false],
    ['Design graphique', false],
    ['Création de contenu', false],
    ['Marketing', false],
    ['Jeux vidéo en ligne', false],
    ['Jeux de société virtuels', false],
    ['Jeux de réflexion', false],
    ['Jeux de rôle', false],
    ['Jeux créatifs et collaboratifs', false],
    ['Évènement en ligne', false],
    ['Cours en ligne', false],
    ['Atelier collaboratif', false],
    ['Musique', false],
    ['Discussion de groupe', false],
  ];
  List skills = [
    ['HTML', false],
    ['Photoshop', false],
    ['Copywriting', false],
    ['SEO', false],
    ['Réseaux sociaux', false],
    ['Agile', false],
    ['Python', false],
    ['Java', false],
  ];
  List language = [
    ['Français', false],
    ['Anglais', false],
    ['Espagnol', false],
    ['Portugais', false],
    ['Arabe', false],
    ['Russe', false],
    ['Allemand', false],
  ];
  List liveApp = [
    {'item': 'Clash of clans','avatar':'https://i.pinimg.com/736x/98/92/8c/98928c82f78bdd50c5a28d8fa4633035.jpg','packageName':'com.supercell.clashofclans'},
  ];
  int liveAppIndex = 27;
  List liveAppChoosen = [];
  Map thisUser = {};

  Future<Map<String, dynamic>?> getUserInfo(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference userRef = firestore.collection("Users").doc(userId);

    try {
      // Fetch the user document
      DocumentSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        // Convert document data to Map and return
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        return userData;
      } else {
        print("No user found with ID: $userId");
        return null;
      }
    } catch (e) {
      print("Failed to fetch user info: $e");
      return null;
    }
  }

  void storeTheData() async {
    Future.delayed(Duration(milliseconds: 200), () async {
      final d = (await getUserInfo(FirebaseAuth.instance.currentUser!.uid))!;
      setState(() {
        thisUser = d;
      });
    });
  }


  Future<void> sendCollab(String username, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'collab': FieldValue.arrayUnion([{
          'type' : typeCollaborationChoosen,
          'skills': skillsChoosen,
          'language': languageChoosen,
          'with': widget.user,
          'from': null,
          'state': 'waiting',
          'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
          'time': TimeOfDay.now().format(context),
        }]),
      });

      // Query Firestore for the document(s) where 'username' equals the provided value
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('username', isEqualTo: username)
          .get();

      // Check if there are matching documents
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          // Update each matching document
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(doc.id) // Get the document ID
              .update(updatedData);
          print("User ${doc.id} updated successfully.");
        }
      } else {
        print("No user found with username: $username");
      }
    } catch (error) {
      print("Failed to update user: $error");
    }
  }

  @override
  void initState() {
    super.initState();

    storeTheData();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: mainPadding(widget.width, widget.height),
      height: widget.height,
      width: widget.width,
      color: Colors.white,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.03),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: widget.showInshow,
                          child: Icon(Icons.arrow_back_ios_new_outlined,size: widget.height*0.023,)
                        ),
                        Expanded(child: SizedBox(width: 1,)),
                        IconButton(
                          onPressed: () {
                            print(liveAppChoosen);
                          },
                          icon: subParagraph('Rénitialisation', widget.height*0.017, Colors.black)
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.01),
                    child: Row(
                      children: [
                        MyTitle('Type de collaboration', widget.height*0.019, FontWeight.bold, Colors.black),
                        Expanded(child: SizedBox(width: 1,)),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              show = true;
                              itemIndex = 0;
                            });
                          },
                          icon: subParagraph('Voir tout', widget.height*0.017, secondColor)
                        ),
                        Icon(Icons.arrow_forward_ios_outlined,size: widget.height*0.019,),
                      ],
                    ),
                  ),
                  if(typeCollaborationChoosen.isNotEmpty) Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.01),
                    child: SizedBox(
                      height: widget.height*0.035,
                      child: ListView.builder(
                        itemCount: typeCollaborationChoosen.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index) {
                          return Padding(
                            padding: EdgeInsets.only(right: widget.width*0.03),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  typeCollaborationChoosen.removeAt(index);
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: widget.height*0.035,
                                width: typeCollaborationChoosen[index].toString().length*8,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(widget.height*0.007),
                                ),
                                child: subParagraph(typeCollaborationChoosen[index], widget.height*0.015, Colors.black),
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 0.3,
                    color: Colors.black38,
                  ),
                  
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.01),
                    child: Row(
                      children: [
                        MyTitle('Liveapp', widget.height*0.019, FontWeight.bold, Colors.black),
                        Expanded(child: SizedBox(width: 1,)),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              show = true;
                              itemIndex = 1;
                            });
                          },
                          icon: subParagraph('Voir tout', widget.height*0.017, secondColor)
                        ),
                        Icon(Icons.arrow_forward_ios_outlined,size: widget.height*0.019,),
                      ],
                    ),
                  ),
                  if(liveAppChoosen.isNotEmpty) Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.01),
                    child: SizedBox(
                      height: widget.height*0.035,
                      child: ListView.builder(
                        itemCount: liveAppChoosen.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index) {
                          return Padding(
                            padding: EdgeInsets.only(right: widget.width*0.03),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  liveAppChoosen.removeAt(index);
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: widget.height*0.035,
                                width: liveAppChoosen[index]['item'].toString().length*8,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(widget.height*0.007),
                                ),
                                child: subParagraph(liveAppChoosen[index]['item'], widget.height*0.015, Colors.black),
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ),
              
                  Divider(
                    thickness: 0.3,
                    color: Colors.black38,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.01),
                    child: Row(
                      children: [
                        MyTitle('Compétances', widget.height*0.019, FontWeight.bold, Colors.black),
                        Expanded(child: SizedBox(width: 1,)),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              show = true;
                              itemIndex = 2;
                            });
                          },
                          icon: subParagraph('Voir tout', widget.height*0.017, secondColor)
                        ),
                        Icon(Icons.arrow_forward_ios_outlined,size: widget.height*0.019,),
                      ],
                    ),
                  ),
                  if(skillsChoosen.isNotEmpty) Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.01),
                    child: SizedBox(
                      height: widget.height*0.035,
                      child: ListView.builder(
                        itemCount: skillsChoosen.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index) {
                          return Padding(
                            padding: EdgeInsets.only(right: widget.width*0.03),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  skillsChoosen.removeAt(index);
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: widget.height*0.035,
                                width: skillsChoosen[index].toString().length*9,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(widget.height*0.007),
                                ),
                                child: subParagraph(skillsChoosen[index], widget.height*0.015, Colors.black),
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 0.3,
                    color: Colors.black38,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.01),
                    child: Row(
                      children: [
                        MyTitle('Langues', widget.height*0.019, FontWeight.bold, Colors.black),
                        Expanded(child: SizedBox(width: 1,)),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              show = true;
                              itemIndex = 3;
                            });
                          },
                          icon: subParagraph('Voir tout', widget.height*0.017, secondColor)
                        ),
                        Icon(Icons.arrow_forward_ios_outlined,size: widget.height*0.019,),
                      ],
                    ),
                  ),
                  if(languageChoosen.isNotEmpty) Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.01),
                    child: SizedBox(
                      height: widget.height*0.035,
                      child: ListView.builder(
                        itemCount: languageChoosen.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index) {
                          return Padding(
                            padding: EdgeInsets.only(right: widget.width*0.03),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  languageChoosen.removeAt(index);
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: widget.height*0.035,
                                width: languageChoosen[index].toString().length*8,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(widget.height*0.007),
                                ),
                                child: subParagraph(languageChoosen[index], widget.height*0.015, Colors.black),
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 0.3,
                    color: Colors.black38,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.03),
                    child: MyTitle("Niveau d'expérience", widget.height*0.019, FontWeight.bold, Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.02),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          index = 0;
                        });
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: widget.width*0.02),
                            child: AnimatedContainer(
                              alignment: Alignment.center,
                              duration: Duration(milliseconds: 200),
                              height: widget.height*0.02,
                              width: widget.height*0.02,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(widget.height*0.007),
                                border: Border.all(width: 0.3,color: Colors.black38),
                                color: index == 0 ? secondColor : Colors.transparent,
                              ),
                              child: index == 0 ? Icon(Icons.done,color: Colors.white,size: widget.height*0.013,) : Container(),
                            ),
                          ),
                          Paragraph("Débutant", widget.height*0.017, Colors.black, 1),
                          Expanded(
                            child: SizedBox(
                              width: 1,
                            ),
                          ),
                          Image.asset('assets/icons/star.png',height: widget.height*0.023,),
                          Image.asset('assets/icons/starOutlined.png',height: widget.height*0.023,),
                          Image.asset('assets/icons/starOutlined.png',height: widget.height*0.023,),
                          Image.asset('assets/icons/starOutlined.png',height: widget.height*0.023,),
                          Image.asset('assets/icons/starOutlined.png',height: widget.height*0.023,),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.02),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          index = 1;
                        });
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: widget.width*0.02),
                            child: AnimatedContainer(
                              alignment: Alignment.center,
                              duration: Duration(milliseconds: 200),
                              height: widget.height*0.02,
                              width: widget.height*0.02,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(widget.height*0.007),
                                border: Border.all(width: 0.3,color: Colors.black38),
                                color: index == 1 ? secondColor : Colors.transparent,
                              ),
                              child: index == 1 ? Icon(Icons.done,color: Colors.white,size: widget.height*0.013,) : Container(),
                            ),
                          ),
                          Paragraph("Intermédiaire", widget.height*0.017, Colors.black, 1),
                          Expanded(
                            child: SizedBox(
                              width: 1,
                            ),
                          ),
                          Image.asset('assets/icons/star.png',height: widget.height*0.023,),
                          Image.asset('assets/icons/star.png',height: widget.height*0.023,),
                          Image.asset('assets/icons/star.png',height: widget.height*0.023,),
                          Image.asset('assets/icons/starOutlined.png',height: widget.height*0.023,),
                          Image.asset('assets/icons/starOutlined.png',height: widget.height*0.023,),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.height*0.01),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          index = 2;
                        });
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: widget.width*0.02),
                            child: AnimatedContainer(
                              alignment: Alignment.center,
                              duration: Duration(milliseconds: 200),
                              height: widget.height*0.02,
                              width: widget.height*0.02,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(widget.height*0.007),
                                border: Border.all(width: 0.3,color: Colors.black38),
                                color: index == 2 ? secondColor : Colors.transparent,
                              ),
                              child: index == 2 ? Icon(Icons.done,color: Colors.white,size: widget.height*0.013,) : Container(),
                            ),
                          ),
                          Paragraph("Avancé", widget.height*0.017, Colors.black, 1),
                          Expanded(
                            child: SizedBox(
                              width: 1,
                            ),
                          ),
                          Image.asset('assets/icons/star.png',height: widget.height*0.023,),
                          Image.asset('assets/icons/star.png',height: widget.height*0.023,),
                          Image.asset('assets/icons/star.png',height: widget.height*0.023,),
                          Image.asset('assets/icons/star.png',height: widget.height*0.023,),
                          Image.asset('assets/icons/star.png',height: widget.height*0.023,),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: typeCollaborationChoosen.isNotEmpty || skillsChoosen.isNotEmpty || languageChoosen.isNotEmpty || liveAppChoosen.isNotEmpty ? widget.height*0.11 : widget.height*0.03),
                    child: GestureDetector(
                      onTap: () {
                        sendCollab(widget.user['username'], {
                          'collab': 
                            FieldValue.arrayUnion([{
                              'type' : 'collaboration',
                              'collaborationType': typeCollaborationChoosen,
                              'skills': skillsChoosen,
                              'language': languageChoosen,
                              'from': thisUser,
                              'with': null,
                              'state': 'waiting',
                              'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
                              'time': TimeOfDay.now().format(context),
                            }]),
                          'news' : FieldValue.arrayUnion([{
                            'type': 'collaboration',
                            'language': languageChoosen,
                            'skills': skillsChoosen,
                            'liveApp': liveAppChoosen,
                            'collaborationType': typeCollaborationChoosen,
                            'from': thisUser,
                            'with': null,
                            'state': 'waiting',
                            'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
                            'time': TimeOfDay.now().format(context),
                          }]),
                        }).whenComplete(() {
                          CherryToast.success(title: subTitle('Bravo!', widget.height*0.021, Colors.black),description: subParagraph('La collaboration a été envoyée à ${widget.user['name']} avec succès', widget.height*0.017, Colors.black),).show(context);
                          widget.showInshow();
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: widget.height*0.065,
                        width: widget.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              HexColor('1726C5'),
                              HexColor('4147FA'),
                            ]
                          ),
                          borderRadius: BorderRadius.circular(widget.height*0.013)
                        ),
                        child: Paragraph('Appliquer', widget.height*0.019, Colors.white, 1),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if(show) Container(
            height: widget.height,
            width: widget.width,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          show = false;
                        });
                      },
                      icon: Icon(Icons.arrow_back_ios_new_outlined,size: widget.height*0.023,),
                    ),
                    SizedBox(width: widget.width*0.05,),
                    MyTitle(itemIndex == 0 ? 'Type de collaboration' : itemIndex == 1 ? 'Liveapp' : itemIndex == 2 ? 'Compétance' : 'Language', widget.height*0.023, FontWeight.bold, Colors.black)
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: widget.height*0.03),
                  child: SizedBox(
                    height: widget.height*0.7,
                    child: ListView.builder(
                      itemCount: itemIndex == 0 ? typeCollaboration.length : itemIndex == 1 ? liveApp.length : itemIndex == 2 ? skills.length : language.length,
                      itemBuilder: (context, index) {
                        var item = itemIndex == 0 ? typeCollaboration[index] : itemIndex == 1 ? liveApp[index] : itemIndex == 2 ? skills[index] : language[index];
                        if(itemIndex == 1) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: widget.height*0.01,left: widget.width*0.02),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  liveAppChoosen.clear();
                                  liveAppIndex = index;
                                  liveAppChoosen.add(item);
                                });
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(right: widget.width*0.02,left: widget.width*0.02,),
                                height: widget.height*0.07,
                                width: widget.width,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.3,color: Colors.black45),
                                  borderRadius: BorderRadius.circular(widget.height*0.013),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(widget.height*0.01),
                                      child: Image.network(item['avatar'],height: widget.height*0.055,),
                                    ),
                                    SizedBox(width: widget.width*0.03,),
                                    Paragraph(item['item'], widget.height*0.019, Colors.black, 1),
                                    Expanded(child: SizedBox(width: 1,)),
                                    Padding(
                                      padding: EdgeInsets.only(right: widget.width*0.02),
                                      child: AnimatedContainer(
                                        alignment: Alignment.center,
                                        duration: Duration(milliseconds: 200),
                                        height: widget.height*0.025,
                                        width: widget.height*0.025,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(widget.height*0.007),
                                          border: Border.all(width: 0.3,color: Colors.black38),
                                          color: liveAppIndex == index ? secondColor : Colors.transparent,
                                        ),
                                        child: liveAppIndex == index ? Icon(Icons.done,color: Colors.white,size: widget.height*0.015,) : Container(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }else {
                          return Padding(
                            padding: EdgeInsets.only(bottom: widget.height*0.01,left: widget.width*0.02),
                            child: GestureDetector(
                              onTap: () {
                                if(item[1]) {
                                  if(itemIndex == 0) {
                                    setState(() {
                                      typeCollaborationChoosen.removeWhere((i) => i == item[0]);
                                      item[1] = false;
                                    });
                                  }else if(itemIndex == 2) {
                                    setState(() {
                                      skillsChoosen.removeWhere((i) => i == item[0]);
                                      item[1] = false;
                                    });
                                  }else if(itemIndex == 3) {
                                    setState(() {
                                      languageChoosen.removeWhere((i) => i == item[0]);
                                      item[1] = false;
                                    });
                                  }
                                }else {
                                  if(itemIndex == 0) {
                                    setState(() {
                                      typeCollaborationChoosen.add(item[0]);
                                      item[1] = true;
                                    });
                                  }else if(itemIndex == 2) {
                                    setState(() {
                                      skillsChoosen.add(item[0]);
                                      item[1] = true;
                                    });
                                  }else if(itemIndex == 3) {
                                    setState(() {
                                      languageChoosen.add(item[0]);
                                      item[1] = true;
                                    });
                                  }
                                }
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(right: widget.width*0.02,left: widget.width*0.02,),
                                height: widget.height*0.05,
                                width: widget.width,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.3,color: Colors.black45),
                                  borderRadius: BorderRadius.circular(widget.height*0.013),
                                ),
                                child: Row(
                                  children: [
                                    Paragraph(item[0], widget.height*0.015, Colors.black, 1),
                                    Expanded(child: SizedBox(width: 1,)),
                                    Padding(
                                      padding: EdgeInsets.only(right: widget.width*0.02),
                                      child: AnimatedContainer(
                                        alignment: Alignment.center,
                                        duration: Duration(milliseconds: 200),
                                        height: widget.height*0.02,
                                        width: widget.height*0.02,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(widget.height*0.007),
                                          border: Border.all(width: 0.3,color: Colors.black38),
                                          color: item[1] ? secondColor : Colors.transparent,
                                        ),
                                        child: item[1] ? Icon(Icons.done,color: Colors.white,size: widget.height*0.013,) : Container(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      }
                    ),
                  ),
                ),
              ],
            ),
          ).animate().slide(duration: Duration(milliseconds: 200),begin: Offset(1, 0),end: Offset(0, 0)),
        ],
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: height*0.5,
              width: width,
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.025), topLeft: Radius.circular(height*0.025), bottomRight: Radius.circular(height*0.041), bottomLeft: Radius.circular(height*0.041)),
                image: DecorationImage(image: AssetImage('assets/images/profileBackground.png'),fit: BoxFit.cover),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: height*0.015),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.5),
                      highlightColor: Colors.white,
                      child: Container(
                        alignment: Alignment.center,
                        height: height*0.25,
                        width: height*0.25,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.15),
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
                      ),
                    ),
                  ),
                  Container(
                    height: height*0.025,
                    width: width*0.4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(height*0.01)
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height*0.01,bottom: height*0.015),
                    child: Container(
                      height: height*0.025,
                      width: width*0.2,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(height*0.01)
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height*0.0),
                    child: SubmitButton(height*0.055, width*0.3, 'Voir le profil', height*0.017),
                  ),
                ],
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.grey.withOpacity(0.6),
              child: Padding(
                padding: EdgeInsets.only(top: height*0.02,bottom: height*0.015,right: width*0.05,left: width*0.05),
                child: Container(
                  padding: EdgeInsets.only(right: width*0.03,left: width*0.03),
                  height: height*0.085,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height*0.013),
                    border: Border.all(width: 0.7,color: Colors.grey.withOpacity(0.5))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: height*0.07,
                        width: height*0.07,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor('243ADC').withOpacity(0.05)
                        ),
                      ),
                      Expanded(flex: 1,child: SizedBox(width: 1,)),
                      Container(
                        height: height*0.025,
                        width: width*0.4,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(height*0.01)
                        ),
                      ),
                      Expanded(flex: 3,child: SizedBox(width: 1,)),
                      Icon(Icons.arrow_forward_ios_outlined,size: height*0.02,color: Colors.black,),
                    ],
                  ),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.grey.withOpacity(0.6),
              child: Padding(
                padding: EdgeInsets.only(top: height*0.02,bottom: height*0.015,right: width*0.05,left: width*0.05),
                child: Container(
                  padding: EdgeInsets.only(right: width*0.03,left: width*0.03),
                  height: height*0.085,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height*0.013),
                    border: Border.all(width: 0.7,color: Colors.grey.withOpacity(0.5))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: height*0.07,
                        width: height*0.07,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor('243ADC').withOpacity(0.05)
                        ),
                      ),
                      Expanded(flex: 1,child: SizedBox(width: 1,)),
                      Container(
                        height: height*0.025,
                        width: width*0.4,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(height*0.01)
                        ),
                      ),
                      Expanded(flex: 3,child: SizedBox(width: 1,)),
                      Icon(Icons.arrow_forward_ios_outlined,size: height*0.02,color: Colors.black,),
                    ],
                  ),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.grey.withOpacity(0.6),
              child: Padding(
                padding: EdgeInsets.only(bottom: height*0.015,right: width*0.05,left: width*0.05),
                child: Container(
                  padding: EdgeInsets.only(right: width*0.03,left: width*0.03),
                  height: height*0.085,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height*0.013),
                    border: Border.all(width: 0.7,color: Colors.grey.withOpacity(0.5))
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: height*0.07,
                        width: height*0.07,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor('243ADC').withOpacity(0.05)
                        ),
                      ),
                      Expanded(flex: 1,child: SizedBox(width: 1,)),
                      Container(
                        height: height*0.025,
                        width: width*0.4,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(height*0.01)
                        ),
                      ),
                      Expanded(flex: 3,child: SizedBox(width: 1,)),
                      Icon(Icons.arrow_forward_ios_outlined,size: height*0.02,color: Colors.black,),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
  }
}

class FriendRequestPage extends StatefulWidget {
  const FriendRequestPage({
    super.key,
    required this.height,
    required this.width,
    required this.friendRequest,
    required this.onTap,
    required this.thisUser,
  });

  final double height;
  final double width;
  final List friendRequest;
  final VoidCallback onTap;
  final Map thisUser;

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  @override
  Widget build(BuildContext context) {
    Future<void> confirmFriendRequest(Map firstUser, Map secondUser) async {
      try {
        // Firestore references
        final firestore = FirebaseFirestore.instance;
        final secondUserRef = firestore.collection('Users').doc(secondUser['uid']);
        final firstUserRef = firestore.collection('Users').doc(firstUser['uid']);

        final contactsRef = FirebaseDatabase.instance.ref('contacts');
        final firstRef = contactsRef.child(firstUser['uid']);
        final secondRef = contactsRef.child(secondUser['uid']);

        // Fetch data for both users
        DocumentSnapshot secondUserSnapshot = await secondUserRef.get();
        DocumentSnapshot firstUserSnapshot = await firstUserRef.get();

        if (!secondUserSnapshot.exists || !firstUserSnapshot.exists) {
          print("One or both users do not exist!");
          return;
        }

        // Get the friendRequest and friends fields
        List<dynamic> secondUserFriendRequest = List.from(secondUserSnapshot.get('friendRequest') ?? []);
        List<dynamic> secondUserFriends = List.from(secondUserSnapshot.get('friends') ?? []);
        List<dynamic> firstUserFriends = List.from(firstUserSnapshot.get('friends') ?? []);

        // Find the friend request in second user's friendRequest list
        var friendRequest = secondUserFriendRequest.firstWhere(
          (request) => request['from']['uid'] == firstUser['uid'],
          orElse: () => null,
        );

        if (friendRequest != null) {
          // Remove the friend request
          secondUserFriendRequest.remove(friendRequest);

          // Check if the user is already in the friends list
          bool isAlreadyFriend = secondUserFriends.any((friend) => friend['uid'] == firstUser['uid']);
          bool isSecondUserAlreadyFriend = firstUserFriends.any((friend) => friend['uid'] == secondUser['uid']);

          if (!isAlreadyFriend) {
            // Add first user to second user's friends
            secondUserFriends.add({'uid': firstUser['uid'], 'username': firstUser['username']});
            await secondRef.update({
              firstUser['uid']: {
                'with': firstUser['username'],
                'avatar': firstUser['avatar'],
                'state': 'Nouveau ✨',
                'messages': [],
              },
            });
          }

          if (!isSecondUserAlreadyFriend) {
            // Add second user to first user's friends
            firstUserFriends.add({'uid': secondUser['uid'], 'username': secondUser['username']});
            await firstRef.update({
              secondUser['uid']: {
                'with': secondUser['username'],
                'avatar': secondUser['avatar'],
                'state': 'Nouveau ✨',
                'messages': [],
              },
            });
          }

          // Update Firestore
          await secondUserRef.update({
            'friendRequest': secondUserFriendRequest,
            'friends': FieldValue.arrayUnion([firstUser]),
          });

          await firstUserRef.update({
            'friends': FieldValue.arrayUnion([secondUser]),
          });

          print("Friend request confirmed successfully!");
        } else {
          print("No friend request found.");
        }
      } catch (e) {
        print("Failed to confirm friend request: $e");
      }
    }

    return Container(
      padding: mainPadding(widget.width, widget.height),
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget.height*0.025),
      ),
      child: Column(
        children: [
          SizedBox(height: widget.height*0.01,),
          Row(
            children: [
              IconButton(onPressed: widget.onTap,icon: Icon(Icons.arrow_back_ios_new_outlined,size: widget.height*0.023,color: Colors.black,)),
              SizedBox(width: widget.width*0.05,),
              MyTitle('Mes invitations', widget.height*0.023, FontWeight.bold, Colors.black),
            ],
          ),
          SizedBox(
            height: widget.height*0.6,
            child: ListView.builder(
              itemCount: widget.friendRequest.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: widget.height*0.015),
                  child: Container(
                    padding: EdgeInsets.only(right: widget.width*0.03,left: widget.width*0.03),
                    height: widget.height*0.1,
                    width: widget.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.height*0.013),
                      border: Border.all(width: 0.7,color: Colors.grey.withOpacity(0.5))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Transform.scale(scale: 0.8,child: ClipRRect(borderRadius: BorderRadius.circular(widget.height),child: Image.asset(widget.friendRequest[index]['from']['avatar'],))),
                        SizedBox(width: widget.width*0.03,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            subTitle(' ${widget.friendRequest[index]['from']['username']}', widget.height*0.021, Colors.black),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    confirmFriendRequest(widget.friendRequest[index]['from'], widget.thisUser).whenComplete(() {
                                      setState(() {
                                        widget.friendRequest.removeAt(index);
                                      });
                                    });
                                  },
                                  child: SubmitButton(widget.height*0.035, widget.width*0.23, 'Confirmer', widget.height*0.015)
                                ),
                                SizedBox(width: widget.width*0.03,),
                                Opacity(opacity: 0.5,child: SubmitButton(widget.height*0.035, widget.width*0.23, 'Supprimer', widget.height*0.015)),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}

class FriendsPage extends StatelessWidget {
  const FriendsPage({
    super.key,
    required this.height,
    required this.width,
    required this.friends,
    required this.onTap,
  });

  final double height;
  final double width;
  final List friends;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: mainPadding(width, height),
      height: height*0.9,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(height*0.025),
      ),
      child: Column(
        children: [
          SizedBox(height: height*0.01,),
          Row(
            children: [
              IconButton(onPressed: onTap,icon: Icon(Icons.arrow_back_ios_new_outlined,size: height*0.023,color: Colors.black,)),
              SizedBox(width: width*0.05,),
              MyTitle('Mon Réseau', height*0.023, FontWeight.bold, Colors.black),
            ],
          ),
          SizedBox(
            height: height*0.6,
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: height*0.015),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){return UserProfil(height: height, width: width, user: friends[index], onTap: () {Navigator.of(context).pop();}, owner: false, friend: true, sent: false);}));
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: width*0.03,left: width*0.03),
                      height: height*0.1,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(height*0.013),
                        border: Border.all(width: 0.7,color: Colors.grey.withOpacity(0.5))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Transform.scale(scale: 0.8,child: ClipRRect(borderRadius: BorderRadius.circular(height),child: Image.asset(friends[index]['avatar'],))),
                          SizedBox(width: width*0.03,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              subTitle(friends[index]['username'], height*0.023, Colors.black),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  subParagraph(friends[index]['country'], height*0.015, Colors.black),
                                  subParagraph(', ${friends[index]['city']}', height*0.015, Colors.black),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}

class MainProfilePage extends StatelessWidget {
  const MainProfilePage({
    super.key,
    required this.user,
    required this.height,
    required this.width,
    required this.show4,
    required this.show1,
    required this.showP,
    required this.overlay,
  });

  final Map<String, dynamic> user;
  final double height;
  final double width;
  final VoidCallback show4;
  final VoidCallback show1;
  final VoidCallback showP;
  final bool overlay;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: height*0.5,
            width: width,
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.025), topLeft: Radius.circular(height*0.025), bottomRight: Radius.circular(height*0.041), bottomLeft: Radius.circular(height*0.041)),
              image: DecorationImage(image: AssetImage('assets/images/profileBackground.png'),fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: height*0.015),
                  child: Container(
                    alignment: Alignment.center,
                    height: height*0.25,
                    width: height*0.25,
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
                    child: ClipRRect(borderRadius: BorderRadius.circular(height),child: Image.asset(user['avatar'],fit: BoxFit.contain,height: height*0.24,width: height*0.24,)),
                  ),
                ),
                MyTitle(user['name'], height*0.033, FontWeight.w600, Colors.white),
                Padding(
                  padding: EdgeInsets.only(bottom: height*0.015),
                  child: Paragraph('@${user['username']}', height*0.019, Colors.white, 1),
                ),
                GestureDetector(
                  onTap: showP,
                  child: Padding(
                    padding: EdgeInsets.only(top: height*0.0),
                    child: SubmitButton(height*0.055, width*0.3, 'Voir le profil', height*0.017),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: show1,
            child: Padding(
              padding: EdgeInsets.only(top: height*0.02,bottom: height*0.015,right: width*0.05,left: width*0.05),
              child: Container(
                padding: EdgeInsets.only(right: width*0.03,left: width*0.03),
                height: height*0.085,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height*0.013),
                  border: Border.all(width: 0.7,color: Colors.grey.withOpacity(0.5))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: height*0.07,
                      width: height*0.07,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: HexColor('243ADC').withOpacity(0.05)
                      ),
                      child: Transform.scale(scale: 0.35,child: Image.asset('assets/icons/users 2.png',)),
                    ),
                    Expanded(flex: 1,child: SizedBox(width: 1,)),
                    subTitle('Mon réseau', height*0.021, Colors.black),
                    Expanded(flex: 3,child: SizedBox(width: 1,)),
                    Icon(Icons.arrow_forward_ios_outlined,size: height*0.02,color: Colors.black,),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: height*0.015,right: width*0.05,left: width*0.05),
            child: Container(
              padding: EdgeInsets.only(right: width*0.03,left: width*0.03),
              height: height*0.085,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height*0.013),
                border: Border.all(width: 0.7,color: Colors.grey.withOpacity(0.5))
              ),
              child: Row(
                children: [
                  Container(
                    height: height*0.07,
                    width: height*0.07,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HexColor('243ADC').withOpacity(0.05)
                    ),
                    child: Transform.scale(scale: 0.35,child: Image.asset('assets/icons/chat-user.png',)),
                  ),
                  Expanded(flex: 1,child: SizedBox(width: 1,)),
                  subTitle('ConversaTions', height*0.021, Colors.black),
                  Expanded(flex: 3,child: SizedBox(width: 1,)),
                  Icon(Icons.arrow_forward_ios_outlined,size: height*0.02,color: Colors.black,),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              //await FirebaseAuth.instance.currentUser!.updateProfile(displayName:'sissinou');
              //await FirebaseAuth.instance.currentUser!.reload();
              //Future.delayed(Duration(seconds: 1), () {
              //  print(FirebaseAuth.instance.currentUser!.displayName);
              //});
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: height*0.015,right: width*0.05,left: width*0.05),
              child: Container(
                padding: EdgeInsets.only(right: width*0.03,left: width*0.03),
                height: height*0.085,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height*0.013),
                  border: Border.all(width: 0.7,color: Colors.grey.withOpacity(0.5))
                ),
                child: Row(
                  children: [
                    Container(
                      height: height*0.07,
                      width: height*0.07,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: HexColor('243ADC').withOpacity(0.05)
                      ),
                      child: Transform.scale(scale: 0.35,child: Image.asset('assets/icons/collection.png',)),
                    ),
                    Expanded(flex: 1,child: SizedBox(width: 1,)),
                    subTitle('Mes applications', height*0.021, Colors.black),
                    Expanded(flex: 3,child: SizedBox(width: 1,)),
                    Icon(Icons.arrow_forward_ios_outlined,size: height*0.02,color: Colors.black,),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: show4,
            child: Padding(
              padding: EdgeInsets.only(bottom: height*0.015,right: width*0.05,left: width*0.05),
              child: Container(
                padding: EdgeInsets.only(right: width*0.03,left: width*0.03),
                height: height*0.085,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height*0.013),
                  border: Border.all(width: 0.7,color: Colors.grey.withOpacity(0.5))
                ),
                child: Row(
                  children: [
                    Container(
                      height: height*0.07,
                      width: height*0.07,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: HexColor('243ADC').withOpacity(0.05)
                      ),
                      child: Transform.scale(scale: 0.35,child: Image.asset('assets/icons/user-circle-add_profile.png',)),
                    ),
                    Expanded(flex: 1,child: SizedBox(width: 1,)),
                    subTitle('Mes invitations', height*0.021, Colors.black),
                    Expanded(flex: 3,child: SizedBox(width: 1,)),
                    Icon(Icons.arrow_forward_ios_outlined,size: height*0.02,color: Colors.black,),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              if(overlay) {
                Navigator.of(context).pop();
              }
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: height*0.09,right: width*0.05,left: width*0.05),
              child: Container(
                padding: EdgeInsets.only(right: width*0.03,left: width*0.03),
                height: height*0.085,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height*0.013),
                  border: Border.all(width: 0.7,color: Colors.grey.withOpacity(0.5))
                ),
                child: Row(
                  children: [
                    Container(
                      height: height*0.07,
                      width: height*0.07,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: HexColor('243ADC').withOpacity(0.05)
                      ),
                      child: Icon(Icons.logout_outlined,size: height*0.023,color: mainColor,),
                    ),
                    Expanded(flex: 1,child: SizedBox(width: 1,)),
                    subTitle('Déconnecter', height*0.021, Colors.black),
                    Expanded(flex: 3,child: SizedBox(width: 1,)),
                    Icon(Icons.arrow_forward_ios_outlined,size: height*0.02,color: Colors.black,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}