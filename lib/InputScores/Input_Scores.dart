import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:loisbowlingwebsite/AddDoublePartner/partner_brain.dart';
import 'package:loisbowlingwebsite/InputScores/image_to_scores.dart';
import 'package:loisbowlingwebsite/InputScores/input_score_brain.dart';
import 'package:loisbowlingwebsite/InputScores/scoreboard.dart';
import 'package:loisbowlingwebsite/LoginScreen/custom_button.dart';
import 'package:loisbowlingwebsite/SettingsScreen/settings_brain.dart';
import 'package:loisbowlingwebsite/bowler.dart';
import 'package:loisbowlingwebsite/constants.dart';
import 'package:loisbowlingwebsite/responsive.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/basic_screen_layout.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/division_picker.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/search_bar.dart';
import 'package:loisbowlingwebsite/universal_ui.dart/squad_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InputScoreScreen extends StatefulWidget {
  const InputScoreScreen({Key? key}) : super(key: key);

  @override
  _InputScoreScreenState createState() => _InputScoreScreenState();
}

class _InputScoreScreenState extends State<InputScoreScreen> {
  @override
  SettingsBrain brain = SettingsBrain();
  ImageToScores picBrain = ImageToScores();
  int amountOfSquads = 1;
  int nmOfGames = 1;
  InputScoreBrain scoreBrain = InputScoreBrain();
  String finalText = '';
  bool isLoading = false;

  List<String> divisions = ['No Division'];

  String selectedSquad = 'A';
  //this keeps track of which division is selecter per Squad sotred in {"A" : "A Singles (One Division)"}
  Map<String, String> selectedDivisions = {};

  //this is the original array from the database
  List<Bowler> bowlers = [];
  //this this the list returned
  List<Bowler> results = [];
  int outOf = 200;
  int percent = 100;

  @override
  void initState() {
    super.initState();
    loadTournamentSettings();
    loadBowlers();
  }

