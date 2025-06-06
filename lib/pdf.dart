import 'dart:convert';

import 'package:loisbowlingwebsite/Brackets/bracket.dart';
import 'package:loisbowlingwebsite/bowler.dart';
import 'package:loisbowlingwebsite/doublePartner.dart';
import 'package:loisbowlingwebsite/team.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:universal_html/html.dart';

class PDFBrain {
  double fontsize = 7;
  //this border makers black lines on the grid go white
  var borderStyle = PdfBorders(
      left: PdfPen.fromBrush(PdfBrushes.white),
      right: PdfPen.fromBrush(PdfBrushes.white),
      top: PdfPen.fromBrush(PdfBrushes.white),
      bottom: PdfPen.fromBrush(PdfBrushes.white));

  Future createSinglesPdf(List<Bowler> bowlers, int games, int outof,
      int percent, String division, List<int> gamesSelected) async {
    bool isSidePot = false;
    // int columnsAdded = 0;

    if (division.contains('No Division') != true) {
      isSidePot = true;
      // columnsAdded = games;
    }
    //start sa documenting
    PdfDocument document = PdfDocument();
    //adds a page which we can start writting on
    var page = document.pages.add();
    //this is the table
    PdfGrid grid = PdfGrid();

    //how many columns are in a row
    grid.columns.add(count: 5 + games);
    //how many headers
    grid.headers.add(1);

    //this is the header row
    PdfGridRow header = grid.headers[0];

    //header values for row 1 and 2
    header.cells[0].value = 'Name';
    header.cells[1].value = 'Average';
    header.cells[2].value = 'Handicap';
    header.cells[3 + games].value = 'ScrTotal';
    header.cells[4 + games].value = 'HdTotal';

    //ensures borders are white
    header.cells[0].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0),
        font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
      ..borders = borderStyle;
    header.cells[1].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0),
        font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
      ..borders = borderStyle;
    header.cells[2].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0),
        font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
      ..borders = borderStyle;
    header.cells[3 + games].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0),
        font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
      ..borders = borderStyle;
    header.cells[4 + games].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0),
        font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
      ..borders = borderStyle;

    for (int i = 0; i < games; i++) {
      header.cells[3 + i].value = ('Game' + (i + 1).toString());

      header.cells[3 + i].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
    }

    //goes through every bowler adding name average
    for (Bowler bowler in bowlers) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
      row.cells[1].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
      row.cells[2].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
      row.cells[3 + games].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
      row.cells[4 + games].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
      row.cells[0].value = (bowlers.indexOf(bowler) + 1).toString() +
          ' ' +
          (bowler.firstName + ' ' + bowler.lastName);
      row.cells[1].value = bowler.average.toString();
      row.cells[2].value = bowler.findHandicap(outof, percent).toString();

      //goes through every game and adds the score
      for (int i = 0; i < games; i++) {
        if (gamesSelected.isEmpty || gamesSelected.contains(i + 1)) {
          row.cells[3 + i].value =
              (bowler.scores!['A']?[(i + 1).toString()] ?? 0).toString();
        }
        row.cells[3 + i].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;
      }
      if (isSidePot || gamesSelected.isNotEmpty) {
        //goes through every game and adds the score
        PdfGridRow handicapRow = grid.rows.add();
        handicapRow.cells[0].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;
        handicapRow.cells[1].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;
        handicapRow.cells[2].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;
        handicapRow.cells[games + 3].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;
        handicapRow.cells[games + 4].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;
        for (int i = 0; i < games; i++) {
          if (gamesSelected.isEmpty || gamesSelected.contains(i + 1)) {
            handicapRow.cells[3 + i].value =
                ((bowler.scores!['A']?[(i + 1).toString()] ?? 0) +
                        (bowler.findHandicap(outof, percent)))
                    .toString();
          }

          handicapRow.cells[3 + i].style = PdfGridCellStyle(
              cellPadding: PdfPaddings(left: 0, right: 0),
              font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
            ..borders = borderStyle;
        }
        makeSpace(grid, games);
      }

      row.cells[3 + games].value = bowler
          .findScoreForSquad('A', outof, percent, false, gamesSelected)
          .toString();
      row.cells[4 + games].value = bowler
          .findScoreForSquad('A', outof, percent, true, gamesSelected)
          .toString();
    }

    //draws grid on the page
    grid.draw(
      page: page,
    );
    //convers to 01010100101
    List<int> bytes = document.save();
    //close document
    document.dispose();
    //saves pdf in downlaods on web
    saveAndLaunc(bytes, 'download.pdf');
  }

  Future createTeamsPdf(List<Team> teams, int games, int outof, int percent,
      List<int> gamesSelected) async {
    //start sa documenting
    PdfDocument document = PdfDocument();
    //adds a page which we can start writting on
    var page = document.pages.add();
    //this is the table
    PdfGrid grid = PdfGrid();

    //how many columns are in a row
    grid.columns.add(count: 5 + games);
    //how many headers
    grid.headers.add(1);

    //this is the header row
    PdfGridRow header = grid.headers[0];

    //header values for row 1 and 2
    header.cells[0].value = 'Name';
    header.cells[1].value = 'Average';
    header.cells[2].value = 'Handicap';
    header.cells[3 + games].value = 'ScrTotal';
    header.cells[4 + games].value = 'HdTotal';

    //ensures borders are white
    header.cells[0].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0),
        font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
      ..borders = borderStyle;
    header.cells[1].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0),
        font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
      ..borders = borderStyle;
    header.cells[2].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0),
        font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
      ..borders = borderStyle;
    header.cells[3 + games].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0),
        font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
      ..borders = borderStyle;
    header.cells[4 + games].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0),
        font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
      ..borders = borderStyle;

    for (int i = 0; i < games; i++) {
      header.cells[3 + i].value = ('Game' + (i + 1).toString());
      header.cells[3 + i].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
    }

    //goes through every bowler adding name average
    for (Team team in teams) {
      for (Bowler bowler in team.bowlers.values) {
        PdfGridRow row = grid.rows.add();
        row.cells[0].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;
        row.cells[1].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;
        row.cells[2].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;
        row.cells[3 + games].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;
        row.cells[4 + games].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;

        row.cells[0].value = (teams.indexOf(team) + 1).toString() +
            ' ' +
            (bowler.firstName + ' ' + bowler.lastName);
        row.cells[1].value = bowler.average.toString();
        row.cells[2].value = bowler.findHandicap(outof, percent).toString();

        //goes through every game and adds the score
        for (int i = 0; i < games; i++) {
          if (gamesSelected.isEmpty || gamesSelected.contains(i + 1)) {
            row.cells[3 + i].value =
                (bowler.scores!['A']?[(i + 1).toString()] ?? 0).toString();
          }

          row.cells[3 + i].style = PdfGridCellStyle(
              cellPadding: PdfPaddings(left: 0, right: 0),
              font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
            ..borders = borderStyle;
        }

        row.cells[3 + games].value = bowler
            .findScoreForSquad('A', outof, percent, false, gamesSelected)
            .toString();
        row.cells[4 + games].value = bowler
            .findScoreForSquad('A', outof, percent, true, gamesSelected)
            .toString();
      }
      //these athe totals at the bottom
      PdfGridRow totalRow = grid.rows.add();
      totalRow.cells[1].value = team.findTeamTotalAverage().toString();
      totalRow.cells[2].value =
          team.findTeamTotalHandicap(outof, percent).toString();
      totalRow.cells[1].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
      totalRow.cells[2].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
      totalRow.cells[0].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;

      //goes through every game and adds the score
      for (int i = 0; i < games; i++) {
        if (gamesSelected.isEmpty || gamesSelected.contains(i + 1)) {
          totalRow.cells[3 + i].value =
              team.findTeamGameTOtal('A', i + 1).toString();
        }

        totalRow.cells[3 + i].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;
      }

      totalRow.cells[3 + games].value =
          team.findTeamScratchTotal(outof, percent, gamesSelected).toString();
      totalRow.cells[4 + games].value =
          team.findTeamTotal(outof, percent, gamesSelected).toString();
      totalRow.cells[3 + games].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
      totalRow.cells[4 + games].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;

      //adds space in between teams
      makeSpace(grid, games);
    }

    // makeSpace(grid, games);

    //draws grid on the page
    grid.draw(
      page: page,
    );
    //convers to 01010100101
    List<int> bytes = document.save();
    //close document
    document.dispose();

    //saves pdf in downlaods on web
    saveAndLaunc(bytes, 'download.pdf');
  }

  Future createDoublesPdf(List<DoublePartners> doubles, int games, int outof,
      int percent, List<int> gamesSelected) async {
    //start sa documenting
    PdfDocument document = PdfDocument();
    //adds a page which we can start writting on
    var page = document.pages.add();
    //this is the table
    PdfGrid grid = PdfGrid();

    //how many columns are in a row
    grid.columns.add(count: 5 + games);
    //how many headers
    grid.headers.add(1);

    //this is the header row
    PdfGridRow header = grid.headers[0];

    //header values for row 1 and 2
    header.cells[0].value = 'Name';
    header.cells[1].value = 'Average';
    header.cells[2].value = 'Handicap';
    header.cells[3 + games].value = 'ScrTotal';
    header.cells[4 + games].value = 'HdTotal';

    //ensures borders are white
    header.cells[0].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0),
        font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
      ..borders = borderStyle;
    header.cells[1].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0),
        font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
      ..borders = borderStyle;
    header.cells[2].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0),
        font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
      ..borders = borderStyle;
    header.cells[3 + games].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0),
        font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
      ..borders = borderStyle;
    header.cells[4 + games].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0),
        font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
      ..borders = borderStyle;

    for (int i = 0; i < games; i++) {
      header.cells[3 + i].value = ('Game' + (i + 1).toString());
      header.cells[3 + i].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
    }

    //goes through every bowler adding name average
    for (DoublePartners doubleTeam in doubles) {
      for (Bowler bowler in doubleTeam.bowlers) {
        PdfGridRow row = grid.rows.add();
        row.cells[0].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;
        row.cells[1].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;
        row.cells[2].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;
        row.cells[3 + games].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;
        row.cells[4 + games].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;

        row.cells[0].value = (doubles.indexOf(doubleTeam) + 1).toString() +
            ' ' +
            (bowler.firstName + ' ' + bowler.lastName);
        row.cells[1].value = bowler.average.toString();
        row.cells[2].value = bowler.findHandicap(outof, percent).toString();

        //goes through every game and adds the score
        for (int i = 0; i < games; i++) {
          if (gamesSelected.isEmpty || gamesSelected.contains(i + 1)) {
            row.cells[3 + i].value =
                (bowler.scores!['A']?[(i + 1).toString()] ?? 0).toString();
          }

          row.cells[3 + i].style = PdfGridCellStyle(
              cellPadding: PdfPaddings(left: 0, right: 0),
              font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
            ..borders = borderStyle;
        }

        row.cells[3 + games].value = bowler
            .findScoreForSquad('A', outof, percent, false, gamesSelected)
            .toString();
        row.cells[4 + games].value = bowler
            .findScoreForSquad('A', outof, percent, true, gamesSelected)
            .toString();
      }
      //these athe totals at the bottom
      PdfGridRow totalRow = grid.rows.add();
      totalRow.cells[1].value = doubleTeam.findDoublesTotalAverage(gamesSelected.length).toString();
      totalRow.cells[2].value =
          doubleTeam.findDoublesTotalHandicap(outof, percent).toString();
      totalRow.cells[1].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
      totalRow.cells[2].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
      totalRow.cells[0].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;

      //goes through every game and adds the score
      for (int i = 0; i < games; i++) {
        if (gamesSelected.isEmpty || gamesSelected.contains(i + 1)) {
          totalRow.cells[3 + i].value =
              doubleTeam.findDoublesGameTOtal('A', i + 1).toString();
        }

        totalRow.cells[3 + i].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;
      }

      totalRow.cells[3 + games].value = doubleTeam
          .findDoublesScratchTotal(outof, percent, gamesSelected)
          .toString();
      totalRow.cells[4 + games].value =
          doubleTeam.findTeamTotal(outof, percent, gamesSelected).toString();
      totalRow.cells[3 + games].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
      totalRow.cells[4 + games].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;

      //adds space in between teams
      makeSpace(grid, games);
    }

    // makeSpace(grid, games);

    //draws grid on the page
    grid.draw(
      page: page,
    );
    //convers to 01010100101
    List<int> bytes = document.save();
    //close document
    document.dispose();
    //saves pdf in downlaods on web
    saveAndLaunc(bytes, 'download.pdf');
  }

  Future createBracketsPdf(List<Bracket> brackets, int games, int outof,
      int percent, List<int> gamesSelected) async {
    brackets.sort((a, b) => a.division.compareTo(b.division));
    //start sa documenting
    PdfDocument document = PdfDocument();
    //adds a page which we can start writting on
    var page = document.pages.add();
    //this is the table
    PdfGrid grid = PdfGrid();

    //how many columns are in a row
    grid.columns.add(count: 1 + games);
    // grid.headers.add(1);
    // PdfGridRow header = grid.headers[0];

    // //header values for row 1 and 2
    // header.cells[0].value = 'Division';

    // //ensures borders are white
    // header.cells[0].style = PdfGridCellStyle(
    //     cellPadding: PdfPaddings(left: 0, right: 0),
    //     font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
    //   ..borders = borderStyle;
    // header.cells[1].style = PdfGridCellStyle(
    //     cellPadding: PdfPaddings(left: 0, right: 0),
    //     font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
    //   ..borders = borderStyle;
    // header.cells[2].style = PdfGridCellStyle(
    //     cellPadding: PdfPaddings(left: 0, right: 0),
    //     font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
    //   ..borders = borderStyle;
    // header.cells[3 ].style = PdfGridCellStyle(
    //     cellPadding: PdfPaddings(left: 0, right: 0),
    //     font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
    //   ..borders = borderStyle;
    //       header.cells[4].style = PdfGridCellStyle(
    //     cellPadding: PdfPaddings(left: 0, right: 0),
    //     font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
    //   ..borders = borderStyle;
    int count = 0;
    //goes through every bowler adding name average
    for (Bracket bracket in brackets) {
      if (count % 6 == 0) {
        makeSpaceBrackets(grid, games);
      }
      count++;
      int personInBracket = 1;
      PdfGridRow row = grid.rows.add();
      row.cells[0].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
      bracket.findWinnersOfGameOne(
          bracket.division == 'Handicap', outof, percent);
      bracket.findWinnersOfGametwo(
          bracket.division == 'Handicap', outof, percent);
      bracket.findWinnersOfGamethree(
          bracket.division == 'Handicap', outof, percent);
      row.cells[0].value = 'Bracket Num: ' +
          bracket.id.toString() +
          ' ' +
          bracket.division +
          (bracket.isTie ? ' TIE' : '');
      row.cells[1].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(
            PdfFontFamily.helvetica,
            fontsize,
          ))
        ..borders = borderStyle;

      row.cells[2].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;

      row.cells[3].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
      // row.cells[4].style = PdfGridCellStyle(
      //     cellPadding: PdfPaddings(left: 0, right: 0),
      //     font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
      //   ..borders = borderStyle;

      for (Bowler bowler in bracket.bowlers) {
        PdfGridRow row = grid.rows.add();
        row.cells[0].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(left: 0, right: 0),
            font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
          ..borders = borderStyle;
        double scoreHandicap = 0;

        if (bracket.division == 'Handicap') {
          scoreHandicap = bowler.findHandicap(outof, percent).toDouble();
        }
        row.cells[0].value = (bowler.firstName + ' ' + bowler.lastName) +
            ' ' +
            ((bowler.scores!['A']?[(1).toString()] ?? 0) + scoreHandicap)
                .toString();

        //goes through every game and adds the score
        for (int i = 0; i < games; i++) {
          if ((gamesSelected.isEmpty || gamesSelected.contains(i + 1))) {
            if (i == 0) {
              if (bracket
                  .findWinnersOfGameOne(
                      bracket.division == 'Handicap', outof, percent)
                  .contains(bowler)) {
                double scoreHandicap = 0;

                if (bracket.division == 'Handicap') {
                  scoreHandicap =
                      bowler.findHandicap(outof, percent).toDouble();
                }
                row.cells[1 + i].value =
                    (bowler.firstName + ' ' + bowler.lastName) +
                        ' ' +
                        ((bowler.scores!['A']?[(2).toString()] ?? 0) +
                                scoreHandicap)
                            .toString();
              }
            } else if (i == 1) {
              if (bracket
                  .findWinnersOfGametwo(
                      bracket.division == 'Handicap', outof, percent)
                  .contains(bowler)) {

                  List<Bowler> bowlersWhoMadeIt = bracket
                  .findWinnersOfGametwo(
                      bracket.division == 'Handicap', outof, percent);

                  //finds the best bowler of those who made it whoever is the best wins
                  int indexOfBestBowler = -1;
                  double scoreOfBestBowler = 0;
                  for(Bowler bowler in bowlersWhoMadeIt){
                    var bowlerHandicap =  bowler.findHandicap(outof, percent).toDouble();
                    var bowlerScore = (bowler.scores!['A']?[(3).toString()] ?? 0);
                    if((bowlerScore + bowlerHandicap) > scoreOfBestBowler){
                      scoreOfBestBowler = bowlerScore + bowlerHandicap;
                      indexOfBestBowler = bowlersWhoMadeIt.indexOf(bowler);
                    }
                  }
                
                String moneyAdd = '';
                if(bowler == bowlersWhoMadeIt[indexOfBestBowler]){
                  moneyAdd = '    \$10';
                }

                double scoreHandicap = 0;

                if (bracket.division == 'Handicap') {
                  scoreHandicap =
                      bowler.findHandicap(outof, percent).toDouble();
                }
                row.cells[1 + i].value =
                    (bowler.firstName + ' ' + bowler.lastName) +
                        ' ' +
                        ((bowler.scores!['A']?[(3).toString()] ?? 0) +
                                scoreHandicap)
                            .toString() + moneyAdd;
              }
            } else if (i == 2) {
              if (bracket
                  .findWinnersOfGamethree(
                      bracket.division == 'Handicap', outof, percent)
                  .contains(bowler)) {
                row.cells[1 + i].value =
                    (bowler.firstName + ' ' + bowler.lastName + '  \$25');
              }
            }

            row.cells[1 + i].style = PdfGridCellStyle(
                cellPadding: PdfPaddings(left: 0, right: 0),
                font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
              ..borders = borderStyle;
          }
          personInBracket += 1;
        }
        //this add the lines in between each bracket so multiple fit on a sheet

      }
      PdfGridRow totalRow = grid.rows.add();
    }

    // makeSpace(grid, games);

    //draws grid on the page
    grid.draw(
      page: page,
    );
    //convers to 01010100101
    List<int> bytes = document.save();
    //close document
    document.dispose();

    //saves pdf in downlaods on web
    saveAndLaunc(bytes, 'download.pdf');
  }

  void makeSpace(PdfGrid grid, int games) {
    PdfGridRow row = grid.rows.add();
    row.height = 20;
    for (int i = 0; i < games + 5; i++) {
      row.cells[i].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
    }
  }

  void makeSpaceBrackets(PdfGrid grid, int games) {
    PdfGridRow row = grid.rows.add();
    row.height = 40;
    for (int i = 0; i < games + 1; i++) {
      row.cells[i].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 0, right: 0),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontsize))
        ..borders = borderStyle;
    }
  }

  Future<void> saveAndLaunc(List<int> bytes, String fileName) async {
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", fileName)
      ..click();
  }
}
