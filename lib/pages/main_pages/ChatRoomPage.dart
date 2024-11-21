import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:launcher/components/tools.dart';
import 'package:shimmer/shimmer.dart';

class ChatRoomPage extends StatefulWidget {
  final friendData;
  final VoidCallback onTap;
  ChatRoomPage({super.key, required this.friendData, required this.onTap});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {

  TextEditingController message = TextEditingController();
  final scrollController = ScrollController();

  late DatabaseReference messagesRef;

  bool istyping = false;

  final DatabaseReference contactsRef = FirebaseDatabase.instance.ref("contacts").child(FirebaseAuth.instance.currentUser!.uid);

  @override
  void initState() {
    super.initState();

    messagesRef = FirebaseDatabase.instance.ref("contacts/${FirebaseAuth.instance.currentUser!.uid}/${widget.friendData['id']}/messages");
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width; 

    return ClipRRect(
      borderRadius: BorderRadius.circular(height*0.025),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: height*0.07,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              SizedBox(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('Users').doc(widget.friendData['id']).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text("Error fetching user data"));
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(child: Text("User not found"));
                    }
                    final userData = snapshot.data!.data()! as Map;
                    return Row(
                      children: [
                        AdvancedAvatar(
                          decoration: BoxDecoration(
                            color: Colors.transparent
                          ),
                          size: height*0.07,
                          statusColor: userData['status'] == 'Online' ? Colors.green : Colors.grey,
                          statusAlignment: Alignment(0.7,-0.6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(height),
                            child: Image.asset(widget.friendData['avatar'],height: height*0.06,),
                          ),
                        ),
                        SizedBox(
                          width: width*0.03,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            subTitle(widget.friendData['with'], height*0.025, Colors.black),
                            Paragraph(userData['status'] == 'Online' ? 'Online' : 'Offline', height*0.013, userData['status'] == 'Online' ? Colors.green : Colors.grey, 1),
                          ],
                        )
                      ],
                    );
                  }
                ),
              ),
            ],
          ),
          elevation: 1,
          leading: IconButton(
            onPressed: widget.onTap, 
            icon: Icon(Icons.arrow_back_ios_new_outlined,size: height*0.021,color: Colors.black,)
          ),
        ),
        body: Container(
          height: height,
          width: width,
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<DatabaseEvent>(
                    stream: messagesRef.onValue,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                        return Column(
                          children: [
                            SizedBox(height: height*0.05,),
                            Image.asset('assets/images/empty_chat.png',height: height*0.25,),
                            subTitle("Aucun message pour l'instant...", height*0.023, Colors.black),
                            SizedBox(
                              width: width*0.7,
                              child: Text(
                                'Envoyez un message ou répondez avec un autocollant de vœux',
                                style: TextStyle(
                                  fontSize: height*0.016,
                                  fontFamily: 'bold',
                                  fontWeight: FontWeight.w200,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      } else {
                        final List messageList =
                            snapshot.data!.snapshot.value as List;
                        return Padding(
                          padding: EdgeInsets.only(right: width*0.05,left: width*0.05,top: height*0.02),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ListView.builder(
                              itemCount: messageList.length,
                              physics: BouncingScrollPhysics(),
                              reverse: true,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final m = messageList.reversed.toList();
                                final message = m[index];
                                                      
                                // Calculate text width using TextPainter
                                final textStyle = TextStyle(fontSize: 16, color: Colors.white);
                                final textSpan = TextSpan(text: message['content'], style: textStyle);
                                final textPainter = TextPainter(
                                  text: textSpan,
                                  textDirection: TextDirection.ltr,
                                );
                                textPainter.layout();
                                                
                                // Add some padding to the width
                                double messageWidth = textPainter.size.width + 30;
                                                      
                                if(message['sender'] == widget.friendData['id']) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: height*0.01,right: width*0.05),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(height*0.01),
                                          width: messageWidth > width*0.5 ? width*0.5 : messageWidth,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                HexColor('1726C5').withOpacity(0.1),
                                                HexColor('4147FA').withOpacity(0.1),
                                              ]
                                            ),
                                            borderRadius: BorderRadius.circular(height*0.013),
                                          ),
                                          child: Text(
                                            message['content'],
                                            style: TextStyle(
                                              fontSize: height*0.019,
                                              fontFamily: 'bold',
                                              fontWeight: FontWeight.w200,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }else {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: height*0.01,left: width*0.05),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(height*0.01),
                                          width: messageWidth > width*0.5 ? width*0.5 : messageWidth,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                HexColor('1726C5'),
                                                HexColor('4147FA'),
                                              ]
                                            ),
                                            borderRadius: BorderRadius.circular(height*0.013),
                                          ),
                                          child: Text(
                                            message['content'],
                                            style: TextStyle(
                                              fontSize: height*0.019,
                                              fontFamily: 'bold',
                                              fontWeight: FontWeight.w200,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: width*0.03,bottom: height*0.01),
                height: height*0.09,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 235, 235, 235).withOpacity(0.5),
                      blurRadius: 13,
                      spreadRadius: 1,
                      offset: Offset(0, -1),
                    )
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height*0.06,
                      width: width*0.8,
                      child: TextField(
                        controller: message,
                        decoration: InputDecoration(
                          hintText: 'Message..',
                          hintStyle: TextStyle(
                            fontFamily: 'bold',
                            fontWeight: FontWeight.w200,
                            fontSize: height*0.015
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(height),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: mainColor.withOpacity(0.1),
                          suffixIcon: IconButton(onPressed: () {}, icon: Image.asset('assets/icons/images.png',height: height*0.027,color: const Color.fromARGB(255, 109, 109, 109),)),
                        ),
                      ),
                    ),
                    SizedBox(width: width*0.03,),
                    GestureDetector(
                      onTap: () {
                        if(message.text.isNotEmpty) {
                          sendMessage();
                        }
                      },
                      child: AnimatedOpacity(
                        opacity: 1,
                        duration: Duration(milliseconds: 300),
                        child: Container(
                          alignment: Alignment.center,
                          height: height*0.05,
                          width: height*0.05,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                HexColor('1726C5'),
                                HexColor('4147FA'),
                              ]
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/sent.png',height: height*0.027,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage() async {
    try {
      // Fetch the current messages
      final snapshot = await messagesRef.get();
      final friendRef = await FirebaseDatabase.instance.ref('contacts').child(widget.friendData['id']).child(FirebaseAuth.instance.currentUser!.uid);

      int newId = 0; // Default ID for the first message

      // Check if the snapshot exists
      if (snapshot.exists) {
        // Check if the data is a List
        if (snapshot.value is List) {
          final messages = snapshot.value as List<dynamic>;

          // Use the length of the list to get the new ID (messages are indexed)
          newId = messages.length; // Increment ID by the list's length
        } else {
          print("Data is not a list");
          return;
        }
      }

      // Create the new message data
      final newMessage = {
        "sender": FirebaseAuth.instance.currentUser!.uid,
        "receiver": widget.friendData['id'],
        "content": message.text,
        "date": DateTime.now().toString().split(" ")[0],
        "time": TimeOfDay.now().format(context),
      };

      // Push the message with the new incremented ID
      await messagesRef.child(newId.toString()).set(newMessage);
      await friendRef.child('messages').child(newId.toString()).set(newMessage);

      // Update the contact's state to 'Message envoyé'
      final contactRef = contactsRef.child(widget.friendData['id']);
      await contactRef.update({
        "state": "Message envoyé", // Set the state to "Message envoyé"
      });

      setState(() {
        message.clear(); // Clear the input field after sending
      });
      // Move the scroll position to the bottom
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } catch (error) {
      print("Failed to send message: $error");
    }
  }
}