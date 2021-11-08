import 'package:flutter/material.dart';
import 'package:lois_bowling_website/LoginScreen/custom_button.dart';
import 'package:lois_bowling_website/TournamentCreateNewScreen/tournament_createnew_screen.dart';
import 'package:lois_bowling_website/TournamentSelectScreen.dart/tournament_select_brain.dart';
import 'package:lois_bowling_website/TournamentSelectScreen.dart/tournament_selection_class.dart';
import 'package:lois_bowling_website/TournamentSelectScreen.dart/tournament_tile.dart';
import 'package:lois_bowling_website/constants.dart';

class SelectTournamentScreen extends StatefulWidget {
 SelectTournamentScreen({ Key? key }) : super(key: key);

  @override
  State<SelectTournamentScreen> createState() => _SelectTournamentScreenState();
}

class _SelectTournamentScreenState extends State<SelectTournamentScreen> {
  List<TournamentSelection> usersTournaments = [];
@override
  void initState() {
    super.initState();
    _loadTournaments();

  }

  _loadTournaments(){
    TournamentSelectBrain().getTournaments().then((tournamentsFromDB) {
      setState(() {
        usersTournaments = tournamentsFromDB;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Stack(
        
          children: [
            Positioned.fill(child: Image.asset('images/background.png', fit: BoxFit.fill,)),
            Padding(
              padding: EdgeInsets.fromLTRB(Constants.sizeOfScreen.width * 0.2, Constants.sizeOfScreen.height * 0.1, Constants.sizeOfScreen.width * 0.2, 0),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Constants.lightBlue,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: Column(
                      children:  [
                        const Text('Welcome User', style: TextStyle( fontSize: 36, fontWeight: FontWeight.w800)),
                       const Text('Here are your avaliable tournaments', style: TextStyle( fontSize: 30, fontWeight: FontWeight.w500)),
                       const SizedBox(
                          height: 30,
                        ),
                        CustomButton(buttonTitle: 'Create New', onClicked: ()async {
       Navigator.pushNamed(context, Constants.tournamentCreate);
                         
                        }),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: ListView.builder(
                     
                            itemCount: usersTournaments.length,
                            itemBuilder: (context, index){
                            
                            return TournamentTile(tournament: usersTournaments[index],);
                          }),
                        )
                          
                      
                      ],
                    ),
                )
      
      
                ],
             
              ),
      
            )
      
          ],
      
        ),
      ),
      
    );
  }
}