import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:launcher/components/tools.dart';
import 'package:launcher/pages/main_pages/ProfilePage.dart';
import 'package:lottie/lottie.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> with TickerProviderStateMixin {

  final TextEditingController _searchController = TextEditingController();

  late AnimationController animateController1;

  int Index = 0;

  bool show = false;

  Map user = {};

  bool friend = false;

  void showInshow() {
    if(show) {
      animateController1.reverse();
      Future.delayed(Duration(milliseconds: 200), () {
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

  @override
  void initState() {
    super.initState();

    animateController1 = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width; 

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.025),topLeft: Radius.circular(height*0.025)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: mainPadding(width, height),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: height*0.02,),
                  Padding(
                    padding: EdgeInsets.only(top: height*0.02),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Que souhaitez-vous faire aujourd'hui ?",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'bold',
                          fontSize: height*0.017,
                          fontWeight: FontWeight.w200
                        ),
                       border: GradientOutlineInputBorder(
                          borderRadius: BorderRadius.circular(height*0.011),
                          gradient: LinearGradient(colors: [
                            Colors.grey.withOpacity(0.7),
                            Colors.grey.withOpacity(0.7),
                          ]),
                          width: 0.7,
                        ),
                        prefixIcon: Icon(Icons.search_outlined,size: height*0.023,),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height*0.02),
                    child: SizedBox(
                      height: height*0.045,
                      width: width,
                      child: ListView.builder(
                        itemCount: 4,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                Index = index;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: width*0.02),
                              child: Container(
                                alignment: Alignment.center,
                                height: height*0.04,
                                width: width*0.31,
                                decoration: BoxDecoration(
                                  color: Index == index ? HexColor('#1726C5') : HexColor('#E2ECF5'),
                                  borderRadius: BorderRadius.circular(height*0.01),
                                ),
                                child: Paragraph(index == 0 ? 'Toutes les activités' : index == 1 ? 'Les invitations' : index == 2 ? 'Les collaborations' : 'Les jeux', height*0.015, Index == index ? Colors.white : Colors.black, 1),
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: EdgeInsets.only(top: height*0.15),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Center(child: Text("No data available"));
                      }
                    
                      // Access the 'news' field from the document
                      final data = snapshot.data!.data() as Map<String, dynamic>;
                      final List<dynamic> news = data['news'] ?? [];
                    
                      if (news.isEmpty) {
                        return Center(child: Lottie.asset('assets/animations/empty_news.json'));
                      }
                    
                      return SizedBox(
                        height: height*0.7,
                        child: ListView.builder(
                          itemCount: news.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if(Index == 0) {
                              if(news[index]['type'] == 'friendRequest') {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      user = news[index]['from'];
                                      friend = true;
                                    });
                                    showInshow();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: height*0.02),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(right: width*0.03,left: width*0.03),
                                      height: height*0.13,
                                      width: width,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 0.4,color: Colors.black38),
                                        borderRadius: BorderRadius.circular(height*0.013),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: width*0.02),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(height),
                                              child: Image.asset(news[index]['from']['avatar'],height: height*0.09,),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: width*0.02),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                subTitle(news[index]['from']['name'], height*0.023, Colors.black),
                                                SizedBox(
                                                  width: width*0.6,
                                                  child: Paragraph('@${news[index]['from']['username']} vous a envoyé une invitation', height*0.017, Colors.black87,2)
                                                ),
                                                subParagraph(news[index]['date'], height*0.013, Colors.black54)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }else {
                                if(news[index]['collaborationType'].contains('Jeux vidéo en ligne') || news[index]['collaborationType'].contains('Jeux de société virtuels') || news[index]['collaborationType'].contains('Jeux de réflexion') || news[index]['collaborationType'].contains('Jeux de rôle') || news[index]['collaborationType'].contains('Jeux créatifs et collaboratifs')) {
                                  return GestureDetector(
                                    onTap: () {
                                      //setState(() {
                                      //  user = news[index]['from'];
                                      //  friend = true;
                                      //});
                                      //showInshow();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: height*0.02),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(right: width*0.03,left: width*0.03),
                                        height: height*0.19,
                                        width: width,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 0.4,color: Colors.black38),
                                          borderRadius: BorderRadius.circular(height*0.013),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(right: width*0.02),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(height),
                                                child: Image.asset(news[index]['from']['avatar'],height: height*0.09,),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(right: width*0.02),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  subTitle(news[index]['from']['name'], height*0.023, Colors.black),
                                                  SizedBox(
                                                    width: width*0.4,
                                                    child: Paragraph('@${news[index]['from']['username']} vous a envoyé une invitation a jouer ${news[index]['liveApp'][0]['item']}', height*0.017, Colors.black87,4)
                                                  ),
                                                  SizedBox(
                                                    height: height*0.01,
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: height*0.035,
                                                    width: width*0.25,
                                                    decoration: BoxDecoration(
                                                      color: HexColor('#4147FA'),
                                                      borderRadius: BorderRadius.circular(height*0.013),
                                                    ),
                                                    child: subParagraph('Jouer', height*0.017, Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(right: width*0.02),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(height*0.013),
                                                    child: Image.network(news[index]['liveApp'][0]['avatar'],height: height*0.07,),
                                                  ),
                                                  SizedBox(height: height*0.03,),
                                                  subParagraph(news[index]['date'], height*0.013, Colors.black54)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            }else if(Index == 3) {
                              if(news[index]['type'] == 'collaboration') {
                                if(news[index]['collaborationType'].contains('Jeux vidéo en ligne') || news[index]['collaborationType'].contains('Jeux de société virtuels') || news[index]['collaborationType'].contains('Jeux de réflexion') || news[index]['collaborationType'].contains('Jeux de rôle') || news[index]['collaborationType'].contains('Jeux créatifs et collaboratifs')) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        user = news[index]['from'];
                                        friend = true;
                                      });
                                      showInshow();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: height*0.02),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(right: width*0.03,left: width*0.03),
                                        height: height*0.19,
                                        width: width,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 0.4,color: Colors.black38),
                                          borderRadius: BorderRadius.circular(height*0.013),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(right: width*0.02),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(height),
                                                child: Image.asset(news[index]['from']['avatar'],height: height*0.09,),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(right: width*0.02),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  subTitle(news[index]['from']['name'], height*0.023, Colors.black),
                                                  SizedBox(
                                                    width: width*0.4,
                                                    child: Paragraph('@${news[index]['from']['username']} vous a envoyé une invitation a jouer ${news[index]['liveApp'][0]['item']}', height*0.017, Colors.black87,4)
                                                  ),
                                                  SizedBox(
                                                    height: height*0.01,
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: height*0.035,
                                                    width: width*0.25,
                                                    decoration: BoxDecoration(
                                                      color: HexColor('#4147FA'),
                                                      borderRadius: BorderRadius.circular(height*0.013),
                                                    ),
                                                    child: subParagraph('Jouer', height*0.017, Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(right: width*0.02),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(height*0.013),
                                                    child: Image.network(news[index]['liveApp'][0]['avatar'],height: height*0.07,),
                                                  ),
                                                  SizedBox(height: height*0.03,),
                                                  subParagraph(news[index]['date'], height*0.013, Colors.black54)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }else {
                                  return Container();
                                }
                              }else {
                                return Container();
                              }
                            }else if(Index == 1) {
                              if(news[index]['type'] == 'friendRequest') {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      user = news[index]['from'];
                                      friend = true;
                                    });
                                    showInshow();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: height*0.02),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(right: width*0.03,left: width*0.03),
                                      height: height*0.13,
                                      width: width,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 0.4,color: Colors.black38),
                                        borderRadius: BorderRadius.circular(height*0.013),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: width*0.02),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(height),
                                              child: Image.asset(news[index]['from']['avatar'],height: height*0.09,),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: width*0.02),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                subTitle(news[index]['from']['name'], height*0.023, Colors.black),
                                                SizedBox(
                                                  width: width*0.6,
                                                  child: Paragraph('@${news[index]['from']['username']} vous a envoyé une invitation', height*0.017, Colors.black87,2)
                                                ),
                                                subParagraph(news[index]['date'], height*0.013, Colors.black54)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }else {
                              if(news[index]['type'] == 'collaboration') {
                                if(news[index]['collaborationType'].contains('Jeux vidéo en ligne') || news[index]['collaborationType'].contains('Jeux de société virtuels') || news[index]['collaborationType'].contains('Jeux de réflexion') || news[index]['collaborationType'].contains('Jeux de rôle') || news[index]['collaborationType'].contains('Jeux créatifs et collaboratifs')) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        user = news[index]['from'];
                                        friend = true;
                                      });
                                      showInshow();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: height*0.02),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(right: width*0.03,left: width*0.03),
                                        height: height*0.19,
                                        width: width,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 0.4,color: Colors.black38),
                                          borderRadius: BorderRadius.circular(height*0.013),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(right: width*0.02),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(height),
                                                child: Image.asset(news[index]['from']['avatar'],height: height*0.09,),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(right: width*0.02),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  subTitle(news[index]['from']['name'], height*0.023, Colors.black),
                                                  SizedBox(
                                                    width: width*0.4,
                                                    child: Paragraph('@${news[index]['from']['username']} vous a envoyé une invitation a jouer ${news[index]['liveApp'][0]['item']}', height*0.017, Colors.black87,4)
                                                  ),
                                                  SizedBox(
                                                    height: height*0.01,
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: height*0.035,
                                                    width: width*0.25,
                                                    decoration: BoxDecoration(
                                                      color: HexColor('#4147FA'),
                                                      borderRadius: BorderRadius.circular(height*0.013),
                                                    ),
                                                    child: subParagraph('Jouer', height*0.017, Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(right: width*0.02),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(height*0.013),
                                                    child: Image.network(news[index]['liveApp'][0]['avatar'],height: height*0.07,),
                                                  ),
                                                  SizedBox(height: height*0.03,),
                                                  subParagraph(news[index]['date'], height*0.013, Colors.black54)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }else {
                                  return Container();
                                }
                              }else {
                                return Container();
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          if(show) Animate(
            controller: animateController1,
            effects: [
              SlideEffect(
                begin: Offset(1, 0),
                end: Offset(0, 0),
              )
            ],
            child: UserProfil(height: height, width: width, user: user, onTap: showInshow, owner: false, friend: friend, sent: true)
          ),
        ],
      ),
    );
  }
}