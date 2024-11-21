import 'package:flutter/material.dart';
import 'package:launcher/components/tools.dart';

class SuccessfullyChangePasswordPage extends StatefulWidget {
  const SuccessfullyChangePasswordPage({super.key});

  @override
  State<SuccessfullyChangePasswordPage> createState() => _SuccessfullyChangePasswordPageState();
}

class _SuccessfullyChangePasswordPageState extends State<SuccessfullyChangePasswordPage> {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width; 

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/Lunche.png'),fit: BoxFit.cover)
        ),
        child: Padding(
          padding: mainPadding(width, height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: height*0.01),
                child: Image.asset('assets/images/itemChangePassword.png'),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: height*0.03),
                child: MyTitle('vous avez changé votre mot de passe avec succès', height*0.023, FontWeight.w600, Colors.white),
              ),
              Padding(
                padding: EdgeInsets.only(top: height*0.03),
                child: SubmitButton(height*0.065, width, 'Connecter', height*0.019),
              ),
            ],
          ),
        ),
      ),
    );
  }
}