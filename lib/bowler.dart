class Bowler {

  Bowler({
    this.average = 0.0, 
    this.handicap = 0.0, 
    this.lastName = '', 
    required this.uniqueId,
    this.firstName = '',
    this.divisions = const {}
  });

  double average;
 Map<String, String> divisions;
  String firstName;
  String lastName;
  double handicap;
  String uniqueId;

}