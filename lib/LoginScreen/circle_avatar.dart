import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
 CustomCircleAvatar({ Key? key, this.radius = 80, this.iconSize = 100}) : super(key: key);
  double radius = 0;
  double iconSize = 0;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
   
      child:  Padding(
        padding:const EdgeInsets.all(8.0),
        child: Icon(Icons.account_circle_sharp, size: iconSize, color: Colors.grey,),
      ),
      
    );
  }
}