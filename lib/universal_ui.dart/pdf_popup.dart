import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/LoginScreen/custom_button.dart';
import 'package:loisbowlingwebsite/bowler.dart';
import 'package:loisbowlingwebsite/doublePartner.dart';
import 'package:loisbowlingwebsite/pdf.dart';
import 'package:loisbowlingwebsite/team.dart';

class PDFGamePopUp extends StatefulWidget {
  PDFGamePopUp(
      {Key? key,
      required this.numOfGames,
      required this.outOf,
      required this.percent,
      required this.division,
      this.doubles,
      this.singles,
      this.teams})
      : super(key: key);
  int numOfGames, outOf, percent;
  String division;
  List<Bowler>? singles;
  List<DoublePartners>? doubles;
  List<Team>? teams;
  @override
  _PDFGamePopUpState createState() => _PDFGamePopUpState();
}

class _PDFGamePopUpState extends State<PDFGamePopUp> {
  List<int> gamesThatAreSelected = [];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          'Select which games you would like to print. If none are selected then it will print all'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: ListView.builder(
                itemCount: widget.numOfGames,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Text('Game ' + (index + 1).toString()),
                      Checkbox(
                          value: gamesThatAreSelected.contains(index + 1),
                          onChanged: (isSelected) {
                            setState(() {
                              if (isSelected == true) {
                                gamesThatAreSelected.add(index + 1);
                              } else {
                                gamesThatAreSelected.remove(index + 1);
                              }
                            });
                          })
                    ],
                  );
                }),
          ),
          SizedBox(
            height: 20,
          ),
          CustomButton(
              buttonTitle: 'Save PDF',
              onClicked: () {
                if (widget.singles != null) {
                  PDFBrain().createSinglesPdf(
                      widget.singles!,
                      widget.numOfGames,
                      widget.outOf,
                      widget.percent,
                      widget.division,
                      gamesThatAreSelected);
                } else if (widget.doubles != null) {
                  PDFBrain().createDoublesPdf(
                      widget.doubles!,
                      widget.numOfGames,
                      widget.outOf,
                      widget.percent,
                      gamesThatAreSelected);
                } else if (widget.teams != null) {
                  PDFBrain().createTeamsPdf(widget.teams!, widget.numOfGames,
                      widget.outOf, widget.percent, gamesThatAreSelected);
                }
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}
