import 'pages/groupEditor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(AgendaApp());
}

class AgendaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'FairTeams',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GroupSelectorPage(),
    );
  }
}
