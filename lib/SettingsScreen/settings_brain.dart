class SettingsBrain {
  List<String> divisions = [];
  //these are the settings on the settings home screen
  Map<String, double> miscSettings = {};

//these are the boxes that are unavaible to be checked
  List<String> greyOutBoxed = [];

  List<String> divisionsChecked = [];

//this is called everytime a new box is checked
  void newBoxedChecked(bool isChecking, String title) {

    if (isChecking) {
      switch (title) {
        case ('Singles Scratch'):
        //adds the division to divisions check array to be saved to db
          divisionsChecked.add('Singles Scratch');
          //removes any conflicting buttons
          addToGreyOut(['']);
          
          break;
        default:
      }
    } else {
      //this is called when ischecking is false meaning the box is checked already so they are removing it
      uncheckBox(title);
    }
  }

//called when user unchecks a box
  void uncheckBox(String title){
  switch (title) {
        case ('Singles Scratch'):
        //removes the division to divisions check array to be saved to db
          divisionsChecked.remove('Singles Scratch');
          
          //ensures that buttons are no clickable bc seetings have been changed
          removeFromGreyOut(['']);
          break;
        default:
      }
  }

//this means you are adding to the list of added division your tournament will have
  void addToGreyOut(List<String> tittles) {
    tittles.forEach((title) {
      greyOutBoxed.add(title);
    });
  }

//this means that you are removing because a conflict for exmaple if they check hadnicap and scratch combine into one must remove everything else
  void removeFromGreyOut(List<String> tittles) {
    tittles.forEach((title) {
      greyOutBoxed.remove(title);
    });
  }
}
