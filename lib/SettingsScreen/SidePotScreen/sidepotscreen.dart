import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/LoginScreen/custom_button.dart';
import 'package:loisbowlingwebsite/SettingsScreen/SidePotScreen/sidepot_brain.dart';
import 'package:loisbowlingwebsite/SettingsScreen/SidePotScreen/sidepotnew.dart';
import 'package:loisbowlingwebsite/constants.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/basic_screen_layout.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SidePotScreen extends StatefulWidget {
  const SidePotScreen({Key? key}) : super(key: key);

  @override
  State<SidePotScreen> createState() => _SidePotScreenState();
}

class _SidePotScreenState extends State<SidePotScreen> {
  List<Map<String, dynamic>> sidepots = [];

  @override
  void initState() {
    super.initState();
    callSidePots();
  }

  void callSidePots() {
    SidePotBrain().getSidePots().then((value) {
      setState(() {
        sidepots = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, Constants.settingsHome);
        return true;
      },
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
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(MdiIcons.chevronLeft)),
                        ),
                        Text('Side Pots',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 30)),
                        SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                            buttonTitle: 'Add New',
                            onClicked: () async {
                              Map<String, dynamic> newSidePot =
                                  await showDialog(
                                          context: context,
                                          builder: (context) => SidePotNew()) ??
                                      {};
                              if (newSidePot.isNotEmpty) {
                                setState(() {
                                  sidepots.add(newSidePot);
                                });
                              }
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          flex: 5,
                          child: ListView.builder(
                              itemCount: sidepots.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: ListTile(
                                    leading: Text(
                                      sidepots[index].keys.first.toString(),
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    trailing: SizedBox(
                                      width: 200,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            child: TextField(
                                              onChanged: (text) {
                                                if (int.tryParse(text) != null) {
                                                  SidePotBrain().update(
                                                      sidepots[index]
                                                          .keys
                                                          .first
                                                          .toString(),
                                                      text,
                                                      sidepots[index]
                                                          .values
                                                          .first
                                                          .toString());

                                                  sidepots[index][sidepots[index]
                                                          .keys
                                                          .first
                                                          .toString()] =
                                                      int.parse(text);
                                                }
                                              },
                                              textAlign: TextAlign.center,
                                              controller: TextEditingController(
                                                  text: sidepots[index]
                                                      .values
                                                      .first
                                                      .toString()),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                SidePotBrain().delete(
                                                    sidepots[index]
                                                        .keys
                                                        .first
                                                        .toString(),
                                                    sidepots[index]
                                                        .values
                                                        .first
                                                        .toString());
                                                setState(() {
                                                  sidepots.removeAt(index);
                                                });
                                              },
                                              icon: Icon(MdiIcons.trashCan))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
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
