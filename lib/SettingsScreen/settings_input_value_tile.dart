import 'package:flutter/material.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_brain.dart';

class InputValueTileSettings extends StatefulWidget {
  InputValueTileSettings({Key? key, required this.title, required this.brain})
      : super(key: key);

  String title;
  SettingsBrain brain;

  @override
  State<InputValueTileSettings> createState() => _InputValueTileSettingsState();
}

class _InputValueTileSettingsState extends State<InputValueTileSettings> {
  TextEditingController controller = TextEditingController();
@override
  void initState() {
    
    super.initState();
    if( widget.brain.miscSettings[widget.title] != null){
  controller.text =  widget.brain.miscSettings[widget.title].toString();
    }
    

  }
  @override
  Widget build(BuildContext context) {

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
