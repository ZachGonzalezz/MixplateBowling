import 'package:loisbowlingwebsite/bowler.dart';

class Bracket {
  Bracket({required this.id, required this.bowlerIds, required this.division});

  int id;
  List<String> bowlerIds;
  String division;
  List<Bowler> bowlers = [];
}
