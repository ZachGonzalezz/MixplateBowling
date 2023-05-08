// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:loisbowlingwebsite/constants.dart';


class LoginBrain{

static Future<String> signInUser(String email, String password) async{
String returnError = '';

final _auth = FirebaseAuth.instance;

try {
 await _auth
     .signInWithEmailAndPassword(
     email: email, password: password);
     Constants.currentSignedInEmail = email;
}

catch (e)  {
 returnError = e.toString();
}
return returnError;

}

}