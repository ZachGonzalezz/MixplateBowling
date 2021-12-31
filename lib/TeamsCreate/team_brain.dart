import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lois_bowling_website/bowler.dart';
import 'package:lois_bowling_website/constants.dart';
import 'package:lois_bowling_website/team.dart';

class TeamBrain {
  Future<void> saveNewTeam(
      {required String name,
      required Map<String, Bowler> teamMembers,
      required String division,
      required String squad}) async {
    await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .collection('Teams')
        .doc()
        .set({
      'Name': name,
      'Members': getBowlerIds(teamMembers),
      'Division': division,
      'Squad': squad,
    });

    return;
  }

  Map<String, String> getBowlerIds(Map<String, Bowler> teamMembers) {
    Map<String, String> ids = {};

    teamMembers.forEach((key, value) {
      ids[key.toString()] = value.uniqueId;
    });
    return ids;
  }

  Future<void> updateATeam(
      {required String name,
      required Map<String, Bowler> teamMembers,
      required String id,
      required String division,
      required String squad}) async {
    await Constants.getTournamentId();

    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .collection('Teams')
        .doc(id)
        .update({
      'Name': name,
      'Members': getBowlerIds(teamMembers),
      'Division': division,
      'Squad': squad,
    });

    return;
  }

  String displayName({required Bowler? bowler}) {
    String name = (bowler ?? Bowler(uniqueId: '')).firstName +
        ' ' +
        (bowler ?? Bowler(uniqueId: '')).lastName;

    if (name == ' ') {
      return '';
    }
    return name;
  }

  Future<List<Team>> loadTeamsFromDb() async {
    await Constants.getTournamentId();
    List<Team> teams = [];
    await FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament)
        .collection('Teams')
        .get()
        .then((documents) {
      for (DocumentSnapshot doc in documents.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        String division = data['Division'] ?? ' ';
        String name = data['Name'] ?? ' ';
        String squad = data['Squad'] ?? ' ';
        Map<String, String> memberIds = Map.from(data['Members'] ?? {});

        teams.add(Team(
            division: division,
            name: name,
            squad: squad,
            bowlerIDs: memberIds,
            id: doc.id,
            bowlers: {}));
      }
    });

    return teams;
  }

  static List<Team> filterTeams(
      {required List<Team> teams,
      required String? search,
      required int outOf,
      required int percent, 
      required String squad, 
      String division = 'No Division'}) {
    List<Team> filtered = [];
    print(division);

    //if the search bar is empty send them back to default
    if (search == '' || search == null || search == ' ') {
      filtered = teams;
    } else {
      //search through the names of all the bowlers and see which one contains the search text
      for (Team team in teams) {
        //completely lowercases so removes that out of the equation
        if (team.name.toLowerCase().contains(search.toLowerCase())) {
          filtered.add(team);
        }
      }
    }

    filtered.sort((a, b) => b
        .findTeamTotal(outOf, percent)
        .compareTo(a.findTeamTotal(outOf, percent)));

      filtered = filtered.where((element) => element.squad == squad).toList();
      
      if(division.contains('No Division') == false){
        filtered = filtered.where((element) => element.division == division).toList();
      }


    //returns results of bowlers
    return filtered;
  }
}
