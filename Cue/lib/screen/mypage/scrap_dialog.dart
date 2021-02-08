import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  List<bool> checked = [false, false, false, false, false, false];
  List<String> scraplist = ['좋아하는 영화 명대사', '딕션 연습', '눈물 연기 연습', '분노 연기 연습'];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      title: Text('스크랩 목록'),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          children: [
            for (int i = 0; i < 4; i++)
              Row(children: [
                Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      checked[i] = value;
                    });
                  },
                  value: checked[i],
                ),
                Text(
                  scraplist[i],
                ),
              ]),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text('+새로운 목록 추가하기',
                style: TextStyle(fontSize: 10, color: Colors.blue)),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('취소'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('확인'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
