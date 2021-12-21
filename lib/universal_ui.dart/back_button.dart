import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BackButton extends StatelessWidget {
  const BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: IconButton(
          onPressed: () {
            
            Navigator.pop(context);
          },
          icon: Icon(MdiIcons.chevronLeft)),
    );
  }
}
