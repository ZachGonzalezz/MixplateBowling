import 'package:flutter/material.dart';
import 'package:lois_bowling_website/LoginScreen/custom_button.dart';
import 'package:lois_bowling_website/TournamentCreateNewScreen/shared_with_tile.dart';


class SharePopUp extends StatefulWidget {
   SharePopUp({ Key? key, required this.emailsToSendTo }) : super(key: key);

  List<String> emailsToSendTo;

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
            width: 200,
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
          })
        ],
      ),

      
    );
  }
}