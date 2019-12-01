import 'dart:io';
import 'package:fair_teams/Group.dart';
import 'package:fair_teams/Player.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

final String tableEvents = 'events';
final String columnId = 'id';
final String columnDateOfEvent = 'dateOfEvent';
final String columnMessage = 'message';

final String tableSubjects = 'subjects';
final String columnIsSelected = 'isSelected';
final String columnName = 'name';

final String tableGroups = 'groups';
final String tablePlayers = 'players';

final String columnGroupId = 'groupId';
final String columnPlayerId = 'playerId';

/// Class to manage the sqlite database.
/// Source: https://pusher.com/tutorials/local-data-flutter.
class SqliteDatabaseHelper {
  /// This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "sqliteData.db";

  /// Increment this version when you need to change the schema.
  static final _databaseVersion = 2;

  SqliteDatabaseHelper._privateConstructor();

  static final SqliteDatabaseHelper instance =
      SqliteDatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  /// Opens the database.
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  /// Creates the subjects and events database tables.
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableGroups (
                $columnGroupId INTEGER PRIMARY KEY,
                $columnName TEXT NOT NULL
              )
              ''');
    await db.execute('''
              CREATE TABLE $tablePlayers (
                $columnPlayerId INTEGER PRIMARY KEY,
                $columnGroupId INTEGER NOT NULL,
                $columnName TEXT NOT NULL
              )
              ''');
  }

  Future<List<Map>> getGroupes() async {
    Database db = await database;
    List<Map> groups = await db.query(tableGroups);
    return groups;
  }

  Future<List<Map>> getPlayers(int groupId) async {
    Database db = await database;
    List<Map> players = await db
        .query(tablePlayers, where: '$columnGroupId = ?', whereArgs: [groupId]);
    return players;
  }


  /// Inserts group into sqlite database.
  Future<int> insertGroup(String name) async {
    Database db = await database;
    int id = await db.insert(tableGroups, {columnName: name});
    return id;
  }

  Future<int> deleteGroup(int groupId) async {
    Database db = await database;
    int id = await db.delete(tableGroups, where: '$columnGroupId = ?', whereArgs: [groupId]);
    return id;
  }

  Future<int> deletePlayer(int playerId) async {
    Database db = await database;
    int id = await db.delete(tablePlayers, where: '$columnPlayerId = ?', whereArgs: [playerId]);
    return id;
  }

  Future<int> deletePlayerByGroupId(int groupId) async {
    Database db = await database;
    int id = await db.delete(tablePlayers, where: '$columnGroupId = ?', whereArgs: [groupId]);
    return id;
  }

  Future<int> updateGroup(Group group) async {
    Database db = await database;
    return await db.update(tablePlayers, group.toMap(),
        where: '$columnId = ?', whereArgs: [group.groupId]);
  }

  Future<int> updatePlayer(Player player) async {
    Database db = await database;
    return await db.update(tablePlayers, player.toMap(),
        where: '$columnId = ?', whereArgs: [player.playerId]);
  }

  Future<int> insertPlayer(String name, int groupId) async {
    Database db = await database;
    int id = await db
        .insert(tablePlayers, {columnName: name, columnGroupId: groupId});

    return id;
  }
}
