import 'package:flutter/material.dart';

class BasicPopUp extends StatelessWidget {
  BasicPopUp({Key? key, this.text}) : super(key: key);
  String? text;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.5,
        child: ListView(
          children: [
            Text(text ?? ''),
          ],
        ),
      ),
    );
  }

  void showBasicDialog(BuildContext context, String text) {
    showDialog(
        context: context,
        builder: (context) => BasicPopUp(
              text: text,
            ));
  }
}
