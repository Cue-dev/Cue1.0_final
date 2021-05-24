import 'package:Cue/screen/Cam/record_dubbing.dart';
import 'package:Cue/screen/Cam/video_recording.dart';
import 'package:Cue/services/reference_video.dart';
import 'package:flutter/material.dart';

class CueDialog extends StatefulWidget {
  final ReferenceVideo videoToPlay;
  CueDialog({Key key, @required this.videoToPlay}) : super(key: key);

  @override
  _CueDialogState createState() => _CueDialogState();
}

class _CueDialogState extends State<CueDialog> {
  List<String> _actorOptions = [];
  List<bool> _selected = [];

  List<String> _actingOptions = ['영상', '더빙'];
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _actorOptions.clear();
    _selected.clear();

    for (int i = 0; i < widget.videoToPlay.script.keys.length ~/ 2; i++) {
      _actorOptions
          .add("${widget.videoToPlay.script['a' + (i + 1).toString()]}");
      _selected.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double mh = MediaQuery.of(context).size.height;
    final double mw = MediaQuery.of(context).size.width;

    return Dialog(
        insetPadding: EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
        child: Column(
          children: [
            SizedBox(
              height: mh * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: mw * 0.6,
                ),
                InkWell(
                  child: Text('취소'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(
              height: mh * 0.25,
            ),
            buildDialogCenterPart(),
            SizedBox(
              height: mh * 0.25,
            ),
            //TODO: 이거 버튼으로 바꿔야지
            InkWell(
              child: Text('Cue! 를 하려면 여기를 탭 해주세요!'),
              onTap: () {
                // TODO: 배역정한거 넘겨야함
                if (_selectedIndex == 0)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => VideoRecordingPage(
                                originalVideo: widget.videoToPlay,
                              )));
                else if (_selectedIndex == 1)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => DubbingPage(
                                originalVideo: widget.videoToPlay,
                              )));
                else {
                  //TODO: 영상, 혹은 더빙을 골라주세요! 라고 showDialog..?
                }
              },
            )
          ],
        ));
  }

  Widget buildDialogCenterPart() {
    List<Widget> filterChips = List();
    List<Widget> choiceChips = List();

    print(_actorOptions);
    print(_selected);

    for (int i = 0; i < widget.videoToPlay.script.keys.length ~/ 2; i++) {
      FilterChip filterChip = FilterChip(
        selected: _selected[i],
        label: Text(
          _actorOptions[i],
          style: Theme.of(context).textTheme.headline6.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
        showCheckmark: false,
        elevation: 10,
        pressElevation: 5,
        backgroundColor: Colors.grey,
        selectedColor: Theme.of(context).secondaryHeaderColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onSelected: (bool selected) {
          setState(() {
            _selected[i] = selected;
            print(_selected[i]);
          });
        },
      );

      filterChips.add(Padding(
        padding: EdgeInsets.all(10),
        child: filterChip,
      ));
    }

    for (int j = 0; j < _actingOptions.length; j++) {
      ChoiceChip choiceChip = ChoiceChip(
        label: Text(
          _actingOptions[j],
          style: Theme.of(context).textTheme.headline6.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
        selected: _selectedIndex == j,
        elevation: 10,
        pressElevation: 5,
        backgroundColor: Colors.grey,
        selectedColor: Theme.of(context).secondaryHeaderColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedIndex = j;
            }
          });
        },
      );

      choiceChips.add(Container(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: choiceChip,
        ),
      ));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: filterChips,
        ),
        Text('을(를)'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: choiceChips,
        ),
        Text('으로 연기할래요!'),
      ],
    );
  }
}
