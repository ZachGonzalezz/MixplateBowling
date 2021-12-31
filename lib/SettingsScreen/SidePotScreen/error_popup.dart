import 'package:flutter/material.dart';


class ErrorPopUp extends StatelessWidget {
 ErrorPopUp({ Key? key, required this.error }) : super(key: key);

  String error;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      title: Text(error),
      
    );
  }
}