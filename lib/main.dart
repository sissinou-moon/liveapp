import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:launcher/components/tools.dart';
import 'package:launcher/pages/CreateAccountPage.dart';
import 'package:launcher/pages/LoginPage.dart';
import 'package:launcher/pages/main_pages/SourcePage.dart';
import 'package:launcher/providers/animateNavBarProvider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => AnimationProvider(),
      child: const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Livepulp',
      debugShowCheckedModeBanner: false,
      home: const FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width; 

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SourcePage(overlay: false,);
        
          } else {
            return Container(
            padding: EdgeInsets.only(top: height*0.05),
            height: height,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/Lunche.png'),fit: BoxFit.cover)
            ),
            child: Stack(
              children: [
                Image.asset('assets/images/wepik-export-20240107094944RIlK 1.png'),
                Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        HexColor('0E1A7F').withOpacity(0.8),
                        HexColor('0E1A7F'),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: mainPadding(width, height),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: height*0.015,bottom: height*0.025),
                            child: Row(
                              children: [
                                Image.asset('assets/icons/appi.png',height: height*0.041,width: height*0.041,),
                                SizedBox(width: width*0.03,),
                                MyTitle('LivePulp', height*0.023, FontWeight.w700, Colors.white),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: height*0.015,bottom: height*0.025),
                            child: MyTitle('Commencez à Collaborer dès maintenant', height*0.049, FontWeight.w300, Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {return CreateAccountPage();}));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: height*0.015,bottom: height*0.01),
                              child: SubmitButton(height*0.065,width*0.8,'Créer Votre Compte',height*0.019),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {return Loginpage();}));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: height*0.015,bottom: height*0.015),
                              child: subButton(height*0.065,width*0.8,'Se Connecter',height*0.019),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: height*0.15,bottom: height*0.055),
                            child: infoButton(height*0.065,width*0.8,'Comment fonctionne Livepulp',height*0.019),
                          ),
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
      ),
    );
  }
}