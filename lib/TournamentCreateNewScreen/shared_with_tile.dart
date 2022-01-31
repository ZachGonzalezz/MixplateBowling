import 'package:flutter/material.dart';
import 'package:lois_bowling_website/LoginScreen/circle_avatar.dart';

class ShareWithTile extends StatelessWidget {
  ShareWithTile({ Key? key, required this.email, required this.removeEmail }) : super(key: key);
  String email;
  VoidCallback removeEmail;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(10)
      ),

      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
       children: [
         Row(
           children:  [
               CustomCircleAvatar(radius: 20, iconSize: 25,),
         Text(email, style:   const  TextStyle(fontSize: 18, fontWeight: FontWeight.w700),)
           ],
         ),

         IconButton(onPressed: removeEmail, icon: const Icon(Icons.close, color: Colors.red,))


       ], 
      ),
      
    );
  }
}