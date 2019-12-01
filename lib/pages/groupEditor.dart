import 'package:fair_teams/sqliteDatabaseHelpers.dart';
import 'package:flutter/material.dart';
import 'package:fair_teams/Group.dart';
import 'playerEditor.dart';

/// This widget is used to select the subjects whose events the user wants to
/// see in the [EventPage].
class GroupSelectorPage extends StatefulWidget {
  @override
  _GroupSelectorPage createState() => new _GroupSelectorPage();
}

class _GroupSelectorPage extends State<GroupSelectorPage> {
  List<Group> groups = [];

  /// Reads the subjects from the offline sqlite database and stores them in the
  /// [subjects] map.
  void _readGroups() async {
    SqliteDatabaseHelper helper = SqliteDatabaseHelper.instance;
    List<Map> maps = await helper.getGroupes();

    if (maps.length > 0) {
      groups = [];
      for (var i = 0; i < maps.length; i++) {
        groups.add(Group.fromMap(maps[i]));
      }
    }

    setState(() {});
  }

  void loadNewGroup(String name) async {
    SqliteDatabaseHelper helper = SqliteDatabaseHelper.instance;
    int id = await helper.insertGroup(name);

    setState(() {
      _readGroups();
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlayerEditorPage(
                  groupId: id,
                )));
  }

  @override
  void initState() {
    _readGroups();
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
                  itemCount: groups.length + 1,
                  itemBuilder: (context, position) {
                    if (position == groups.length) {
                      return groups.length == 0
                          ? Column(
                              children: <Widget>[
                                TextField(
                                    onSubmitted: (newValue) {
                                      loadNewGroup(newValue);
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
                                loadNewGroup(newValue);
                              },
                              textInputAction: TextInputAction.done,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Name'));
                    }

                    final item = GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlayerEditorPage(
                                    groupId: groups[position].groupId,
                                  )));
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height *0.04,
                              child: Text(
                                groups[position].name,
                                style: TextStyle(fontSize: 22.0),
                              )
                            ),
                          ),
                        ));
                    return Dismissible(
                        key: Key(groups[position].groupId.toString()),
                        child: item,
                        onDismissed: (direction) {
                          SqliteDatabaseHelper instance = SqliteDatabaseHelper.instance;
                          instance.deleteGroup(groups[position].groupId);
                          instance.deletePlayerByGroupId(groups[position].groupId);

                          _readGroups();
                        },
                        // Show a red background as the item is swiped away.
                        background: Container(color: Colors.red));
                  }))
        ]));
  }
}
