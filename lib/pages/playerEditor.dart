import 'package:fair_teams/Player.dart';
import 'package:fair_teams/sqliteDatabaseHelpers.dart';
import 'package:flutter/material.dart';

/// This widget is used to select the subjects whose events the user wants to
/// see in the [EventPage].
class PlayerEditorPage extends StatefulWidget {
  final int groupId;

  PlayerEditorPage({Key key, this.groupId}) : super(key: key);

  @override
  _PlayerEditorPage createState() => new _PlayerEditorPage(groupId);
}

class _PlayerEditorPage extends State<PlayerEditorPage> {
  List<Player> players = [];
  int groupId;

  _PlayerEditorPage(int groupId) {
    this.groupId = groupId;
  }

  /// Reads the subjects from the offline sqlite database and stores them in the
  /// [subjects] map.
  void _readPlayers() async {
    SqliteDatabaseHelper helper = SqliteDatabaseHelper.instance;
    List<Map> maps = await helper.getPlayers(groupId);

    if (maps.length > 0) {
      players = [];
      for (var i = 0; i < maps.length; i++) {
        players.add(Player.fromMap(maps[i]));
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    _readPlayers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('FairTeams'),
        elevation: 0.0,
      ),
      body: new Column(children: <Widget>[
        /// The expander for the ListView
        new Expanded(
            child: new ListView.builder(
                itemCount: players.length + 1,
                itemBuilder: (context, position) {
                  if (position == players.length) {
                    return players.length == 0
                        ? Column(
                            children: <Widget>[
                              TextField(
                                  onSubmitted: (newValue) {
                                    SqliteDatabaseHelper instance =
                                        SqliteDatabaseHelper.instance;
                                    instance.insertPlayer(newValue, groupId);

                                    _readPlayers();
                                  },
                                  textInputAction: TextInputAction.done,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Name')),
                            ],
                          )
                        : TextField(
                            onSubmitted: (newValue) {
                              SqliteDatabaseHelper instance =
                                  SqliteDatabaseHelper.instance;
                              instance.insertPlayer(newValue, groupId);

                              _readPlayers();
                            },
                            textInputAction: TextInputAction.done,
                            maxLines: 1,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Name'));
                  }

                  final item = GestureDetector(
                      child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: Text(
                            players[position].name,
                            style: TextStyle(fontSize: 22.0),
                          )),
                    ),
                  ));
                  return Dismissible(
                      key: Key(players[position].playerId.toString()),
                      child: item,
                      onDismissed: (direction) {
                        SqliteDatabaseHelper instance =
                            SqliteDatabaseHelper.instance;
                        instance.deletePlayer(players[position].playerId);

                        _readPlayers();
                        //Dirty workaround
                        players.removeLast();
                      },
                      // Show a red background as the item is swiped away.
                      background: Container(color: Colors.red));
                }))
      ]),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Create teams',
        child: Icon(Icons.chevron_right),
      ),
    );
  }
}
