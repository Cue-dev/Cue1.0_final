import 'package:Cue/services/auth_provider.dart';
import 'package:Cue/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateSavedListDialog extends StatefulWidget {
  final bool isVideo;
  CreateSavedListDialog({Key key, @required this.isVideo}) : super(key: key);
  @override
  _CreateSavedListDialogState createState() => _CreateSavedListDialogState();
}

class _CreateSavedListDialogState extends State<CreateSavedListDialog> {
  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<AuthProvider>(context).getUID;
    DatabaseService db = DatabaseService(uid: uid);
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      title: Text('저장 목록 추가'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: TextField(
        controller: _textFieldController,
        decoration: InputDecoration(hintText: "새 목록의 이름을 정해주세요"),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            '취소',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: Colors.grey),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(
            '추가',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          onPressed: () async {
            widget.isVideo
                ? await db
                    .createSavedVideoList(_textFieldController.text.trim())
                : await db
                    .createSavedScriptList(_textFieldController.text.trim());

            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
