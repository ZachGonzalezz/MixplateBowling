import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lois_bowling_website/constants.dart';

class CreateBowlerBrain{

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController averageController = TextEditingController();
  TextEditingController handicapController = TextEditingController();
  TextEditingController sidePotController = TextEditingController();

  Map<String, String> selectedSinglesDivisions = {};

  bool? isMale;
  

//called right before user save to the database if no errors returns '' else returns string to be displayed in a pop up
  String isGoodToSavePerson(){

    if(isMale == null){
      return 'Please select a gender';
    }
    if(firstNameController.text == ''){
      return 'Please Enter a first name';
    }
    if(lastNameController.text == ''){
      return 'Please Enter a last name';
    }
    if(averageController.text == ''){
      return 'Please enter an average';
    }
    if(handicapController.text == ''){
      return 'Please enter a handicap';
    }

    return '';

  }

  Future<void> saveNewBowler() async{
    await Constants.getTournamentId();
    await FirebaseFirestore.instance.collection(Constants.currentIdForTournament + '/Bowlers').doc().set({
      'firstName' : firstNameController.text,
      'lastName' : lastNameController.text,
      'average' : int.parse(averageController.text),
      'handicap' : int.parse(handicapController.text),
      'divisions' : selectedSinglesDivisions

    });
  }

}