// import 'package:flutter/animation.dart';
// import 'package:flutter/material.dart';

// class ReadyDialog extends StatefulWidget {
//   @override
//   _ReadyDialogState createState() => _ReadyDialogState();
// }

// class _ReadyDialogState extends State<ReadyDialog>
//     with TickerProviderStateMixin {
//   AnimationController controller;

//   String get timerString {
//     Duration duration = controller.duration * controller.value;
//     return '${(duration.inSeconds % 60)+1}';
//   }

//   @override
//   void initState() {
//     super.initState();
//     controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 3),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData themeData = Theme.of(context);
//     return Scaffold(
//       backgroundColor: Colors.white10,
//       body:
//       AnimatedBuilder(
//           animation: controller,
//           builder: (context, child) {
//             return Stack(
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Expanded(
//                         child: Align(
//                           alignment: FractionalOffset.center,
//                           child: AspectRatio(
//                             aspectRatio: 1.0,
//                             child: Align(
//                                   alignment: FractionalOffset.center,
//                                   child:Text(
//                                         timerString,
//                                         style: TextStyle(
//                                             fontSize: 112.0,
//                                             color: Colors.white),
//                                       ),
//                                 ),
//                           ),
//                         ),
//                       ),
//                       AnimatedBuilder(
//                           animation: controller,
//                           builder: (context, child) {
//                             return FloatingActionButton.extended(
//                                 onPressed: () {
//                                   if (controller.isAnimating)
//                                     controller.stop();
//                                   else {
//                                     controller.reverse(
//                                         from: controller.value == 0.0
//                                             ? 1.0
//                                             : controller.value);
//                                   }
//                                 },
//                                 label: Text(
//                                     controller.isAnimating ? "Pause" : "Play"));
//                           }),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           }),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ReadyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 3000)),
        builder: (context, snapshot) {
// Checks whether the future is resolved, ie the duration is over
          if (snapshot.connectionState == ConnectionState.done)
            return FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 1500)),
                builder: (context, cueSnap) {
                  if (cueSnap.connectionState == ConnectionState.done)
                    Navigator.pop(context);
                  else
                    return Dialog(
                      insetPadding: EdgeInsets.all(0),
                      backgroundColor: Colors.transparent,
                      child: Center(
                        child: Text(
                          'Cue!',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontSize: 25),
                        ),
                      ),
                    );
                });
          else
            return Dialog(
              insetPadding: EdgeInsets.all(0),
              backgroundColor: Colors.transparent,
              child: Center(
                child: Text(
                  'Ready,',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontSize: 25),
                ),
              ),
            ); // Return empty container to avoid build errors
        });
  }
}
