import 'package:flutter/material.dart';
import 'package:lois_bowling_website/constants.dart';

class SquadPicker extends StatefulWidget {
  SquadPicker({ Key? key }) : super(key: key);

  @override
  State<SquadPicker> createState() => _SquadPickerState();
}

class _SquadPickerState extends State<SquadPicker> {
  String selected = 'A';
  @override
  Widget build(BuildContext context) {
    return Container(
      

      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(20)
      ),

      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: DropdownButton(
            underline: null,
            elevation: 0,
            onChanged: (String? value){
              setState(() {
                selected = value!;
              });
            },
            value: 'Squad '+ selected,
            items:  Constants.squads
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: 'Squad '+ value,
            child: Text( 'Squad '+ value),
          );
              }).toList(),
          ),
        )
        // Text('Squad A', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),),
      ),
      
    );
  }
}