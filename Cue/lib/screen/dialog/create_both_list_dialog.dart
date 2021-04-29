import 'package:Cue/services/auth_provider.dart';
import 'package:Cue/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateBothListDialog extends StatefulWidget {
  @override
  _CreateBothListDialogState createState() => _CreateBothListDialogState();
}

class _CreateBothListDialogState extends State<CreateBothListDialog> {
  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<AuthProvider>(context).getUID();
    DatabaseService db = DatabaseService(uid: uid);

    return AlertDialog(
      title: Text('TextField in Dialog'),
      content: TextField(
        controller: _textFieldController,
        decoration: InputDecoration(hintText: "Text Field in Dialog"),
      ),
      actions: <Widget>[
        InkWell(
          child: Text('CANCEL'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        InkWell(
          child: Text('OK'),
          onTap: () async {
            print("oooooooooooooooo" + _textFieldController.text.trim());
            await db.createSaveBothList(_textFieldController.text.trim());
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
