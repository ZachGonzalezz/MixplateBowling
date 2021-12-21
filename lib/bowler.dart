import 'package:cloud_firestore/cloud_firestore.dart';
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
      this.isMale = false});

  double average;
  Map<String, String> divisions;
  String firstName;
  String lastName;
  double handicap;
  String uniqueId;
  Map<String, Map<String, int>> scores;
  Map<String, dynamic> doublePartners;
  bool isMale;

  void updateBowlerScores() async {
    await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .collection('Bowlers')
        .doc(uniqueId)
        .update({'scores': scores});
  }
}
