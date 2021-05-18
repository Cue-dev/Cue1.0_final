import 'package:Cue/services/auth_provider.dart';
import 'package:Cue/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateScriptListDialog extends StatefulWidget {
  @override
  _CreateScriptListDialogState createState() => _CreateScriptListDialogState();
}

class _CreateScriptListDialogState extends State<CreateScriptListDialog> {
  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<AuthProvider>(context).getUID;
    DatabaseService db = DatabaseService(uid: uid);
//TODO: 이거 좀 이쁘게 꾸며야함
    return AlertDialog(
      title: Text('저장 목록 추가'),
      content: TextField(
        controller: _textFieldController,
        decoration: InputDecoration(hintText: "목록의 이름을 정해주세요"),
      ),
      actions: <Widget>[
        InkWell(
          child: Text('취소'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        InkWell(
          child: Text('추가'),
          onTap: () async {
            await db.createSavedScriptList(_textFieldController.text.trim());
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
