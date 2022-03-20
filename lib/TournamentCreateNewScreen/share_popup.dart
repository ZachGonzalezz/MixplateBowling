import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/LoginScreen/custom_button.dart';
import 'package:loisbowlingwebsite/SettingsScreen/settings_brain.dart';
import 'package:loisbowlingwebsite/TournamentCreateNewScreen/shared_with_tile.dart';


class SharePopUp extends StatefulWidget {
   SharePopUp({ Key? key, required this.emailsToSendTo, this.isTournamnetCreatedAlready = false, this.name = '', this.to, this.from, this.id = ''}) : super(key: key);

  List<String> emailsToSendTo;
  bool isTournamnetCreatedAlready;
  String name;
  DateTime? to;
  DateTime? from;
  String id;

  @override
  State<SharePopUp> createState() => _SharePopUpState();
}

class _SharePopUpState extends State<SharePopUp> {
  TextEditingController emailAddTextField = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      title: const Center(child:  Text('Add to Tournament', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
       children: [
        TextField(
          controller: emailAddTextField,
          onSubmitted: (text){
            setState(() {
              widget.emailsToSendTo.add(text);
              emailAddTextField.text = '';
            });
          },
        
            decoration:  const InputDecoration(
              hintText: 'Enter a Email'
            ),
          ),
            const SizedBox(height: 30,),
          SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width / 2,
            child: ListView.builder(
              itemCount: widget.emailsToSendTo.length,
              itemBuilder: (context, index){
              return Column(
                children: [
                  ShareWithTile(email: widget.emailsToSendTo[index], removeEmail: (){
                    setState(() {
                      widget.emailsToSendTo.removeAt(index);
                    });
                  },),
                  const SizedBox(height: 10,)
                ],
              );
            }),
          ),
           const SizedBox(height: 30,),
          CustomButton(buttonTitle: 'Invite', onClicked: (){
            Navigator.pop(context, widget.emailsToSendTo);
            if(widget.isTournamnetCreatedAlready){
              SettingsBrain().shareWithBowlers(widget.emailsToSendTo, widget.name, widget.to ?? DateTime.now(), widget.from ?? DateTime.now(), widget.id);
            }
          })
        ],
      ),

      
    );
  }
}