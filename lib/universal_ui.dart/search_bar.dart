import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomSearchBar extends StatelessWidget {
  CustomSearchBar({Key? key, required this.backTo, required this.onChange})
      : super(key: key);

  String backTo;
  Function(String) onChange;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, backTo);
            },
            icon: Icon(MdiIcons.chevronLeft)),
        Expanded(
          flex: 2,
          child: TextField(
            onChanged: onChange,
            decoration: InputDecoration(
                prefixIcon: Icon(MdiIcons.magnify), hintText: "Search....",
                fillColor: Colors.grey[200],
                filled: true),
                
          ),
        )
      ],
    );
  }
}
