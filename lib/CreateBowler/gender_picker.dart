import 'package:flutter/material.dart';
import 'package:lois_bowling_website/CreateBowler/create_bowler_brain.dart';
import 'package:lois_bowling_website/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GenderPicker extends StatefulWidget {
  GenderPicker({ Key? key, required this.isMale, required this.brain, required this.valueChanged }) : super(key: key);

  bool isMale;
  CreateBowlerBrain brain;
  VoidCallback valueChanged;

  @override
  _GenderPickerState createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  Color selectedColor = Constants.lightBlue.withOpacity(0.6);
  @override
  Widget build(BuildContext context) {
    Color selectedColor = Constants.lightBlue.withOpacity(0.6);

    if(widget.brain.isMale == true && widget.isMale == true) {
      selectedColor = Colors.white;
    }
    if(widget.brain.isMale == false && widget.isMale == false){
      selectedColor = Colors.white;
    }

    return GestureDetector(
      onTap: (){
         widget.valueChanged();
       
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selectedColor
        ),
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(

            widget.isMale ?  MdiIcons.genderMale: MdiIcons.genderFemale,
            size: 40,
            color: widget.isMale ? Colors.blue : Colors.pink,
              ),
              SizedBox(
                height: 10,
              ),
              Text(widget.isMale ? 'Male' : 'Female')
          ],
        ),
        
      ),
    );
  }
}