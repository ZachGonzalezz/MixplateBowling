import 'package:flutter/material.dart';
import 'package:lois_bowling_website/constants.dart';

class DivisionPicker extends StatefulWidget {
  DivisionPicker(
      {Key? key,
      required this.division,
      required this.selectedSquad,
      required this.onDivisionChange,
      this.selectedDivision = const {}})
      : super(key: key);

  List<String> division;
  String selectedSquad;
  //this function gets called when the division in picker is changed
  Function(String) onDivisionChange;

  //this holds the divisions in {"A" : "SIngles Handicap"} format used to auto matically select division the user has picked in past
  Map<String, String> selectedDivision = {};

  @override
  State<DivisionPicker> createState() => _DivisionPickerState();
}

class _DivisionPickerState extends State<DivisionPicker> {
  String selected = '';
  //this filters throguh all the division and only finds the one avaliable for that particular squad
  List<String> divisionsForSquads = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    //filters divisions for squad
    divisionsForSquads =
        Constants.findDivisionInSquad(widget.division, widget.selectedSquad);
    //this ensures that when user switches squad we change the value of selected so we do not get a value error in drop down
    if (selected == '  No Division' ||
        selected == '' ||
        divisionsForSquads.contains(selected) != true) {
          //if there is no previous selected division for this squad  simply give it a default value
          if(widget.selectedDivision[widget.selectedSquad] == null){
          selected = divisionsForSquads.first;
          }
          //if there is a history then set that
          else{
          selected = widget.selectedDivision[widget.selectedSquad]!;
          }

    }
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: DropdownButton(
              underline: null,
              elevation: 0,
              onChanged: (String? value) {
                widget.onDivisionChange(value ?? '');
                setState(() {
                  selected = value!;
                });
              },
              value: selected,
              items: divisionsForSquads
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.substring(2, value.length)),
                );
              }).toList(),
            ),
          )),
    );
  }
}
