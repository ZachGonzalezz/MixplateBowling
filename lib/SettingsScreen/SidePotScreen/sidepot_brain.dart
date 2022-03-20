import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loisbowlingwebsite/constants.dart';

class SidePotBrain {
  String isGoodToSave(String name, String price) {
    if (name.isEmpty) {
      return 'Please Add a name';
    }
    if (price.isEmpty) {
      return 'Please add a price';
    }
    if (int.tryParse(price) == null) {
      return 'Price must be a number';
    }
    return '';
  }
  Future delete(String name, String price) async {
    await Constants.getTournamentId();
    String id = Constants.currentIdForTournament;

//saves the new side pot in a list of key values pairs in the databaes
    //removes the element from the db
    await  FirebaseFirestore.instance.doc(id).update({
      'sidepots': FieldValue.arrayRemove([
        {name: int.parse(price)}
      ])
    });
  }


  Future saveToDB(String name, String price) async {
    await Constants.getTournamentId();
    String id = Constants.currentIdForTournament;

//saves the new side pot in a list of key values pairs in the databaes
    FirebaseFirestore.instance.doc(id).update({
      'sidepots': FieldValue.arrayUnion([
        {name: int.parse(price)}
      ])
    });
  }

  Future update(String name, String price, String oldPrice) async{
        await Constants.getTournamentId();
    String id = Constants.currentIdForTournament;
    //removes the element from the db
    await  FirebaseFirestore.instance.doc(id).update({
      'sidepots': FieldValue.arrayRemove([
        {name: int.parse(oldPrice)}
      ])
    });

//saves the new version
    FirebaseFirestore.instance.doc(id).update({
      'sidepots': FieldValue.arrayUnion([
        {name: int.parse(price)}
      ])
    });
  }

  Future<List<Map<String, dynamic>>> getSidePots() async {
      await Constants.getTournamentId();
    String id = Constants.currentIdForTournament;

    List<Map<String, dynamic>> newSidePots = [];

//saves the new side pot in a list of key values pairs in the databaes
    await FirebaseFirestore.instance.doc(id).get().then((doc) {

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      newSidePots = List.from(data['sidepots'] ?? []);


    });

    return newSidePots;
  }
}
