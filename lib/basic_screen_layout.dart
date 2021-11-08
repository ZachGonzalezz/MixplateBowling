import 'package:flutter/material.dart';
import 'package:lois_bowling_website/NavigationBar/navigation_bar.dart';

class ScreenLayout extends StatelessWidget {
  ScreenLayout({ Key? key, required this.selected, required this.child }) : super(key: key);

  String selected;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
                height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width ,
          child: Stack(
          
            children: [
            
              Positioned.fill(
                left:  MediaQuery.of(context).size.width * 0.15,
                child: Image.asset('images/background.png', fit: BoxFit.fill,)),
                      NavigationBar(selected: selected,),
       
              Positioned.fill(
                left:  MediaQuery.of(context).size.width * 0.15,
             child : SizedBox(
                child: child,
              )
              )

      
            ],
      
          ),
        ),
      );
  }
}