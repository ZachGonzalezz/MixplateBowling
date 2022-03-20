import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loisbowlingwebsite/TournamentSelectScreen.dart/tournament_selection_class.dart';
import 'package:loisbowlingwebsite/constants.dart';
import 'package:loisbowlingwebsite/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TournamentTile extends StatelessWidget {
  TournamentTile({Key? key, required this.tournament}) : super(key: key);
  TournamentSelection tournament;

  DateFormat dateFormat = DateFormat("MM/dd/yyyy");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Constants.currentIdForTournament =
            'Users/${Constants.currentSignedInEmail}/Tournaments/${tournament.id}';
        //if tournament is shared we set the id to the owners reference
        if (tournament.isShared) {
          Constants.currentIdForTournament =
              'Users/${tournament.ownerEmail}/Tournaments/${tournament.id}';
        }
        Constants.tournamentName = tournament.name;
        final prefs = await SharedPreferences.getInstance();

        prefs.setString('tournamentId', Constants.currentIdForTournament);
        if(Responsive.isMobileOs(context)){
Navigator.pushNamed(context, Constants.inputScores);
        }
        else {
        Navigator.pushNamed(context, Constants.settingsHome);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Responsive.isMobileOs(context) ? 5 : 40),
        child: Column(

          children: [
            Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(50)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tournament.name,
                          style: TextStyle(
                              fontSize: Responsive.isMobileOs(context) ? 21 : 26, fontWeight: FontWeight.w800)),
                   Responsive.isMobileOs(context) ? SizedBox() :   Row(
                        children: [
                          Text(dateFormat.format(tournament.start)),
                          const SizedBox(
                            width: 10,
                          ),
                          tournament.isShared
                              ? Icon(Icons.person_add_alt)
                              : SizedBox()
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
