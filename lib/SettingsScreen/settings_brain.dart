class SettingsBrain {
  List<String> divisions = [];
  //these are the settings on the settings home screen
  Map<String, double> miscSettings = {};

  List<String> greyOutBoxed = [];

  void newBoxedChecked(bool isChecking, String title) {
    if (isChecking) {
      switch (title) {
        case ('Singles Scratch'):
          addToGreyOut(['Singles Scratch']);
          removeFromGreyOut(['tittles']);
          break;
        default:
      }
    } else {}
  }

  void addToGreyOut(List<String> tittles) {
    tittles.forEach((title) {
      greyOutBoxed.add(title);
    });
  }

  void removeFromGreyOut(List<String> tittles) {
    tittles.forEach((title) {
      greyOutBoxed.remove(title);
    });
  }
}
