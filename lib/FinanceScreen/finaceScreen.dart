import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/AddDoublePartner/partner_brain.dart';
import 'package:loisbowlingwebsite/SettingsScreen/SidePotScreen/sidepot_brain.dart';
import 'package:loisbowlingwebsite/SettingsScreen/settings_brain.dart';
import 'package:loisbowlingwebsite/bowler.dart';
import 'package:loisbowlingwebsite/constants.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/basic_screen_layout.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/search_bar.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({Key? key}) : super(key: key);

  @override
  _FinanceScreenState createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  SettingsBrain brain = SettingsBrain();
  List<Map<String, dynamic>> sidepots = [];
  int amountOfSquads = 1;
  int outOf = 200;
  int percent = 100;
  int entryFee = 0;

  List<String> divisions = ['No Division'];

  String selectedSquad = 'A';
  //this keeps track of which division is selecter per Squad sotred in {"A" : "A Singles (One Division)"}
  Map<String, String> selectedDivisions = {};

  //this is the original array from the database
  List<Bowler> bowlers = [];
  //this this the list returned
  List<Bowler> results = [];

  //this is the list of double partners the user has selected
  Map<String, List<String>> doublePartner = {};
  @override
  void initState() {
    super.initState();
    loadTournamentSettings();
    loadBowlers();
    callSidePots();
  }

  void loadBowlers() {
    DoublePartner.loadBowlers().then((bowlersFromDB) {
      setState(() {
        bowlers = bowlersFromDB;
        results = bowlersFromDB;
      });
    });
  }

  void callSidePots() {
    SidePotBrain().getSidePots().then((value) {
      setState(() {
        sidepots = value;
      });
    });
  }

//loads the number of squads in the current tournament (based on name held in local storage)
  void loadTournamentSettings() {
    SettingsBrain().getMainSettings().then((basicSettings) {
      setState(() {
        amountOfSquads = (basicSettings['Squads'] ?? 1).toInt();
        percent = (basicSettings['Handicap Percentage'] ?? 100).toInt();
        outOf = (basicSettings['Handicap Amount'] ?? 200).toInt();
        entryFee = (basicSettings['Entrys Fee'] ?? 0).toInt();
      });
    });
    //loads all the divisions and squads
    SettingsBrain().loadDivisions().then((divisionFromDB) {
      setState(() {
        divisions = divisionFromDB;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenLayout(
        selected: 'Finances',
        child: SingleChildScrollView(
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
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Padding(padding: EdgeInsets.all(8),
                            // child: IconButton(onPressed: (){
                            //   Navigator.pop(context);
                            // }, icon: Icon(MdiIcons.chevronLeft)),),
                            SizedBox(
                              height: 20,
                            ),

                            SizedBox(height: 30),
                            CustomSearchBar(
                                backTo: Constants.createNewBowler,
                                onChange: (text) {
                                  //when user types in search bar automatically changes who pops up
                                  setState(() {
                                    results = DoublePartner.filterBowlers(
                                        outOf: outOf,
                                        percent: percent,
                                        bowlers: bowlers,
                                        search: text);
                                  });
                                }),
                            SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: ListView.builder(
                                  itemCount: results.length + 1,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: index == 0
                                          ? Text(
                                              'Name',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700),
                                            )
                                          : Text(
                                              results[index - 1].firstName +
                                                  ' ' +
                                                  results[index - 1].lastName +
                                                  ' \$' +
                                                  results[index - 1]
                                                      .findAmountOwedStill(
                                                          entryFee, sidepots)
                                                      .toString(),
                                              style: TextStyle(
                                                  color: results[index - 1]
                                                              .findAmountOwedStill(
                                                                  entryFee,
                                                                  sidepots) >
                                                          0
                                                      ? Colors.red
                                                      : null),
                                            ),
                                      trailing: SizedBox(
                                          width: 600,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                index == 0
                                                    ? Text(
                                                        'Due     ',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      )
                                                    : Text('\$' +
                                                        results[index - 1]
                                                            .findAmountOwed(
                                                                entryFee,
                                                                sidepots)
                                                            .toString()),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                index == 0
                                                    ? Text(
                                                        'Paid  ',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      )
                                                    : SizedBox(
                                                        width: (100 *
                                                                    results[index -
                                                                            1]
                                                                        .findFinaceSidePots()
                                                                        .length)
                                                                .toDouble() +
                                                            100,
                                                        child: ListView.builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount: 1 +
                                                                results[index -
                                                                        1]
                                                                    .findFinaceSidePots()
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    indexBox) {
                                                              TextEditingController
                                                                  paidText =
                                                                  TextEditingController(
                                                                      text: (results[index - 1].financesPaid['Entry Fee'] ??
                                                                              '')
                                                                          .toString());
                                                              return SizedBox(
                                                                  width: 100,
                                                                  child: indexBox ==
                                                                          0
                                                                      ? TextField(
                                                                          controller:
                                                                              paidText,
                                                                          onChanged:
                                                                              (text) {
                                                                            if (text == '' ||
                                                                                paidText.text == '0') {
                                                                              text = '';
                                                                            }
                                                                            if (int.tryParse(text) !=
                                                                                null) {
                                                                              results[index - 1].financesPaid['Entry Fee'] = int.parse(text);
                                                                              results[index - 1].updateBowlerFinances();
                                                                            }
                                                                          },
                                                                          style:
                                                                              TextStyle(color: Colors.green),
                                                                          decoration: InputDecoration(
                                                                              label: Text('Entry Fee'),
                                                                              hintText: entryFee.toString(),
                                                                              hintStyle: TextStyle(color: Colors.red),
                                                                              floatingLabelBehavior: FloatingLabelBehavior.always),
                                                                        )
                                                                      : TextField(
                                                                          controller: paidText
                                                                            ..text =
                                                                                (results[index - 1].financesPaid[results[index - 1].findFinaceSidePots()[indexBox - 1]] ?? '').toString(),
                                                                          onChanged:
                                                                              (text) {
                                                                            if (text == '' ||
                                                                                text == '0') {
                                                                              text = '';
                                                                            }
                                                                            if (int.tryParse(text) !=
                                                                                null) {
                                                                              results[index - 1].financesPaid[results[index - 1].findFinaceSidePots()[indexBox - 1]] = int.parse(text);
                                                                              results[index - 1].updateBowlerFinances();
                                                                            }
                                                                          },
                                                                          style:
                                                                              TextStyle(color: Colors.green),
                                                                          decoration: InputDecoration(
                                                                              hintText: results[index - 1].findAmountNeededForSidepot(results[index - 1].findFinaceSidePots()[indexBox - 1], sidepots).toString(),
                                                                              hintStyle: TextStyle(color: Colors.red),
                                                                              label: Text(results[index - 1].findFinaceSidePots()[indexBox - 1]),
                                                                              floatingLabelBehavior: FloatingLabelBehavior.always),
                                                                        ));
                                                            }),
                                                      )
                                              ])),
                                    );
                                  }),
                            ),
                          ])),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
