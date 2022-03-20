import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/responsive.dart';

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
        padding:EdgeInsets.all(Responsive.isMobile(context) ? 0 : 8.0),
        child: Icon(Icons.account_circle_sharp, size: iconSize, color: Colors.grey,),
      ),
      
    );
  }
}