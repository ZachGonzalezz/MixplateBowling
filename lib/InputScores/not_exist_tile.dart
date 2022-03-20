import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loisbowlingwebsite/CreateBowler/create_bowler_brain.dart';
import 'package:loisbowlingwebsite/CreateBowler/gender_picker.dart';
import 'package:loisbowlingwebsite/InputScores/bowlers_not_exist.dart';
import 'package:loisbowlingwebsite/InputScores/image_to_scores.dart';
import 'package:loisbowlingwebsite/bowler.dart';

class NotExistTile extends StatefulWidget {
  NotExistTile({Key? key, required this.bowler, required this.bowlerBrain, required this.index}) : super(key: key);

  Bowler bowler;
   BowlersThatDoNotExist bowlerBrain;
   int index;

  @override
  State<NotExistTile> createState() => _NotExistTileState();
}

class _NotExistTileState extends State<NotExistTile> {
  TextEditingController averageController = TextEditingController();
  ImageToScores imageToScoreBrain = ImageToScores();
  bool isMale = false;
  CreateBowlerBrain brain = CreateBowlerBrain();
  
  
  @override
  void initState() {
    super.initState();
    List<String> firstNameLastName =
        imageToScoreBrain.splitName(widget.bowler.firstName);

    widget.bowlerBrain.bowlers[widget.index].firstName = firstNameLastName[0];
        widget.bowlerBrain.bowlers[widget.index].lastName = firstNameLastName[1];
    // brain.isMale = null;
  }

  @override
  Widget build(BuildContext context) {
    averageController.text = widget.bowlerBrain.bowlers[widget.index].average.toString();
    return SizedBox(
      width: 200,
      height: 300,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(widget.bowlerBrain.bowlers[widget.index].firstName +
              ' ' +
              widget.bowlerBrain.bowlers[widget.index].lastName),
          SizedBox(
            height: 100,
            width: 250,
            child: TextField(
              controller: averageController,
              keyboardType: TextInputType.number,
              onChanged: (text){
                if(double.tryParse(text) == null){
                  widget.bowlerBrain.bowlers[widget.index].average = 0;
                  averageController.text = '';
                }
                else {
                  widget.bowlerBrain.bowlers[widget.index].average = double.parse(text);
                }
              },
              decoration: InputDecoration(hintText: 'Average'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GenderPicker(
                isMale: false,
                brain: brain,
                valueChanged: () {
                  setState(() {
                    //if they already selected is female = false then make it null unselecting female
                    if (brain.isMale == false) {
                      brain.isMale = null;
                      
                    } else {
                      //this set there gender as not male meaning female
                      brain.isMale = false;
                       widget.bowlerBrain.bowlers[widget.index].isMale = false;
                    }
                  });
                },
              ),
              SizedBox(
                width: 20,
              ),
              //this is the male picker
              GenderPicker(
                isMale: true,
                brain: brain,
                valueChanged: () {
                  setState(() {
                    //if they selected male already then unselect it since they are tapping a selected tile
                    if (brain.isMale == true) {
                      brain.isMale = null;
                    } else {
                      //means they are selecting male
                      brain.isMale = true;
                      widget.bowlerBrain.bowlers[widget.index].isMale = true;
                    }
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
