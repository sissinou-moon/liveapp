import 'package:flutter/material.dart';
import 'package:launcher/components/tools.dart';

class LiveSessions extends StatefulWidget {
  const LiveSessions({super.key});

  @override
  State<LiveSessions> createState() => _LiveSessionsState();
}

class _LiveSessionsState extends State<LiveSessions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 100,),
          MyTitle('LiveSession', 31, FontWeight.bold, Colors.black)
        ],
      ),
    );
  }
}