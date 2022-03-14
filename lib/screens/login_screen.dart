import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transmusicales/screens/register_screen.dart';

import '../models/login.dart';
import '../services/auth_services.dart';

class LoginSreen extends StatefulWidget {
  final String title;

  @override
  _LoginScreen createState() => _LoginScreen();

  const LoginSreen({Key? key, required this.title}) : super(key: key);
}

class _LoginScreen extends State<LoginSreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final Login _login = Login();

  @override
  void initState() {
    super.initState();
  }



  Widget loginScreen() {
    return loginForm();
  }

  Widget loginForm() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: const Color(0xfff5f5f5),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(
                        color: Colors.black, fontFamily: 'SFUIDisplay'),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'email',
                        prefixIcon: Icon(Icons.person_outline),
                        labelStyle: TextStyle(fontSize: 15)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Entrer votre email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _login.email = value!;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: const Color(0xfff5f5f5),
                  child: TextFormField(
                    obscureText: true,
                    style: const TextStyle(
                        color: Colors.black, fontFamily: 'SFUIDisplay'),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Mot de passe',
                        prefixIcon: Icon(Icons.lock_outline),
                        labelStyle: TextStyle(fontSize: 15)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Entrer votre mot de passe';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _login.password = value!;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Builder(
                  builder: (context) => MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        login(_login.email, _login.password, context);
                      }
                    },
                    child: const Text(
                      'CONNEXION',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'SFUIDisplay',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Colors.blueGrey,
                    elevation: 0,
                    minWidth: 400,
                    height: 50,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                          text: "Vous n'avez pas de compte ? ",
                          style: TextStyle(
                            fontFamily: 'SFUIDisplay',
                            color: Colors.black,
                            fontSize: 15,
                          )),
                      TextSpan(
                          text: "Inscrivez vous!",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const RegisterSreen(
                                          title: 'Register')));
                            },
                          style: const TextStyle(
                            fontFamily: 'SFUIDisplay',
                            color: Colors.blue,
                            fontSize: 15,
                          ))
                    ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey, body: loginScreen());
  }
}
