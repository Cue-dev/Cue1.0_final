import 'package:Cue/screen/LogIn/register2_page.dart';
import 'package:Cue/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Cue/services/loading.dart';
import 'package:Cue/services/database.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final TextEditingController _nickNameController = TextEditingController();
  bool _loading = false;

  bool _success;
  String _userEmail;

  @override
  Widget build(BuildContext context) {
    final double mh = MediaQuery.of(context).size.height;
    final double mw = MediaQuery.of(context).size.width;

    return _loading
        ? Loading()
        : Scaffold(
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: mh * 0.3),
                    Center(
                      child: Text(
                        'Create account',
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: mh * 0.15),
                    createID('Email Address', mw, mh),
                    createPW('Password', mw, mh),
                    confirmPW('Confirm Password', mw, mh),
                    createNick('Your Nickname', mw, mh),
                    SizedBox(height: mh * 0.03),
                    FlatButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _loading = true;
                          });
                          // await _register();
                          context.read<AuthProvider>().signUp(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                          setState(() {
                            _loading = false;
                          });
                          _success == true
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RegisterPage2()))
                              //TODO: RegisterPage2를 다이아로그로 띄우고 pop하는 것으로
                              : showSnackBar(context);
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.black)),
                      child: Text('Sign up',
                          style: TextStyle(fontSize: 17, color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget createID(String txt, double mw, double mh) {
    return Container(
      child: TextField(
        controller: _emailController,
        decoration: InputDecoration(border: InputBorder.none, hintText: txt),
        keyboardType: TextInputType.emailAddress,
      ),
      width: mw * 0.73,
      height: mh * 0.06,
      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
      padding: EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1, color: Colors.black)),
    );
  }

  Widget createPW(String txt, double mw, double mh) {
    return Container(
      child: TextField(
        controller: _passwordController,
        decoration: InputDecoration(border: InputBorder.none, hintText: txt),
        obscureText: true,
      ),
      width: mw * 0.73,
      height: mh * 0.06,
      margin:
          EdgeInsets.only(left: mw * 0.024, right: mw * 0.024, top: mh * 0.022),
      padding: EdgeInsets.only(left: mw * 0.036),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: mw * 0.0024, color: Colors.black)),
    );
  }

  Widget confirmPW(String txt, double mw, double mh) {
    return Container(
      child: TextField(
        controller: _passwordController2,
        decoration: InputDecoration(border: InputBorder.none, hintText: txt),
        obscureText: true,
      ),
      width: mw * 0.73,
      height: mh * 0.06,
      margin:
          EdgeInsets.only(left: mw * 0.024, right: mw * 0.024, top: mh * 0.022),
      padding: EdgeInsets.only(left: mw * 0.036),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: mw * 0.0024, color: Colors.black)),
    );
  }

  Widget createNick(String txt, double mw, double mh) {
    return Container(
      child: TextField(
        controller: _nickNameController,
        decoration: InputDecoration(border: InputBorder.none, hintText: txt),
        keyboardType: TextInputType.emailAddress,
      ),
      width: mw * 0.73,
      height: mh * 0.06,
      margin:
          EdgeInsets.only(left: mw * 0.024, right: mw * 0.024, top: mh * 0.022),
      padding: EdgeInsets.only(left: mw * 0.036),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: mw * 0.0024, color: Colors.black)),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    _passwordController2.dispose();
    _nickNameController.dispose();
    super.dispose();
  }

  Future _register() async {
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    if (user != null) {
      await DatabaseService(uid: user.uid)
          .createUserData(_nickNameController.text);

      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      _success = false;
    }
  }
}

void showSnackBar(BuildContext context) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text('다시 진행해주세요', textAlign: TextAlign.center),
    duration: Duration(seconds: 2),
    backgroundColor: Colors.redAccent,
  ));
}
