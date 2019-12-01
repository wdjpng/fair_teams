import 'sqliteDatabaseHelpers.dart';

/// A simple class to handle the Groups.

class Group implements Comparable<Group> {
  int groupId;
  String name;

  /// Compares two Groups based on their name
  int compareTo(Group other) {
    return name.compareTo(other.name);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnGroupId: groupId
    };

    return map;
  }

  ///Creates an event based on a map
  Group.fromMap(Map<String, dynamic> map) {
    name = map[columnName];
    groupId = map[columnGroupId];
  }

  Group(String name, int groupId) {
    this.name = name;
    this.groupId = groupId;
  }
}