  void loadBowlers() {
    DoublePartner.loadBowlers().then((bowlersFromDB) {
      setState(() {
        bowlers = bowlersFromDB;
        if (Responsive.isMobileOs(context) != true) {
          results = bowlersFromDB;
        }
        scoreBrain.bowlers = bowlersFromDB;
      });
    });
  }

//loads the number of squads in the current tournament (based on name held in local storage)
  void loadTournamentSettings() {
    SettingsBrain().getMainSettings().then((basicSettings) {
      setState(() {
        amountOfSquads = (basicSettings['Squads'] ?? 1).toInt();
        nmOfGames = (basicSettings['Games'] ?? 1).toInt();
        percent = (basicSettings['Handicap Percentage'] ?? 100).toInt();
        outOf = (basicSettings['Handicap Amount'] ?? 200).toInt();
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
        selected: 'Scores',
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: Responsive.isMobileOs(context)
                  ? EdgeInsets.zero
                  : EdgeInsets.fromLTRB(
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
                child: SafeArea(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Responsive.isMobileOs(context)
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(MdiIcons.chevronLeft)),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: Responsive.isMobileOs(context) ? 0 : 20,
                              ),
                              Builder(
                                builder: (ctx) => Center(
                                  child: CustomButton(
                                    buttonTitle: 'Save Scores',
                                    length: 300,
                                    onClicked: () {
                                      ScaffoldMessenger.of(ctx).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Saved',
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      );
                                      if (Responsive.isMobileOs(context) !=
                                          true) {
                                        scoreBrain.saveScores();
                                      } else {
                                        List<Bowler> bowlersNotInDB = results
                                            .where((element) =>
                                                element.bowlerDoesExistInDB !=
                                                true)
                                            .toList();
                                        List<Bowler> bowlersInDb = results
                                            .where((element) =>
                                                element.bowlerDoesExistInDB)
                                            .toList();
                                        picBrain.checkIfAllBowlersExists(
                                            bowlersInDb,
                                            bowlersNotInDB,
                                            context);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //this picks which division the user is in
                                  DivisionPicker(
                                    division: divisions,
                                    selectedSquad: selectedSquad,
                                    selectedDivision: selectedDivisions,
                                    onDivisionChange: (newDivision) {
                                      selectedDivisions[selectedSquad] =
                                          newDivision;

                                      if (newDivision != '  No Division') {
                                        setState(() {
                                          results = DoublePartner.filterBowlers(
                                            outOf: outOf,
                                            percent: percent,
                                            bowlers: bowlers,
                                            search: '',
                                            divison: selectedDivisions[
                                                selectedSquad],
                                            squad: selectedSquad,
                                          );
                                        });
                                      } else {
                                        setState(() {
                                          results = bowlers;
                                        });
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  SquadPicker(
                                      brain: null,
                                      numberOfSquads: amountOfSquads,
                                      //when picker is change changes the selected squad whichd determines which division are shown
                                      chnageSquads: (squad) {
                                        setState(() {
                                          selectedSquad = squad;
                                        });
                                      }),
                                ],
                              ),
                              SizedBox(height: 30),
                              Responsive.isMobileOs(context)
                                  ? Center(
                                      child: TextButton(
                                          onPressed: isLoading
                                              ? null
                                              : () {
                                                  getImage();
                                                },
                                          child: Text(
                                              'Import Scores Through Photo')),
                                    )
                                  : SizedBox(),
                              CustomSearchBar(
                                  backTo: Constants.settingsHome,
                                  onChange: (text) {
                                    //when user types in search bar automatically changes who pops up
                                    setState(() {
                                      results = DoublePartner.filterBowlers(
                                          bowlers: bowlers,
                                          search: text,
                                          divison:
                                              selectedDivisions[selectedSquad],
                                          squad: selectedSquad,
                                          outOf: outOf,
                                          percent: percent);
                                    });
                                  }),
                              SizedBox(
                                height: 40,
                              ),
                              ScoreBoard(
                                nmOfGames: nmOfGames,
                                results: results,
                                scoreBrain: scoreBrain,
                                selectedSquad: selectedSquad,
                                moveOneDown: (index, game) {
                                  setState(() {
                                    results = ImageToScores()
                                        .moveOneDown(results, index, game);
                                  });
                                },
                                moveOneUp: (index, game) {
                                  //  setState(() {
                                  //   results = ImageToScores().moveOneUp(results, index, game);
                                  // });
                                },
                              ),
                            ])),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // this is for getting the image form the gallery
  void getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery, maxWidth: 2000, maxHeight: 2000);
    if (image != null) {
      // getText(image.path);
      var bytes = io.File(image.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      var url = Uri.parse('https://api.ocr.space/parse/image');
      var payload = {
        "base64Image": "data:image/jpg;base64,${img64.toString()}"
      };
      var header = {"apikey": 'K89597926388957'};

      setState(() {
        isLoading = true;
      });
      var post = await http.post(url, body: payload, headers: header);
      var result = jsonDecode(post.body);
      print('image found');
      setState(() {
        isLoading = false;
      });
      setState(() {
        // finalText = '';
        // finalText = result.toString();
        print(result.toString());
        finalText = result['ParsedResults'][0]['ParsedText'];
      });
      List<String> blocks = finalText.split('\n');
      for (int i = 0; i < blocks.length; i++) {
        blocks[i] = blocks[i]
            .replaceAll(' ', '')
            .replaceAll(',', '')
            .replaceAll('\n', '')
            .replaceAll('\t', '')
            .replaceAll('\b', '')
            .replaceAll('\r', '')
            .toString();
      }

      setState(() {
        finalText = blocks.toString();
        isLoading = false;
      });
      if (picBrain.isGoodToContinue(blocks) == '') {
        blocks.remove('(CompletedGamesOnly)');
        blocks.remove('\b');
        blocks.remove('\t');
        blocks.remove('\r');
        blocks.remove('');
        blocks.remove('');
        blocks.remove('');
        blocks.remove('Scratch');
        blocks.remove('Gold');
        blocks.remove('GoldCoast');
        blocks.remove('GoldCoastLanes');
        // blocks.remove('Handicap');

        blocks.remove('');
        blocks.remove('ScoresRecap');
        // blocks.removeRange(blocks.indexOf('Average'), blocks.indexOf('Game'));
        // blocks.removeRange(blocks.indexOf('Lane'), blocks.indexOf('Name'));
        // blocks.removeRange(blocks.indexOf('Series'), blocks.length -1);
        // blocks.removeRange(blocks.indexOf('HDCP'), blocks.length -1);
        // blocks.removeRange(blocks.indexOf('Handicap'), (blocks.indexOf('Handicap') + findNames(blocks).length));
        setState(() {
          results = picBrain.makeTable(blocks, bowlers);
        });
      } else {
        print(picBrain.isGoodToContinue(blocks));
      }
    } else {
      print('no image');
    }
  }
}
