import 'package:Cue/services/auth_provider.dart';
import 'package:flutter/material.dart';
// import 'package:cue/services/loading.dart';
import 'package:Cue/screen/LogIn/forget_page.dart';
import 'package:Cue/screen/LogIn/register_page.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  // bool _success;
  // bool _loading = false;
  String? _userEmail;
  // String _email = '';
  // String _pw = '';
  // SharedPreferences _prefs;
  @override
  void initState() {
    super.initState();
    // _loadId();
  }

  // _loadId() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _email = (_prefs.getString('email') ?? '');
  //     _pw = (_prefs.getString('pw') ?? '');
  //     _emailController.text = _prefs.getString('email');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final double mh = MediaQuery.of(context).size.height;
    final double mw = MediaQuery.of(context).size.width;

    return
        // _loading
        //     ? Loading()
        //     :
        Scaffold(
      body: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: mh * 0.2)),
                  Center(
                    child: Text(
                      'Cue!',
                      style: TextStyle(
                          fontFamily: 'Rochester',
                          letterSpacing: 2.0,
                          fontSize: 60.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).secondaryHeaderColor),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.only(top: mh * 0.15),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: mw * 0.036),
                            height: mh * 0.07,
                            width: mw * 0.78,
                            child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'ID',
                                ),
                                keyboardType: TextInputType.emailAddress),
                            decoration: BoxDecoration(
                                border: new Border.all(
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                          ),
                          SizedBox(
                            height: mh * 0.015,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: mw * 0.036),
                            height: mh * 0.07,
                            width: mw * 0.78,
                            child: TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                border: InputBorder.none,
                                hintText: 'Password',
                              ),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                            ),
                            decoration: BoxDecoration(
                                border: new Border.all(
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                          ),
                          SizedBox(height: mh * 0.045),
                          ButtonTheme(
                              minWidth: mw * 0.243,
                              height: mh * 0.059,
                              child: Container(
                                child: FlatButton(
                                  color: Colors.transparent,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    size: mw * 0.073,
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      // setState(() {
                                      //   _loading = true;
                                      // });
                                      // _email = _emailController.text;
                                      // _pw = _passwordController.text;
                                      // _prefs.setString('email', _email);
                                      // _prefs.setString('pw', _pw);
                                      // _signInWithEmailAndPassword();
                                      context.read<AuthProvider>().signIn(
                                            email: _emailController.text.trim(),
                                            password:
                                                _passwordController.text.trim(),
                                          );
                                      // setState(() {
                                      //   _loading = false;
                                      // });
                                    }
                                  },
                                ),
                                decoration: BoxDecoration(
                                    border: new Border.all(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(13.0))),
                              )),
                          SizedBox(
                            height: mh * 0.088,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                child: Text(
                                  '비밀번호 찾기',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ForgetPage()));
                                },
                              ),
                              SizedBox(
                                width: mw * 0.012,
                              ),
                              Container(
                                child: Text(
                                  '/',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                              SizedBox(
                                width: mw * 0.012,
                              ),
                              InkWell(
                                child: Text(
                                  '회원가입',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              RegisterPage()));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Example code of how to sign in with email and password.
//   void _signInWithEmailAndPassword() async {
//     final FirebaseAuth _auth = FirebaseAuth.instance;
//     User user;

//     user = (await _auth.signInWithEmailAndPassword(
//       email: _emailController.text,
//       password: _passwordController.text,
//     ))
//         .user;
//     if (user != null) {
//       setState(() {
//         _success = true;
//         _userEmail = user.email;
//         // _loading = false;
//       });
//       // Navigator.push(context,
//       //     MaterialPageRoute(builder: (BuildContext context) => MainPage()));
//       Navigator.pop(context);
//     } else {
//       _success = false;
//       // _loading = false;
//       showSnackBar(context);
//     }
//   }
}

void showSnackBar(BuildContext context) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text('아이디, 혹은 비밀번호를 확인하세요', textAlign: TextAlign.center),
    duration: Duration(seconds: 2),
    backgroundColor: Colors.redAccent,
  ));
}
