import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldCustom extends StatelessWidget {
 TextFieldCustom({ required this.ontyped, key, this.hintText,  this.leftIcon}) : super(key: key);

  String? hintText;
  Icon? leftIcon;
  Function(String) ontyped;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: TextField(
          onChanged: ontyped,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: leftIcon,
            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
          
          ),
        ),
        
        
      ),
    );
  }
}