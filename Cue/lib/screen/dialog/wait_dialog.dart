import 'package:flutter/material.dart';

// TODO: 너무 안이뻐..
class WaitDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      child: Center(
        child: Text(
          "영상 인코딩 중입니다.\n\n  잠시 기다려주세요!",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}
