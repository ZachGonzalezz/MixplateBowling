import 'package:flutter/material.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_brain.dart';


class SettingSelectionTile extends StatelessWidget {
 SettingSelectionTile({ Key? key, required this.title, required this.navigateTo, required this.brain }) : super(key: key);

String title;
String navigateTo;
SettingsBrain brain;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.2, 20, MediaQuery.of(context).size.width * 0.2, 20),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(width: 0.75)
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              IconButton(onPressed: (){
                Navigator.pushNamed(context, navigateTo, arguments: brain);
              }, icon: const Icon(Icons.chevron_right_rounded))
            ],
          ),
          
        ),
      ),
    );
  }
}