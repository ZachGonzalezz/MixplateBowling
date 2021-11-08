import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lois_bowling_website/LoginScreen/custom_button.dart';
import 'package:lois_bowling_website/LoginScreen/text_field.dart';
import 'package:lois_bowling_website/TournamentCreateNewScreen/share_popup.dart';
import 'package:lois_bowling_website/TournamentCreateNewScreen/tournament_create_brain.dart';
import 'package:lois_bowling_website/constants.dart';
  import 'package:intl/intl.dart';

class TournamentCreatenewScreen extends StatefulWidget {
   TournamentCreatenewScreen({Key? key}) : super(key: key);

  @override
  State<TournamentCreatenewScreen> createState() => _TournamentCreatenewScreenState();
}

class _TournamentCreatenewScreenState extends State<TournamentCreatenewScreen> {
  DateTime to = DateTime.now();

  DateTime from = DateTime.now();

DateFormat dateFormat = DateFormat("MM/dd/yyyy");

List<String> emailsToSendTo = [];

String nameOfTournament = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned.fill(
                  child: Image.asset(
                'images/background.png',
                fit: BoxFit.fill,
              )),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      Constants.sizeOfScreen.width * 0.2,
                      Constants.sizeOfScreen.height * 0.1,
                      Constants.sizeOfScreen.width * 0.2,
                      0),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Constants.lightBlue,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50))),
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextFieldCustom(
                                
                                  ontyped: (text) {
                                    nameOfTournament = text;
                                  },
                                  hintText: 'Name Of Tournament'),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.05,
                                  ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                  TextButton(
                                  onPressed: () async {

                                 DateTime? newTo = await   showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 1000)));
                                  if(newTo != null){
                                    setState(() {
                                      to = newTo;
                                    });
                                  }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child:  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(dateFormat.format(to)),
                                    ),
                                  )),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.1,
                                  ),
                                   TextButton(
                                  onPressed: () async {
SchedulerBinding.instance?.addPostFrameCallback((_) async{


                                 DateTime? newFrom = await   showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 1000)));
                                  if(newFrom != null){
                                    setState(() {
                                      from = newFrom;
                                    });
                                  }
                                  });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child:  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(dateFormat.format(from)),
                                    ),
                                  ))
                      
                               ],
                             ),
                             SizedBox(
                               height: MediaQuery.of(context).size.height * 0.05,
                             ),
                              CustomButton(buttonTitle: 'Share', onClicked: () async{
                               List<String>? emails = await showDialog(context: context, builder: (context) =>  SharePopUp(emailsToSendTo: emailsToSendTo));
                               if(emails != null){
                                 emailsToSendTo = emails;
                               }
                              }, length: 300,),
                                SizedBox(
                               height: MediaQuery.of(context).size.height * 0.05,
                             ),
                              CustomButton(buttonTitle: 'Create', onClicked: (){
                               String errorCode =  TournamentCreateBrain.isGoodtoCreate(nameOfTournament, to, from);
                               if(errorCode == ''){
                                 TournamentCreateBrain.createCourse(nameOfTournament, to, from, emailsToSendTo);
                               }
                               else{
                                 showDialog(context: context, builder: (context) => AlertDialog(title: Text(errorCode),));
                               }
                              }, length: 300,),
                            ],
                          ),
                        ),
                      )
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
