import 'package:flutter/material.dart';

class SpecialTextField extends StatelessWidget {
 SpecialTextField({Key? key, required this.item, required this.controller}) : super(key: key);

  String item;
  TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item, textAlign: TextAlign.left,),
       const  SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.23,
          child: TextField(
            
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ),
      ],
    );
  }
}
