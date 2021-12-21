import 'package:flutter/material.dart';

class HeadTile extends StatelessWidget {
  HeadTile({required this.index});

  int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(78, 239, 238, .5),
        border: Border(
          right: BorderSide(width: 1),
          bottom: BorderSide(width: 1)
        )

      ),
      child: Center(child: Text(index == 0 ? 'Name' : 'Game' + index.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20))),
      
    );
  }
}