import 'package:flutter/material.dart';
import 'package:lois_bowling_website/SettingsScreen/DivisionSettings/checkbox_tile.dart';
import 'package:lois_bowling_website/SettingsScreen/DivisionSettings/squad_picker.dart';
import 'package:lois_bowling_website/SettingsScreen/setting_section_tile.dart';
import 'package:lois_bowling_website/SettingsScreen/settings_brain.dart';
import 'package:lois_bowling_website/basic_screen_layout.dart';
import 'package:lois_bowling_website/constants.dart';

class DivisionSettingsHome extends StatefulWidget {
  DivisionSettingsHome({Key? key, this.brain}) : super(key: key);

  SettingsBrain? brain = SettingsBrain();

  @override
  State<DivisionSettingsHome> createState() => _DivisionSettingsHomeState();
}

class _DivisionSettingsHomeState extends State<DivisionSettingsHome> {
  @override
  Widget build(BuildContext context) {

      widget.brain ??= SettingsBrain();
    
    return DefaultTabController(
       initialIndex: 0,
      length: 3,
      child: Scaffold(
        body: ScreenLayout(
            selected: 'Settings',
            child: Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.15,
                    MediaQuery.of(context).size.height * 0.15,
                    MediaQuery.of(context).size.width * 0.15,
                    0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Constants.lightBlue,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          Constants.tournamentName,
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 30),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SquadPicker(),
                         const SizedBox(
                          height: 20,
                        ),

                        const TabBar(tabs: [
                          Tab(
                            child: Text('Singles', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700)),
                          ),
                          Tab(
                            child: Text('Doubles', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700)),
                          ),
                          Tab(
                            child: Text('Teams',style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700)),
                          ),

                        ]),

                        SizedBox(
                          height: 200,
                          child: TabBarView(children: [

                            Tab(
                              child: Column(
                                children: [
                                  CheckBoxTile(title: 'Singles Scratch', brain: widget.brain!, isGreyedOut: widget.brain!.greyOutBoxed.contains('Singles Scratch'), changeValues: (isChecked){
                                    //remove function
                                    setState(() {
                                      widget.brain!.newBoxedChecked(isChecked, 'Singles Scratch');
                                      
                                    });
                                    
                                 
                                    
                                  })
                                ],
                              ),
                            ),
                            Tab(
                              child: Text('Doubles'),
                            ),
                            Tab(
                              child: Text('Teams'),
                            ),
                          ]),
                        )

                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
