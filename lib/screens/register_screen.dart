import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../models/login.dart';
import '../services/auth_services.dart';
import 'login_screen.dart';

class RegisterSreen extends StatefulWidget {
  final String title;

  @override
  _RegisterSreen createState() => _RegisterSreen();

  const RegisterSreen({Key? key, required this.title}) : super(key: key);
}

class _RegisterSreen extends State<RegisterSreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
  }

  Widget loginScreen() {
    return loginForm();
  }

  Widget loginForm() {
    Login _inscription = Login();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                  child: TextFormField(autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        labelStyle: TextStyle(fontSize: 15)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Champ obligatoire';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _inscription.email = value;
                    },
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).nextFocus();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: const Color(0xfff5f5f5),
                  child: TextFormField(autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                    style: const TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Mot de passe',
                        prefixIcon: Icon(Icons.lock_outline),
                        labelStyle: TextStyle(fontSize: 15)),
                    validator: (value) {
                      if (value!.length < 6) {
                        return 'Le mot de passe doit être supérieur à 6 caractère';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _inscription.password = value;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    color: const Color(0xfff5f5f5),
                    child: TextFormField(autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: const TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Pseudo',
                          prefixIcon: Icon(Icons.account_circle_outlined),
                          labelStyle: TextStyle(fontSize: 15)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Champ obligatoire';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _inscription.pseudo = value;
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
                        register(_inscription);
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => const LoginSreen(title: 'Login',)));
                            //ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                      },
                    //since this is only a UI app
                    child: const Text(
                      "S'inscrire",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'SFUIDisplay',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Colors.green,
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
                          text: "Vous êtes déjà inscrite ? ",
                          style: TextStyle(
                            fontFamily: 'SFUIDisplay',
                            color: Colors.black,
                            fontSize: 15,
                          )),
                      TextSpan(
                          text: "Connectez vous!",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginSreen(title: 'Login',)));
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
