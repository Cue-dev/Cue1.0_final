import 'package:Cue/auth.dart';
import 'package:Cue/services/colors.dart';
import 'package:flutter/material.dart';

final ThemeData _cueTheme = _buildCueTheme();

ThemeData _buildCueTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    accentColor: cuePointColor,
    primaryColor: cuePrimaryColor,
    secondaryHeaderColor: cueSecondaryColor,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: cueSecondaryColor,
    ),
    buttonBarTheme: base.buttonBarTheme.copyWith(
      buttonTextTheme: ButtonTextTheme.accent,
    ),
    scaffoldBackgroundColor: cueDartBackgroundColor,
    cardColor: cueDartBackgroundColor,
    textSelectionColor: cuePointColor,
    errorColor: cueErrorRed,
    textTheme: _buildCueTextTheme(base.textTheme),
    primaryTextTheme: _buildCueTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildCueTextTheme(base.accentTextTheme),
  );
}

TextTheme _buildCueTextTheme(TextTheme base) {
  return base.copyWith(
    headline1: base.headline1!.copyWith(
      // 로그인 화면 어플 로고
      fontWeight: FontWeight.w500,
      letterSpacing: 2.0,
      fontSize: 60.0,
      fontFamily: 'HelveticaMedium',
    ),
    headline2: base.headline2!.copyWith(
      // 앱바 어플 로고
      fontWeight: FontWeight.w500,
      fontSize: 30,
      color: cueSecondaryColor,
      fontFamily: 'HelveticaMedium',
    ),
    subtitle1: base.subtitle1!.copyWith(
      // 영상의 제목
      fontSize: 13,
      fontWeight: FontWeight.w600,
      //fontFamily: GoogleFonts.notoSans().fontFamily,
      fontFamily: 'NotoSansCJK',
    ),
    subtitle2: base.subtitle2!.copyWith(
      // 영화나 드라마의 제목
      fontWeight: FontWeight.w500,
      fontSize: 11.0,
      color: cueSecondaryColor,
      //fontFamily: GoogleFonts.notoSans().fontFamily,
      fontFamily: 'NotoSansCJK',
    ),
    bodyText1: base.bodyText1!.copyWith(
      // 보디 텍스트
      fontSize: 11.0,
      //fontFamily: GoogleFonts.notoSans().fontFamily,
      fontFamily: 'NotoSansCJK',
    ),
    caption: base.caption!.copyWith(
      // 해시태그
      fontWeight: FontWeight.w400,
      fontSize: 11.0,
      color: cuePointColor,
      //fontFamily: GoogleFonts.notoSans().fontFamily,
      fontFamily: 'NotoSansCJK',
    ),
  );
}

class CueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cue!',
      theme: _cueTheme,
      home: SplashPage(),
      debugShowCheckedModeBanner: false,
      // initialRoute: '/login',
      // onGenerateRoute: _getRoute,
    );
  }
}

// Route<dynamic> _getRoute(RouteSettings settings) {
//   if (settings.name != '/login') {
//     return null;
//   }

//   return MaterialPageRoute<void>(
//     settings: settings,
//     builder: (BuildContext context) => SplashPage(),
//     fullscreenDialog: true,
//   );
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(
//         Duration(seconds: 2),
//         () => Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => LogIn())));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Colors.orange, child: Image.asset('images/splash.png'));
//   }
// }

// SHARED PREFERENCE

//Future<void> main() async {
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  var token = prefs.getString('token');
//  print(token);
//  runApp(MaterialApp(home: token == null ? LogIn() : MyHomePage()));
//}
