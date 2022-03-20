import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/SettingsScreen/settings_brain.dart';

class InputValueTileSettings extends StatefulWidget {
  InputValueTileSettings({Key? key, required this.title, required this.brain, required this.miscSettings})
      : super(key: key);

  String title;
  SettingsBrain brain;
  Map<String, double> miscSettings;

  @override
  State<InputValueTileSettings> createState() => _InputValueTileSettingsState();
}

class _InputValueTileSettingsState extends State<InputValueTileSettings> {
  TextEditingController controller = TextEditingController();

  
    

  
  @override
  Widget build(BuildContext context) {
     
  if( widget.brain.miscSettings[widget.title] != null){

  controller.text =  widget.brain.miscSettings[widget.title].toString();
    }
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: widget.title,
                  ),
                  onSubmitted: (text){
                    widget.brain.saveHomeSettings();
                  },
                  onChanged: (text) {
                    //ensures the text is cable of being a double if not tell user
                    if (double.tryParse(text) != null) {
                      widget.brain.miscSettings[widget.title] = double.parse(text);
                    } else {
                    
                      setState(() {
                         controller.text =
                          controller.text.substring(0, controller.text.length);
                      });
                     
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
