import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loisbowlingwebsite/bowler.dart';
import 'package:loisbowlingwebsite/constants.dart';
import 'package:loisbowlingwebsite/team.dart';

class ImportBrain {
  void importBowlers(String tournId, bool IncludeScores, bool includeDivisions,
      bool includeDoubles, bool includeTeams, String email) async {
    await Future.delayed(Duration(milliseconds: 500));

    List<Bowler> bowlers = [];

    await Constants.dataBase
        .collection('Users')
        .doc(email)
        .collection('Tournaments')
        .doc(tournId)
        .collection('Bowlers')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data();
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
        String lanenNum = data['laneNum'] ?? '';
        String usbcNum = data['usbcNum'] ?? '';

        Map<String, Map<String, int>> scores = {};

        scoresDB.forEach((squad, scoreMap) {
          scores[squad] = {};

          scoreMap.forEach((game, score) {
            scores[squad]![game] = score.toInt();
          });
        });

        bowlers.add(Bowler(
            uniqueId: doc.id,
            average: average.toDouble(),
            handicap: handicap.toDouble(),
            firstName: firstName,
            lastName: lastName,
            divisions: includeDivisions ? divisions : {},
            scores: IncludeScores ? scores : {},
            isMale: isMale,
            doublePartners: includeDoubles ? partners : {},
            sidepots: sidepotsDB,
            financesPaid: financesDB,
            laneNUm: lanenNum,
            uscbNum: usbcNum));
      });
    });
    addBowlersToTourn(bowlers);
    if (includeTeams) {
      List<Team> teams = await getTeams(tournId);

      for (Team team in teams) {
        saveNewTeam(team);
      }
    }
  }

  void addBowlersToTourn(List<Bowler> bowlers) async {
    for (Bowler bowler in bowlers) {
      saveNewBowler(bowler);
    }
  }

  Future<void> saveNewBowler(Bowler bowler) async {
    await Constants.getTournamentId();
    DocumentReference newDoc = FirebaseFirestore.instance
        .collection(Constants.currentIdForTournament + '/Bowlers')
        .doc(bowler.uniqueId);
    await newDoc.set({
      'firstName': bowler.firstName,
      'lastName': bowler.lastName,
      'average': bowler.average,
      // 'handicap' : int.parse(handicapController.text),
      'divisions': bowler.divisions,
      'doublePartners': bowler.doublePartners,
      'id': newDoc.id,
      'isMale': bowler.isMale,
      'userSidePots': bowler.sidepots,
      'usbcNum': bowler.uscbNum,
      'laneNum': bowler.laneNUm
    });
  }

  Future<List<Team>> getTeams(String id) async {
    List<Team> teams = [];
    await Future.delayed(Duration(milliseconds: 500));
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(Constants.currentSignedInEmail)
        .collection('Tournaments')
        .doc(id)
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

  Future<void> saveNewTeam(Team team) async {
    await Constants.getTournamentId();
    DocumentReference newDoc = FirebaseFirestore.instance
        .collection(Constants.currentIdForTournament + '/Teams')
        .doc(team.id);
    await newDoc.set({
      'Name': team.name,
      'Members': team.bowlerIDs,
      'Division': team.division,
      'Squad': team.squad,
    });
  }

  void importSettings(String tournId, bool includeBasics, bool includeDivisions,
      bool includeSidepots, String email) async {
          await Constants.getTournamentId();
    await Future.delayed(Duration(milliseconds: 500));
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Tournaments')
        .doc(tournId)
        .get()
        .then((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      List<String> divisions = List<String>.from(data['Divisions'] ?? []);
      List<String> greyOutBoxed =
          List<String>.from(data['GreyedOutDivsions'] ?? []);
      List<Map<String, dynamic>> sidepots = List.from(data['sidepots'] ?? []);
      Map<String, double> mainSettings =
          Map<String, double>.from(data['Basic Settings'] ?? {});
      Map<String, dynamic> importedSettings = {};

      if (includeDivisions) {
        importedSettings['Divisions'] = divisions;
        importedSettings['GreyedOutDivsions'] = greyOutBoxed;
      }
      if (includeSidepots) {
        importedSettings['sidepots'] = sidepots;
      }
      if(includeBasics){
        importedSettings['Basic Settings'] = mainSettings;
      }

    DocumentReference newDoc = FirebaseFirestore.instance
        .doc(Constants.currentIdForTournament);
 newDoc.update(importedSettings);

    });
  }
}
