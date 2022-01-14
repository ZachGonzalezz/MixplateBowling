class TournamentSelection {
  TournamentSelection(
      {required this.name,
      required this.start,
      required this.end,
      required this.sharedWith,
      required this.id,
      required this.isShared,
      required this.ownerEmail});

  String id;
  String name;
  DateTime start;
  DateTime end;
  List<String> sharedWith;
  bool isShared;
  String ownerEmail;
}
