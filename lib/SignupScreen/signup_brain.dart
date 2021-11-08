import 'package:firebase_auth/firebase_auth.dart';
import 'package:lois_bowling_website/constants.dart';

class SignUpBrain{

static Future<String> createNewUser(String first, String last, String email, String password) async{
String returnError = '';
if(first == ''){
  return 'You must add your first name';
}
if(last == ''){
  return 'You must add your last name';
}
final _auth = FirebaseAuth.instance;

try {
 await _auth
     .createUserWithEmailAndPassword(
     email: email, password: password);


     Constants.dataBase.collection('Users').doc(email).set({
       'email' : email,
       'first' : first,
       'last' : last
     });

}

on FirebaseAuthException catch (e)  {
 returnError = e.toString();
}
return returnError;

}

}