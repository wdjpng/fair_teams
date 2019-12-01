import 'sqliteDatabaseHelpers.dart';

/// A simple class to handle the Players.

class Player implements Comparable<Player> {
  int groupId;
  int playerId;
  String name;

  /// Compares two players based on their name
  int compareTo(Player other) {
    return name.compareTo(other.name);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnGroupId: groupId,
      columnPlayerId: playerId
    };

    return map;
  }

  ///Creates an event based on a map
  Player.fromMap(Map<String, dynamic> map) {
    name = map[columnName];
    groupId = map[columnGroupId];
    playerId = map[columnPlayerId];
  }

  Player(String name, int playerId, int groupId) {
    this.name = name;
    this.playerId = playerId;
    this.groupId = groupId;
  }
}
