import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loisbowlingwebsite/constants.dart';

class SettingsBrain {
  List<String> divisions = [];

  String divisionSelectedSquad = "A";
  //these are the settings on the settings home screen
  Map<String, double> miscSettings = {};

//these are the boxes that are unavaible to be checked
  List<String> greyOutBoxed = [];
//this is used to save the settings on the main settings screen
  void saveHomeSettings() async {
    await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .update({'Basic Settings': miscSettings});
  }

  void saveDivisionSettings() async {
    await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .update({
      'Divisions': divisions,
      'GreyedOutDivsions': greyOutBoxed,
    });
  }

  Future<List<String>> loadDivisions() async {
    List<String> divisionDB = [];
    await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .get()
        .then((doc) {
      Map<String, dynamic> mainSettings = doc.data() as Map<String, dynamic>;

      divisions = List<String>.from(mainSettings['Divisions'] ?? []);
      divisionDB = divisions;
      greyOutBoxed = List<String>.from(mainSettings['GreyedOutDivsions'] ?? []);
    });
    return divisionDB;
  }

//pulls the main settings from
  Future<Map<String, double>> getMainSettings() async {
    Map<String, double> returnData = {};
    await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .get()
        .then((doc) {
      Map<String, dynamic> mainSettings = doc.data() as Map<String, dynamic>;
      returnData = {};
       Map<String, int>  intReturn =  Map<String, int>.from(mainSettings['Basic Settings'] ?? {});

       intReturn.forEach((key, value) {
         returnData[key] = value.toDouble();
       });

          
    });

    return returnData;
  }

