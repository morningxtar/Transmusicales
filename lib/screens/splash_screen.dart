import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transmusicales/main.dart';
import 'package:transmusicales/screens/artists.dart';

import '../database/database.dart';
import '../models/dataset.dart';
import '../utils/data_utils.dart';
import '../utils/navigation_utils.dart';
import 'login_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late SharedPreferences _sharedPreferences;
  late String email;

  @override
  void initState() {
    super.initState();
    instancingSharedPref();

    Timer(const Duration(seconds: 2), () {
      isConnected().then((value) {
        if (value) {
          NavigationUtils.pushReplacement(
              context,
              MyHomePage(
                title: 'Les Transmusicales',
                sharedPreferences: _sharedPreferences,
              ));
        } else {
          NavigationUtils.pushReplacement(
              context,
              const LoginSreen(
                title: 'Login',
              ));
        }
      });
    });
  }

  Future<bool> isConnected() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.containsKey('email');


  }

  instancingSharedPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    email = _sharedPreferences.getString('email')!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Image.asset(
                      'assets/logo/trans.png',
                    ),
                  )
                ],
              ),
            ),
            const CircularProgressIndicator(),
            const Text("Chargement en cours..."),
            const Text("@Morningxtar corp"),
          ],
        ),
      ),
    );
  }
}
