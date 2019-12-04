import 'package:fair_teams/Player.dart';
import 'package:fair_teams/PlayerEditorTile.dart';
import 'package:trotter/trotter.dart';
import 'dart:math';

class TeamGenerator {
  static List<PlayerEditorTile> generateTeams(
      int numberOfTeams, List<Player> players) {
    List<PlayerEditorTile> output = [];

    int numberOfPermutations = 1;
    for (int i = 2;
        i * numberOfPermutations < 100000 && i <= players.length;
        i++) {
      numberOfPermutations *= i;
    }

    numberOfTeams = min(numberOfTeams, players.length);

    var random = new Random();
    var permutation = Permutations(
        players.length, players)[random.nextInt(numberOfPermutations)];

    int currentItem = 0;
    int separatorCounter = 1;
    for (int i = 0; i < numberOfTeams; i++) {
      int numberOfPlayersInThisTeam = (players.length / numberOfTeams).floor();
      if (i < players.length % numberOfTeams) {
        numberOfPlayersInThisTeam++;
      }

      PlayerEditorTile editorTile = new PlayerEditorTile();
      editorTile.isSeparator = true;
      editorTile.separatorIndex = separatorCounter;
      output.add(editorTile);

      separatorCounter++;

      for (int j = 0; j < numberOfPlayersInThisTeam; j++) {
        PlayerEditorTile editorTile = new PlayerEditorTile();
        editorTile.player = permutation[currentItem];
        output.add(editorTile);
        currentItem++;
      }
    }

    if (numberOfTeams == 0) {
      for (int i = 0; i < players.length; i++) {
        PlayerEditorTile editorTile = new PlayerEditorTile();
        editorTile.player = players[i];
        output.add(editorTile);
      }
    }
    return output;
  }
}
