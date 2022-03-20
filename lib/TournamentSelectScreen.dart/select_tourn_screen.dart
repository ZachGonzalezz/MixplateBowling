
import 'package:flutter/material.dart';
import 'package:loisbowlingwebsite/LoginScreen/custom_button.dart';
import 'package:loisbowlingwebsite/TournamentSelectScreen.dart/tournament_select_brain.dart';
import 'package:loisbowlingwebsite/TournamentSelectScreen.dart/tournament_selection_class.dart';
import 'package:loisbowlingwebsite/TournamentSelectScreen.dart/tournament_tile.dart';
import 'package:loisbowlingwebsite/constants.dart';
import 'package:loisbowlingwebsite/responsive.dart';
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
              padding: Responsive.isMobileOs(context) ?  EdgeInsets.zero : EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.2, MediaQuery.of(context).size.height * 0.1, MediaQuery.of(context).size.width * 0.2, 0),
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
                      Responsive.isMobileOs(context) ? const SizedBox() :  const Text('Welcome User', style: TextStyle( fontSize: 36, fontWeight: FontWeight.w800)),
                           Responsive.isMobileOs(context) ? const SizedBox() :   const Text('Here are your avaliable tournaments', style: TextStyle( fontSize: 30, fontWeight: FontWeight.w500)),
                           Responsive.isMobileOs(context) ? const SizedBox() :   const SizedBox(
                          height: 30,
                        ),
                           Responsive.isMobileOs(context) ? const SizedBox() :   CustomButton(buttonTitle: 'Create New', onClicked: ()async {
                          
       Navigator.pushNamed(context, Constants.tournamentCreate);
                         
                        }, ),
                          Responsive.isMobileOs(context) ? const SizedBox() :    const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height:     Responsive.isMobileOs(context) ?  MediaQuery.of(context).size.height * 1 :   MediaQuery.of(context).size.height * 0.65,
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