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
    String valueText;
    String uid = Provider.of<AuthProvider>(context).getUID();
    DatabaseService db = DatabaseService(uid: uid);

    return AlertDialog(
      title: Text('TextField in Dialog'),
      content: TextField(
        onChanged: (value) {
          setState(() {
            valueText = value;
          });
        },
        controller: _textFieldController,
        decoration: InputDecoration(hintText: "Text Field in Dialog"),
      ),
      actions: <Widget>[
        InkWell(
          child: Text('CANCEL'),
          onTap: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        InkWell(
          child: Text('OK'),
          onTap: () {
            setState(() async {
              await db.createSaveBothList(valueText);
              Navigator.pop(context);
            });
          },
        ),
      ],
    );
  }
}
