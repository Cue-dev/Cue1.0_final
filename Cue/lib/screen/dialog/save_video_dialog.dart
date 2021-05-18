import 'package:Cue/screen/dialog/create_video_list_dialog.dart';
import 'package:Cue/services/auth_provider.dart';
import 'package:Cue/services/database.dart';
import 'package:Cue/services/reference_video.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaveVideoDialog extends StatefulWidget {
  final ReferenceVideo videoToSave;
  SaveVideoDialog({Key key, @required this.videoToSave}) : super(key: key);
  @override
  _SaveVideoDialogState createState() => _SaveVideoDialogState();
}

class _SaveVideoDialogState extends State<SaveVideoDialog> {
  List<String> savedList = [];
  List<bool> checked = [];

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<AuthProvider>(context).getUID;
    DatabaseService db = DatabaseService(uid: uid);

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text('영상+대본 저장 목록'),
      content: StreamBuilder(
          stream: db.userCollection
              .doc(uid)
              .collection('savedVideoList')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) return Container();
            snapshot.data.docs.forEach((doc) =>
                savedList.contains(doc.id) ? null : savedList.add(doc.id));
            for (int i = 0; i < savedList.length; i++) checked.add(false);
            return savedListSection();
          }),
      actions: <Widget>[
        FlatButton(
          child: Text(
            '취소',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('확인'),
          onPressed: () async {
            for (int j = 0; j < savedList.length; j++) {
              checked[j]
                  ? await db.saveVideo(savedList[j], widget.videoToSave)
                  : null;
            }
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget savedListSection() {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (int i = 0; i < savedList.length; i++)
            Row(children: [
              Checkbox(
                checkColor: Theme.of(context).primaryColor,
                activeColor: Theme.of(context).secondaryHeaderColor,
                onChanged: (bool value) {
                  setState(() {
                    checked[i] = value;
                  });
                },
                value: checked[i],
              ),
              Text(
                savedList[i],
              ),
            ]),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          InkWell(
            child: Text(
              '+ 저장 목록 추가',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CreateVideoListDialog();
                  });
            },
          ),
        ],
      ),
    );
  }
}