  //pulls the main settings from
  Future<Map<String, dynamic>> getOtherSettings() async {
    Map<String, dynamic> returnData = {};
    await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .get()
        .then((doc) {
     
      Map<String, dynamic> dataReturned = doc.data() as Map<String, dynamic>;
      dataReturned['id'] = doc.id;
      returnData = dataReturned;
    });

    return returnData;
  }

//use to find whether the division is in singles/teams or doubles
  String findDivision(String title) {
    if (title.contains('Singles')) {
      return 'Singles';
    } else if (title.contains('Doubles')) {
      return 'Doubles';
    } 
    else if (title.contains('Senior')) {
      return 'Senior';
    } 
    else {
      return 'Team';
    }
  }

//this is called everytime a new box is checked
  void newBoxedChecked(bool isChecking, String title) {
    String divissionType = findDivision(title);

    //gets rid of the word singles/doubles/team since they are all the same except those words to make it more efficent
    switch (title
        .replaceAll('Singles', '')
        .replaceAll('Doubles', '')
        .replaceAll('Team', '')
        .replaceAll('Senior', '')) {
      case (' Scratch (One Division)'):
        //adds the division to divisions check array to be saved to db
        if (isChecking) {
          //removes any conflicting buttons
          addToGreyOut([
            divisionSelectedSquad + ' Men\'s ' + divissionType + ' Scratch',
            divisionSelectedSquad + ' Women\'s ' + divissionType + ' Scratch'
          ]);
        } else {
          removeFromGreyOut([
            divisionSelectedSquad + ' Men\'s ' + divissionType + ' Scratch',
            divisionSelectedSquad + ' Women\'s ' + divissionType + ' Scratch'
          ]);
        }
        break;

      case ('Men\'s  Scratch'):
        //adds the division to divisions check array to be saved to db
        if (isChecking) {
          //removes any conflicting buttons
          addToGreyOut([
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Scratch (One Division)'
          ]);
        } else {
          //if they do not have womens single scratch check allow them to the check single divison in scratch
          if (divisions.contains(divisionSelectedSquad +
                  ' ' +
                  'Women\'s ' +
                  divissionType +
                  ' Scratch') !=
              true) {
            removeFromGreyOut([
              divisionSelectedSquad +
                  ' ' +
                  divissionType +
                  ' Scratch (One Division)'
            ]);
          }
        }
        break;

      case ('Women\'s  Scratch'):
        //adds the division to divisions check array to be saved to db
        if (isChecking) {
          //removes any conflicting buttons
          addToGreyOut([
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Scratch (One Division)'
          ]);
        } else {
          //if they do not have mens single scratch check allow them to the check single divison in scratch
          if (divisions.contains(divisionSelectedSquad +
                  ' ' +
                  'Men\'s ' +
                  divissionType +
                  ' Scratch') !=
              true) {
            removeFromGreyOut([
              divisionSelectedSquad +
                  ' ' +
                  divissionType +
                  ' Scratch (One Division)'
            ]);
          } else {}
        }

        break;

      case (' Handicap (One Division)'):
        //adds the division to divisions check array to be saved to db
        if (isChecking) {
          //removes any conflicting buttons
          addToGreyOut([
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap',
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap',
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap Low',
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap High',
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap High',
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap Low',
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Gender Neutural Handicap Low',
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Gender Neutural Handicap High',
          ]);
        } else {
          removeFromGreyOut([
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap',
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap',
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap Low',
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap High',
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap High',
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap Low',
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Gender Neutural Handicap Low',
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Gender Neutural Handicap High',
          ]);
        }
        break;

      case ('Men\'s  Handicap'):

        //adds the division to divisions check array to be saved to db
        if (isChecking) {
          //removes any conflicting buttons
          addToGreyOut([
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Handicap (One Division)',
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap High',
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap Low',
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Gender Neutural Handicap Low',
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Gender Neutural Handicap High',
          ]);
        } else {
          removeFromGreyOut([
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap High',
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap Low',
          ]);
          //if womens single handicap division is unselected allow gender neturual
          if (divisions.contains('Women\'s ' + divissionType + ' Handicap') !=
              true) {
            removeFromGreyOut([
              divisionSelectedSquad +
                  ' ' +
                  divissionType +
                  ' Gender Neutural Handicap Low',
              divisionSelectedSquad +
                  ' ' +
                  divissionType +
                  ' Gender Neutural Handicap High',
            ]);
          }
          //removes single division from being unselected if nothing else is selected
          allDivisionsRemoved(divissionType);
        }
        break;

      case ('Women\'s  Handicap'):

        //adds the division to divisions check array to be saved to db
        if (isChecking) {
          //removes any conflicting buttons
          addToGreyOut([
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Handicap (One Division)',
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap High',
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap Low',
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Gender Neutural Handicap Low',
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Gender Neutural Handicap High',
          ]);
        } else {
          removeFromGreyOut([
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap High',
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap Low',
          ]);
          if (divisions.contains('Men\'s ' + divissionType + ' Handicap') !=
              true) {
            removeFromGreyOut([
              divisionSelectedSquad +
                  ' ' +
                  divissionType +
                  ' Gender Neutural Handicap Low',
              divisionSelectedSquad +
                  ' ' +
                  divissionType +
                  ' Gender Neutural Handicap High',
            ]);
          }
          allDivisionsRemoved(divissionType);
        }
        break;

      case ('Men\'s  Handicap Low'):

        //adds the division to divisions check array to be saved to db
        if (isChecking) {
          //removes any conflicting buttons
          addToGreyOut([
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Handicap (One Division)',
            'Men\'s ' + divissionType + ' Handicap',
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Gender Neutural Handicap Low',
          ]);
        } else {
          removeFromGreyOut([
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap High',
          ]);
          //handicap high and low are unchecked allow them to select one divison for men
          if (divisions.contains(divisionSelectedSquad +
                  ' ' +
                  'Men\'s ' +
                  divissionType +
                  ' Handicap High') !=
              true) {
            removeFromGreyOut([
              divisionSelectedSquad +
                  ' ' +
                  'Men\'s ' +
                  divissionType +
                  ' Handicap'
            ]);
          }
          //if women handicap low is unhcecked allow them to select gender netural Low
          if (divisions.contains(divisionSelectedSquad +
                  ' ' +
                  'Women\'s ' +
                  divissionType +
                  ' Handicap Low') !=
              true) {
            removeFromGreyOut([
              divisionSelectedSquad +
                  ' ' +
                  divissionType +
                  ' Gender Neutural Handicap Low',
            ]);
          }
          //checks to see if any other handicap boxes are check if none says they can make it one division
          allDivisionsRemoved(divissionType);
        }
        break;

      case ('Men\'s  Handicap High'):

        //adds the division to divisions check array to be saved to db
        if (isChecking) {
          //removes any conflicting buttons
          addToGreyOut([
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Handicap (One Division)',
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap',
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Gender Neutural Handicap High',
          ]);
        } else {
          removeFromGreyOut([
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap High',
          ]);
          //handicap high and low are unchecked allow them to select one divison for men
          if (divisions.contains(divisionSelectedSquad +
                  ' ' +
                  'Men\'s ' +
                  divissionType +
                  ' Handicap Low') !=
              true) {
            removeFromGreyOut([
              divisionSelectedSquad +
                  ' ' +
                  'Men\'s ' +
                  divissionType +
                  ' Handicap'
            ]);
          }
          //if women handicap low is unhcecked allow them to select gender netural Low
          if (divisions.contains(divisionSelectedSquad +
                  ' ' +
                  'Women\'s ' +
                  divissionType +
                  ' Handicap High') !=
              true) {
            removeFromGreyOut([
              divisionSelectedSquad +
                  ' ' +
                  divissionType +
                  ' Gender Neutural Handicap High',
            ]);
          }
          //checks to see if any other handicap boxes are check if none says they can make it one division
          allDivisionsRemoved(divissionType);
        }
        break;

      case ('Women\'s  Handicap High'):

        //adds the division to divisions check array to be saved to db
        if (isChecking) {
          //removes any conflicting buttons
          addToGreyOut([
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Handicap (One Division)',
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap',
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Gender Neutural Handicap High',
          ]);
        } else {
          removeFromGreyOut([
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap High',
          ]);
          //handicap high and low are unchecked allow them to select one divison for men
          if (divisions.contains(divisionSelectedSquad +
                  ' ' +
                  'Women\'s ' +
                  divissionType +
                  ' Handicap Low') !=
              true) {
            removeFromGreyOut([
              divisionSelectedSquad +
                  ' ' +
                  'Women\'s ' +
                  divissionType +
                  ' Handicap'
            ]);
          }
          //if women handicap low is unhcecked allow them to select gender netural Low
          if (divisions.contains(divisionSelectedSquad +
                  ' ' +
                  'Men\'s ' +
                  divissionType +
                  ' Handicap High') !=
              true) {
            removeFromGreyOut([
              divisionSelectedSquad +
                  ' ' +
                  divissionType +
                  ' Gender Neutural Handicap High',
            ]);
          }
          //checks to see if any other handicap boxes are check if none says they can make it one division
          allDivisionsRemoved(divissionType);
        }
        break;

      case ('Women\'s  Handicap Low'):

        //adds the division to divisions check array to be saved to db
        if (isChecking) {
          //removes any conflicting buttons
          addToGreyOut([
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Handicap (One Division)',
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap',
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Gender Neutural Handicap Low',
          ]);
        } else {
          removeFromGreyOut([
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap Low',
          ]);
          //handicap high and low are unchecked allow them to select one divison for men
          if (divisions.contains(divisionSelectedSquad +
                  ' ' +
                  'Women\'s ' +
                  divissionType +
                  ' Handicap High') !=
              true) {
            removeFromGreyOut([
              divisionSelectedSquad +
                  ' ' +
                  'Women\'s ' +
                  divissionType +
                  ' Handicap'
            ]);
          }
          //if women handicap low is unhcecked allow them to select gender netural Low
          if (divisions.contains(divisionSelectedSquad +
                  ' ' +
                  'Men\'s ' +
                  divissionType +
                  ' Handicap Low') !=
              true) {
            removeFromGreyOut([
              divisionSelectedSquad +
                  ' ' +
                  divissionType +
                  ' Gender Neutural Handicap Low',
            ]);
          }
          //checks to see if any other handicap boxes are check if none says they can make it one division
          allDivisionsRemoved(divissionType);
        }
        break;

      case (' Gender Neutural Handicap Low'):

        //adds the division to divisions check array to be saved to db
        if (isChecking) {
          //removes any conflicting buttons
          addToGreyOut([
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Handicap (One Division)',
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap Low',
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap Low',
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap',
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap',
          ]);
        } else {
          removeFromGreyOut([
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap Low',
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap Low',
          ]);

          if (divisions.contains(divisionSelectedSquad +
                  ' ' +
                  divissionType +
                  ' Gender Neutural Handicap High') !=
              true) {
            removeFromGreyOut([
              divisionSelectedSquad +
                  ' ' +
                  'Men\'s ' +
                  divissionType +
                  ' Handicap',
              divisionSelectedSquad +
                  ' ' +
                  'Women\'s ' +
                  divissionType +
                  ' Handicap',
            ]);
          }

          //checks to see if any other handicap boxes are check if none says they can make it one division
          allDivisionsRemoved(divissionType);
        }
        break;

      case (' Gender Neutural Handicap High'):

        //adds the division to divisions check array to be saved to db
        if (isChecking) {
          //removes any conflicting buttons
          addToGreyOut([
            divisionSelectedSquad +
                ' ' +
                divissionType +
                ' Handicap (One Division)',
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap High',
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap High',
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap',
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap',
          ]);
        } else {
          removeFromGreyOut([
            divisionSelectedSquad +
                ' ' +
                'Women\'s ' +
                divissionType +
                ' Handicap High',
            divisionSelectedSquad +
                ' ' +
                'Men\'s ' +
                divissionType +
                ' Handicap High',
          ]);
          //if the gender neturual low is also no checked then allow them to select indivisual gender boxes
          if (divisions.contains(divisionSelectedSquad +
                  ' ' +
                  divissionType +
                  ' Gender Neutural Handicap Low') !=
              true) {
            removeFromGreyOut([
              divisionSelectedSquad +
                  ' ' +
                  'Men\'s ' +
                  divissionType +
                  ' Handicap',
              divisionSelectedSquad +
                  ' ' +
                  'Women\'s ' +
                  divissionType +
                  ' Handicap',
            ]);
          }

          //checks to see if any other handicap boxes are check if none says they can make it one division
          allDivisionsRemoved(divissionType);
        }
        break;

      default:
    }
  }

//checks if there are no more things checked in handicap divisions uncehck the box One Division Singles Handicap
  void allDivisionsRemoved(String divisionType) {
    bool isClearToUncheck = true;
//goes through all the current selected divisions and if clear then is good to remove thme
    for (String division in divisions) {
      if (division.contains('Handicap') && division.contains(divisionType)) {
        //means they founds soemthing that includes Handicap and the division
        isClearToUncheck = false;
      }
    }
    if (isClearToUncheck) {
      removeFromGreyOut([
        divisionSelectedSquad + ' ' + divisionType + ' Handicap (One Division)'
      ]);
    }
  }

//this means you are adding to the list of added division your tournament will have
  void addToGreyOut(List<String> tittles) {
    tittles.forEach((title) {
      if (greyOutBoxed.contains(title) != true) {
        greyOutBoxed.add(title);
      }
    });
  }

//this means that you are removing because a conflict for exmaple if they check hadnicap and scratch combine into one must remove everything else
  void removeFromGreyOut(List<String> tittles) {
    tittles.forEach((title) {
      //no need to add squad bc its add
      greyOutBoxed.remove(title);
    });
  }

  void shareWithBowlers(List<String> emails, String name, DateTime to, DateTime from, String docId) async{
      

       
       await Future.forEach(emails, (String email)  async {



DocumentReference id =  FirebaseFirestore.instance.collection('Users').doc(email.replaceAll(' ', '')).collection('Tournaments').doc(docId);

          print(id.id);
     //     Users/loistsunoda2@gmail.com/Tournaments/Users/1@2.com/Tournaments/NbgWklKFMz8IdWbhcoGT


          id.set({
        'to': to,
        'from': from,
        'name': name,
        'sharedWith': emails,
        'sidepots': [{}],
        //this will be used to see if it is shared with someone
        'isShared': true,
        //if it is shared then we will use this email in doucment address user/thisId/tourn/thisTournId (can do this bc we made them identical)
        'owner': Constants.currentSignedInEmail
      });

      
    });
}
}
