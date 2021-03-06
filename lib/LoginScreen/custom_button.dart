import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/constants.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
   CustomButton({ Key? key, required this.buttonTitle, required this.onClicked, this.length =  0,}) : super(key: key);

  String buttonTitle;
  VoidCallback onClicked;
  double length = 0;
  @override

  Widget build(BuildContext context) {
     if(length == 0){
    length = MediaQuery.of(context).size.width * 0.4;
  }
    return TextButton(
      onPressed: onClicked,
      child: Container(
             width: length,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: Constants.mainGradient
        ),
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Center(child: Text(buttonTitle, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),)),
      ),
      
    );
  }
}