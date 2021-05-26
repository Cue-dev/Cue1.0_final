import 'package:Cue/screen/dialog/create_saved_list_dialog.dart';
import 'package:Cue/services/auth_provider.dart';
import 'package:Cue/services/database.dart';
import 'package:Cue/services/reference_video.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScriptDialog extends StatefulWidget {
  final ScriptDialog videoToPlay;
  ScriptDialog({Key key, @required this.videoToPlay}) : super(key: key);
  @override
  _ScriptDialogState createState() => _ScriptDialogState();
}

class _ScriptDialogState extends State<ScriptDialog> {

  @override
  Widget build(BuildContext context) {
    final double mh = MediaQuery
        .of(context)
        .size
        .height;
    final double mw = MediaQuery
        .of(context)
        .size
        .width;
  }
}