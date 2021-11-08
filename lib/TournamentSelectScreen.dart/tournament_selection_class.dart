class TournamentSelection{
  TournamentSelection({
    required this.name,
    required this.start,
    required this.end,
    required this.sharedWith,
    required this.id
  });

  String id;
  String name;
  DateTime start;
  DateTime end;
  List<String> sharedWith;

}