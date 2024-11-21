import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:gradient_textfield/gradient_textfield.dart';
import 'package:hexcolor/hexcolor.dart';

final Color mainColor = HexColor('002058');
final Color secondColor = HexColor('2128F5');

Text MyTitle(String content, double size, FontWeight fontWeight, Color color) {
  return Text(
    content,
    style: TextStyle(
      fontSize: size,
      fontFamily: 'bold',
      fontWeight: fontWeight,
      color: color,
    ),
  );
}

Text subTitle(String content, double size, Color color) {
  return Text(
    content,
    style: TextStyle(
      fontSize: size,
      fontFamily: 'bold',
      fontWeight: FontWeight.w600,
      color: color,
    ),
  );
}

Text Paragraph(String content, double size, Color color, int lines) {
  return Text(
    content,
    style: TextStyle(
      fontSize: size,
      fontFamily: 'bold',
      fontStyle: FontStyle.normal,
      color: color,
      overflow: TextOverflow.ellipsis
    ),
    maxLines: lines,
  );
}

Text subParagraph(String content, double size, Color color) {
  return Text(
    content,
    style: TextStyle(
      fontSize: size,
      fontFamily: 'bold',
      fontWeight: FontWeight.w200,
      color: color,
    ),
  );
}

EdgeInsets mainPadding(double width, double height) {
  return EdgeInsets.only(
      right: width * 0.05, top: height * 0.02, left: width * 0.05);
}

Widget SubmitButton(double height, double width, String content, contentSize) {
  return Container(
    alignment: Alignment.center,
    height: height,
    width: width,
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [
        HexColor('1726C5'),
        HexColor('1726C5'),
        HexColor('4147FA').withOpacity(0.8),
      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      borderRadius: BorderRadius.circular(100),
      border: GradientBoxBorder(
        gradient: LinearGradient(
            colors: [HexColor('4147FA'), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
        width: 2,
      ),
    ),
    child: Paragraph(content, contentSize, Colors.white, 1),
  );
}

Widget subButton(double height, double width, String content, contentSize) {
  return Container(
    alignment: Alignment.center,
    height: height,
    width: width,
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [
        Colors.white.withOpacity(0.25).withOpacity(0.12),
        Colors.white.withOpacity(0.33).withOpacity(0.15),
      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      borderRadius: BorderRadius.circular(100),
      border: GradientBoxBorder(
        gradient: LinearGradient(colors: [
          Colors.white.withOpacity(0.31),
          Colors.white.withOpacity(0.29),
          Colors.transparent
        ], begin: Alignment.topCenter, end: Alignment.bottomLeft),
        width: 2,
      ),
    ),
    child: Paragraph(content, contentSize, Colors.white, 1),
  );
}

Widget infoButton(double height, double width, String content, contentSize) {
  return Container(
    alignment: Alignment.center,
    height: height,
    width: width,
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [
        Colors.white.withOpacity(0.36),
        Colors.white.withOpacity(0.36),
        Colors.white.withOpacity(0.23),
      ], begin: Alignment.topCenter, end: Alignment.bottomLeft),
      borderRadius: BorderRadius.circular(100),
      border: GradientBoxBorder(
        gradient: LinearGradient(
            colors: [HexColor('64748B'), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
        width: 2,
      ),
    ),
    child: Paragraph(content, contentSize, Colors.white, 1),
  );
}

InputDecoration LogTextField(height, width, text) {
  return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      hintText: text,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
      border: GradientOutlineInputBorder(
        borderRadius: BorderRadius.circular(height*0.011),
        gradient: LinearGradient(colors: [
          Colors.white.withOpacity(0.27),
          Colors.white.withOpacity(0.21),
          Colors.white.withOpacity(0.07),
        ], begin: Alignment.topCenter, end: Alignment.bottomLeft),
        width: 2,
      ),
    );
}

InputDecoration PasswordTextField(height, width, onTap) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white.withOpacity(0.1),
    hintText: 'Mot De Passe',
    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
    border: GradientOutlineInputBorder(
      borderRadius: BorderRadius.circular(height*0.011),
      gradient: LinearGradient(colors: [
        Colors.white.withOpacity(0.27),
        Colors.white.withOpacity(0.21),
        Colors.white.withOpacity(0.07),
      ], begin: Alignment.topCenter, end: Alignment.bottomLeft),
      width: 2,
    ),
    suffixIcon: GestureDetector(onTap: onTap,child: Icon(Icons.remove_red_eye_outlined,size: height*0.027,color: Colors.white.withOpacity(0.3),))
  );
}

Widget OffButton(double height, double width, String content, contentSize) {
  return Container(
    alignment: Alignment.center,
    height: height,
    width: width,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          HexColor('64748B').withOpacity(0.36),
          HexColor('64748B').withOpacity(0.19)
        ], 
        begin: Alignment.topCenter, 
        end: Alignment.bottomLeft
      ),
      borderRadius: BorderRadius.circular(100),
      border: GradientBoxBorder(
        gradient: LinearGradient(
            colors: [HexColor('64748B').withOpacity(0.41), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
        width: 2,
      ),
    ),
    child: Paragraph(content, contentSize, Colors.white.withOpacity(0.3), 1),
  );
}