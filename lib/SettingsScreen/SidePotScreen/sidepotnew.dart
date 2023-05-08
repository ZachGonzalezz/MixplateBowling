import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/LoginScreen/custom_button.dart';
import 'package:loisbowlingwebsite/SettingsScreen/SidePotScreen/error_popup.dart';
import 'package:loisbowlingwebsite/SettingsScreen/SidePotScreen/sidepot_brain.dart';

class SidePotNew extends StatelessWidget {
  SidePotNew({Key? key}) : super(key: key);

  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add New Side Pot',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      content: SizedBox(
        height: 400,
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: price,
              onChanged: (newText) {
                if (int.tryParse(newText) == null) {
                  price.text = newText.substring(0, newText.length - 1);
                }
              },
              decoration: InputDecoration(hintText: 'Price'),
            ),
             SizedBox(
              height: 20,
            ),
           Builder(
                          builder:(ctx) =>  CustomButton(
                  buttonTitle: 'Save',
                  onClicked: () {
                    //checks to see if everything is good to save if '' comes back then its good
                    String isError =
                        SidePotBrain().isGoodToSave(name.text, price.text);
            
                    //shows error message if there is one
                    if (isError.isNotEmpty) {
                      showDialog(
                          context: context,
                          builder: (context) => ErrorPopUp(error: isError));
                    } else {
                     ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Saved', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),),);
                      //save to database then send back to update ui on other screen
                      SidePotBrain().saveToDB(name.text, price.text);
                      Map<String, dynamic> data = {name.text : int.parse(price.text)};
                      Navigator.pop(context, 
                      data
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
