import 'package:flutter/material.dart';

class NameTile extends StatelessWidget {
  NameTile({required this.name});

  String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Color.fromRGBO(78, 239, 238, .5),
        border: Border(
          right: BorderSide(width: 1),
          bottom: BorderSide(width: 1)
        )

      ),
      child: Center(child: Text(name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20))),
      
    );
  }
}