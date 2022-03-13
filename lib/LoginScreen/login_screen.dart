import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lois_bowling_website/LoginScreen/circle_avatar.dart';
import 'package:lois_bowling_website/LoginScreen/custom_button.dart';
import 'package:lois_bowling_website/LoginScreen/login_brain.dart';
import 'package:lois_bowling_website/LoginScreen/text_field.dart';
import 'package:lois_bowling_website/SignupScreen/signup_screen.dart';
import 'package:lois_bowling_website/constants.dart';
import 'package:lois_bowling_website/responsive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String finalText = '';
  bool isLoading = false;
  List<String> names = [];
  Map<String, List<String>> gameScore = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser != null) {
        Constants.currentSignedInEmail =
            FirebaseAuth.instance.currentUser!.email ?? 'Error';
        Navigator.pushNamed(context, Constants.tournamentHome);
      }
    });
  }

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Responsive.isMobile(context)
                  ? const SizedBox()
                  : Positioned.fill(
                      child: Image.asset('images/loginBackgroundImage.png',
                          fit: BoxFit.fill)),
              Align(
                alignment: Responsive.isMobile(context)
                    ? Alignment.center
                    : Alignment.centerRight,
                child: Padding(
                  padding: Responsive.isMobileOs(context)
                      ? const EdgeInsets.only(bottom: 0)
                      : const EdgeInsets.fromLTRB(0, 20, 100, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Responsive.isMobile(context)
                          ? const SizedBox()
                          : const Text('Welcome to MixPlate Bowling!',
                              style: TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.w800)),
                      Responsive.isMobile(context)
                          ? const SizedBox()
                          : const Text('Please Sign In to Continue',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w600)),
                      CustomCircleAvatar(),
                      TextFieldCustom(
                        hintText: 'Email',
                        leftIcon: const Icon(Icons.email),
                        ontyped: (text) {
                          email.text = text;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFieldCustom(
                        hintText: 'Password',
                        leftIcon: const Icon(Icons.lock),
                        ontyped: (text) {
                          password.text = text;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomButton(
                        buttonTitle: 'Login',
                        onClicked: () {
                          LoginBrain.signInUser(email.text, password.text)
                              .then((errorCode) {
                            if (errorCode == '') {
                              Navigator.pushNamed(
                                  context, Constants.tournamentHome);
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(errorCode),
                                      ));
                            }
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const Text('Forgot Password?',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600))),
                      const SizedBox(
                        height: 30,
                      ),
                      Responsive.isMobile(context)
                          ? const SizedBox()
                          : TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpScreen()));
                              },
                              child: const Text('Create an Account',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))),
                      // Responsive.isMobile(context)
                      //     ? TextButton(
                      //         onPressed: isLoading
                      //             ? null
                      //             : () {
                                   
                      //               },
                      //         child: Text('Picture'))
                      //     : const SizedBox(),
                      // names.isNotEmpty && gameScore.isNotEmpty ?  TextButton(onPressed: (){

                      // }, child: Text('See Results')) : SizedBox()
                      // SizedBox(
                      //   height: 200,
                      //   child: ListView(
                      //     children: [Text(finalText)],
                      //   ),
                      // )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  

 
}
