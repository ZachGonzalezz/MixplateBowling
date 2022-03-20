import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/LoginScreen/custom_button.dart';
import 'package:loisbowlingwebsite/SettingsScreen/DivisionSettings/doubles_divisions_list.dart';
import 'package:loisbowlingwebsite/SettingsScreen/DivisionSettings/singles_division_list.dart';
import 'package:loisbowlingwebsite/SettingsScreen/DivisionSettings/teams_divisions_list.dart';
import 'package:loisbowlingwebsite/SettingsScreen/settings_brain.dart';
import 'package:loisbowlingwebsite/constants.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/basic_screen_layout.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/squad_picker.dart';

class DivisionSettingsHome extends StatefulWidget {
  DivisionSettingsHome({Key? key, this.brain}) : super(key: key);

  SettingsBrain? brain = SettingsBrain();

  @override
  State<DivisionSettingsHome> createState() => _DivisionSettingsHomeState();
}

class _DivisionSettingsHomeState extends State<DivisionSettingsHome> {
  //this laods the division on first build after that does not do it
  bool isFirstTimeload = true;
  @override
  void initState() {
    super.initState();
    Constants.saveTournamentIdBeforeRefresh();
    
  }

  @override
  Widget build(BuildContext context) {
    widget.brain = ModalRoute.of(context)!.settings.arguments as SettingsBrain;
    if (isFirstTimeload) {
      widget.brain!.loadDivisions().then((value) {
        setState(() {
          isFirstTimeload = false;
        });
      });
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context, Constants.settingsHome);
        return Future(() => true);
      },
      child: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          body: ScreenLayout(
              height: 1200,
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
                          CustomButton(
                            buttonTitle: 'Save Settings',
                            length: 300,
                            onClicked: () {
                              widget.brain!.saveDivisionSettings();
                            },
                          ),
                          Text(
                            Constants.tournamentName,
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 30),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SquadPicker(
                            brain: widget.brain!,
                            numberOfSquads: (widget.brain!.miscSettings['Squads'] ?? 1).toInt(),
                            chnageSquads: (text) {
                              setState(() {
                                widget.brain!.divisionSelectedSquad = text;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const TabBar(tabs: [
                            Tab(
                              child: Text('Singles',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700)),
                            ),
                            Tab(
                              child: Text('Doubles',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700)),
                            ),
                            Tab(
                              child: Text('Teams',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ]),
                          SizedBox(
                            height: 600,
                            child: TabBarView(children: [
                              Tab(
                                  child: SinglesDivisionList(
                                      brain: widget.brain!)),
                              Tab(
                                child: DoubleDivisionList(brain: widget.brain!),
                              ),
                              Tab(
                                child: TeamsDivisionList(brain: widget.brain!),
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
      ),
    );
  }
}
