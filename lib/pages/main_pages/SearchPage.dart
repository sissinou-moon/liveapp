import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:launcher/components/tools.dart';
import 'package:launcher/pages/main_pages/ProfilePage.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin  {


  final TextEditingController _searchController = TextEditingController();

  late AnimationController animateController1;
  
  List<Map<String, dynamic>> _searchResults = [];

  Map User = {};

  bool show = false;


  bool _isLoading = false;

  // Function to fetch search results in real-time

  void _performSearch(String searchTerm) async {
    if (searchTerm.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch all users from Firestore
      final querySnapshot = await FirebaseFirestore.instance.collection('Users').get();

      // Filter results locally for case-insensitive match
      final results = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((user) => user['username']
              .toString()
              .toLowerCase()
              .contains(searchTerm.toLowerCase()))
          .toList();

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (error) {
      print("Error during search: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      duration: Duration(milliseconds: 300),
      vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width; 

    return ClipRRect(
      borderRadius: BorderRadius.circular(height*0.025),
      child: Container(
        height: height,
        width: width,
        color: Colors.white,
        child: Stack(
          children: [
            Padding(
              padding: mainPadding(width, height),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height*0.02,),
                  MyTitle('Collaborer maintenant', height*0.033, FontWeight.w500, Colors.black),
                  Padding(
                    padding: EdgeInsets.only(top: height*0.02),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => _performSearch(value),
                      decoration: InputDecoration(
                        hintText: 'Rechercher des collaborations pour...',
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
                  _searchResults.isEmpty ? Lottie.asset('assets/animations/search.json')
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final user = _searchResults[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: height*0.02),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    User = user;
                                  });
                                  showInshow();
                                },
                                child: Container(
                                  padding: EdgeInsets.only(right: width*0.03,left: width*0.03,top: height*0.02,bottom: height*0.02),
                                  height: height*0.21,
                                  width: width,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.5,color: Colors.black26),
                                    borderRadius: BorderRadius.circular(height*0.013)
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(height),
                                        child: Image.asset(user['avatar'],height: height*0.09,)
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: width*0.03),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            subTitle(user['name'], height*0.021, Colors.black),
                                            Padding(
                                              padding: EdgeInsets.only(bottom: height*0.01),
                                              child: subParagraph('@${user['username']}', height*0.013, Colors.black),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(bottom: height*0.01),
                                              child: SizedBox(
                                                width: width*0.57,
                                                child: Paragraph(user['bio'], height*0.015, Colors.black, 2)
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: height*0.01),
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: height*0.035,
                                                width: width*0.3,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(height*0.01),
                                                  color: HexColor('4147FA'),
                                                ),
                                                child: Paragraph('Voir le profil', height*0.015, Colors.white, 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
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
                )
              ],
              child: UserProfil(height: height, width: width, user: User, onTap: showInshow, owner: false, friend: false, sent: false)
            ),
          ],
        ),
      ),
    );
  }
}