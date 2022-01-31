import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lois_bowling_website/AddDoublePartner/partner_brain.dart';
import 'package:lois_bowling_website/constants.dart';

class Bowler {
  Bowler(
      {this.average = 0.0,
      this.handicap = 0.0,
      this.lastName = '',
      required this.uniqueId,
      this.firstName = '',
      this.divisions = const {},
      this.scores = const {},
      this.doublePartners = const {},
      this.isMale = false,
      this.sidepots = const {},
      this.financesPaid = const {},
      this.laneNUm = '',
      this.uscbNum = '',
      this.uniqueNum = '',
      this.address = '',
      this.phoneNum = '',
      this.paymentType = '',
      this.email = ''});

  double average;
  Map<String, String> divisions;
  String firstName;
  String lastName;
  double handicap;
  String uniqueId;
  Map<String, Map<String, int>> scores;
  Map<String, dynamic> doublePartners;
  bool isMale;
  int bestscore = 0;
  Map<String, dynamic> sidepots;
  Map<String, dynamic> financesPaid;
  String uscbNum;
  String laneNUm;
  String uniqueNum;
  String phoneNum;
  String email;
  String address;
  String paymentType;
  TextEditingController averageController = TextEditingController();

  void updateBowlerScores() async {
    await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .collection('Bowlers')
        .doc(uniqueId)
        .update({'scores': scores});
  }

  void updateBowlerFinances() async {
    await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .collection('Bowlers')
        .doc(uniqueId)
        .update({'financesPaid': financesPaid});
  }

  void findDoublePartners() async {
    await Constants.getTournamentId();

    List<Bowler> bowlers = await DoublePartner.loadBowlers();

//goes through every bowler
    for (Bowler bowler in bowlers) {
      //takes their doubles partners stored in Map<Squad(String), List<Stirng> (partnerId)>
      Map<String, dynamic> doublePartners = bowler.doublePartners;

      //goes through all the squads of double partners
      doublePartners.forEach((key, value) {
        //each squad can have mutiple double partners so goes through the array
        for (String partnerId in value) {
          //if the partner is equal to this bowler id that means that partner is reffering to this bowler
          if (partnerId == uniqueId) {
            //if its null than make an empty array so we can add onto it without errors
            if (this.doublePartners[key] == null) {
              this.doublePartners[key] = [];
            }

            //add their bowler id to our partners list under the squad
            this.doublePartners[key].add(bowler.uniqueId);
          }
        }
      });
    }
  }

  Future<void> loadBowlerData() async {
    await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .collection('Bowlers')
        .doc(uniqueId)
        .get()
        .then((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      num average = data['average'] ?? 0;
      num handicap = data['handicap'] ?? 0;
      String firstName = data['firstName'] ?? ' ';
      String lastName = data['lastName'] ?? ' ';
      Map<String, String> divisions =
          Map<String, String>.from(data['divisions'] ?? {});
      Map<String, dynamic> scoresDB =
          Map<String, dynamic>.from(data['scores'] ?? {});
      bool isMale = data['IsMale'] ?? false;
      Map<String, dynamic> partners = Map.from(data['doublePartners'] ?? {});
      Map<String, dynamic> sidepotsDB = Map.from(data['userSidePots'] ?? {});
      Map<String, dynamic> financesDB = Map.from(data['financesPaid'] ?? {});

      Map<String, Map<String, int>> scores = {};

      scoresDB.forEach((squad, scoreMap) {
        scores[squad] = {};

        scoreMap.forEach((game, score) {
          scores[squad]![game] = score.toInt();
        });
      });

      average = average.toDouble();
      handicap = handicap.toDouble();
      firstName = firstName;
      lastName = lastName;
      divisions = divisions;
      scores = scores;
      isMale = isMale;
      doublePartners = partners;
      sidepots = sidepotsDB;
      financesPaid = financesDB;
    });
  }

  int findScoreForSquad(String squad, int outOf, int percent, bool isHandicap,
      List<int> gamesIncluded) {
    int total = 0;

    int handicap = findHandicap(outOf, percent);

    scores[squad]?.forEach((game, score) {
      if (gamesIncluded.isEmpty || gamesIncluded.contains(int.parse(game))) {
        total += score;
        if (isHandicap) {
          total += handicap;
        }
      }
    });

    return total;
  }

  int findScoreForGame(String squad, int game) {
    return scores[squad]?[game.toString()] ?? 0;
  }

  int findHandicap(int outOf, int percent) {
    int handicapBasedOff = ((percent / 100) * outOf).toInt();
    int handicap = handicapBasedOff - average.toInt();
    this.handicap = handicap.toDouble();
    return handicap;
  }

  findBestSquadScore() {
    int best = 0;
    scores.forEach((squad, scoreMap) {
      int total = 0;
      scoreMap.forEach((game, score) {
        total += score;
      });
      if (total > best) {
        best = total;
      }
    });

    bestscore = best;
  }

  List<String> findFinaceSidePots() {
    List<String> sidePotsReturned = [];
    //sidepots are stored in {Squad : List<SidePots>}
    sidepots.forEach((squad, sidepotList) {
      List<dynamic> sidepots = sidepotList;
      sidepots.forEach((sidePot) {
        sidePotsReturned.add(squad + ' ' + sidePot);
      });
    });

    return sidePotsReturned;
  }

  int findAmountOwed(
      int entreeFee, List<Map<String, dynamic>> tournamentSidePots) {
    int sidePotAmount = 0;

//goes through all the sidepots the user is in which is stored in {squad, [sidepots]}
    sidepots.forEach((squad, sidepotList) {
      //this is the list of sidepots the user is in
      List<dynamic> sidepots = sidepotList;
      //goes through all them find the price listed in tournament settings
      sidepots.forEach((sidePot) {
        //tournamnet sidepot prices stored in List<Map<String, int>> format
        tournamentSidePots.forEach((tournamentSidePot) {
          //goes through the list trying to find the name of sidepot the user is in
          tournamentSidePot.forEach((key, value) {
            //once you find the sidepot finds the price then adds onto price
            if (key == sidePot) {
              sidePotAmount += value as int;
            }
          });
        });
      });
    });

//takes the total amount of user side pots cost and entree fees to be total
    return sidePotAmount + entreeFee;
  }

  int findAmountNeededForSidepot(
      String sidePotName, List<Map<String, dynamic>> tournamentSidePots) {
    int valueReturned = 0;

    tournamentSidePots.forEach((tournamentSidePot) {
      //goes through the list trying to find the name of sidepot the user is in
      tournamentSidePot.forEach((key, value) {
        //once you find the sidepot finds the price then return amount cost
        if (key == sidePotName.substring(2, sidePotName.length)) {
          valueReturned = value;
        }
      });
    });
    return valueReturned;
  }

  int findAmountOwedStill(
      int entreeFee, List<Map<String, dynamic>> tournamentSidePots) {
    int amountOwed = findAmountOwed(entreeFee, tournamentSidePots);

    int amountPaid = 0;
    financesPaid.forEach((key, value) {
      amountPaid += value as int;
    });
    return amountOwed - amountPaid;
  }

  void saveNewAverage(double newAverage) async {
    await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .collection('Bowlers')
        .doc(uniqueId)
        .update({'average': newAverage});
  }
}
