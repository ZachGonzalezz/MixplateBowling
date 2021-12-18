import 'package:flutter/material.dart';


class BasicPopUp extends StatelessWidget {
  BasicPopUp({ Key? key, required this.text }) : super(key: key);
  String text;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(text),
      
    );
  }

  void showBasicDialog(BuildContext context, String text) {
    showDialog(context: context, builder: (context) => BasicPopUp(text: text,));

  }
}