import 'package:flutter/material.dart';
import 'package:lois_bowling_website/NavigationBar/navigation_bar.dart';

class ScreenLayout extends StatelessWidget {
  ScreenLayout(
      {Key? key, required this.selected, required this.child, this.height = 0})
      : super(key: key);

  String selected;
  Widget child;
  double height;

  @override
  Widget build(BuildContext context) {
    if (height == 0) {
      height = MediaQuery.of(context).size.height;
    }
    return SingleChildScrollView(
      child: SizedBox(
        height: height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned.fill(
                left: MediaQuery.of(context).size.width * 0.15,
                child: Image.asset(
                  'images/background.png',
                  fit: BoxFit.fill,
                )),
            CustomNavigationBar(
              selected: selected,
            ),
            Positioned.fill(
                left: MediaQuery.of(context).size.width * 0.15,
                child: SizedBox(
                  child: child,
                ))
          ],
        ),
      ),
    );
  }
}
