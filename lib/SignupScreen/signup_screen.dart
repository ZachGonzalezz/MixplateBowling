import 'package:flutter/material.dart';
import 'package:lois_bowling_website/LoginScreen/custom_button.dart';
import 'package:lois_bowling_website/LoginScreen/login_screen.dart';
import 'package:lois_bowling_website/LoginScreen/text_field.dart';
import 'package:lois_bowling_website/SignupScreen/signup_brain.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  SignUpScreen({ Key? key }) : super(key: key);
  TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController firstName = TextEditingController();
    TextEditingController lastName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        children: [
          SizedBox(
          
            height: MediaQuery.of(context).size.height,
            child: Stack(
              fit: StackFit.expand,
      
            children: [
             Positioned.fill(child: Image.asset('images/loginBackgroundImage.png', fit: BoxFit.fill)),
      
             Align(
         alignment: Alignment.centerRight,
      
         child: Padding(
             padding: const EdgeInsets.fromLTRB(0, 20, 100, 0),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                const Text('Welcome to MixPlate Bowling!', style: TextStyle( fontSize: 36, fontWeight: FontWeight.w800)),
                const Text('Create an Account to Start', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
            const SizedBox(
                   height: 30,
                 ),
                  TextFieldCustom(hintText: 'First', leftIcon:  const Icon(Icons.account_circle_rounded), ontyped: (text){
                firstName.text = text;
                 },),
                const SizedBox(
                   height: 30,
                 ),
                  TextFieldCustom(hintText: 'Last', leftIcon:  const Icon(Icons.account_circle_rounded), ontyped: (text){
                  lastName.text = text;
                 },),
                const SizedBox(
                   height: 30,
                 ),
                 TextFieldCustom(hintText: 'Email', leftIcon:  const Icon(Icons.email), ontyped: (text){
                   email.text = text;
                 },),
                const SizedBox(
                   height: 30,
                 ),
                 TextFieldCustom(hintText: 'Password', leftIcon:  const Icon(Icons.lock), ontyped: (text){
                    password.text = text;
                 },),
                  const SizedBox(
                   height: 30,
                 ),
                 CustomButton(buttonTitle: 'Sign Up', onClicked: (){
                   SignUpBrain.createNewUser(firstName.text, lastName.text, email.text, password.text).then((errorCode) {
              
                    if(errorCode == ''){
                       Navigator.push(context, MaterialPageRoute(builder: (context) =>  const LoginScreen()));
                    }
                    else{
                        showDialog(context: context, builder: (context) => AlertDialog(title: Text(errorCode),));
                    }
                   });
                 },),
                 const SizedBox(
                   height: 10,
                 ),
                  TextButton(onPressed: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) =>  const LoginScreen()));
                  }, child: const Text('Already Have an Account?', style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w600))),

               ],
             ),
         ),
             )
            ],
            
        ),
          ),
        ]),
      
    );
  }
}