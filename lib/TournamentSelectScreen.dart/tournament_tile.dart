import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lois_bowling_website/TournamentSelectScreen.dart/tournament_selection_class.dart';
import 'package:lois_bowling_website/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TournamentTile extends StatelessWidget {
   TournamentTile({ Key? key, required this.tournament}) : super(key: key);
TournamentSelection tournament;


DateFormat dateFormat = DateFormat("MM/dd/yyyy");


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        Constants.currentIdForTournament = 'Users/${Constants.currentSignedInEmail}/Tournaments/${tournament.id}';
        Constants.tournamentName = tournament.name;
         final prefs = await SharedPreferences.getInstance();
      
      prefs.setString('tournamentId', Constants.currentIdForTournament);
        Navigator.pushNamed(context, Constants.settingsHome);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          
          children: [
            Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tournament.name, style: const TextStyle( fontSize: 26, fontWeight: FontWeight.w800)),
                      Row(
                        children: [
                          Text(dateFormat.format(tournament.start)),
                          const SizedBox(width: 10,),
                          const Icon(Icons.person_add_alt)
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