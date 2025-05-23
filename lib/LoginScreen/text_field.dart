import 'package:flutter/material.dart';



// ignore: must_be_immutable
class TextFieldCustom extends StatelessWidget {
  TextFieldCustom({
    required this.ontyped,
    key,
    this.hintText,
    this.leftIcon,
    this.validator,
    this.onFieldSubmitted,
  }) : super(key: key);

  String? hintText;
  Icon? leftIcon;
  Function(String)? ontyped; // Make ontyped optional
  String? Function(String?)? validator;
  Function(String)? onFieldSubmitted; // Add onFieldSubmitted property
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: TextField(
          onSubmitted: onFieldSubmitted,
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
