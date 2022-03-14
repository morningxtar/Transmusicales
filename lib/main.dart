import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transmusicales/screens/artists.dart';
import 'package:transmusicales/screens/fav_artists.dart';
import 'package:transmusicales/screens/map.dart';
import 'package:animations/animations.dart';
import 'package:transmusicales/screens/splash_screen.dart';
import 'package:transmusicales/services/auth_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDBc5IYiVFP7w6llclO-rciTTSzXZkErZ8",
      appId: "1:501960666369:android:330467f83b9a0708a8ff00",
      messagingSenderId: "501960666369",
      projectId: "transmusicales-628f0",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.sharedPreferences}) : super(key: key);

  final String title;
  final SharedPreferences sharedPreferences;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Widget> pageList;
  int pageIndex = 0;
  bool connected = false;
  late Color color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    pageList = <Widget>[
      ArtistsSreen(title: 'Artistes', sharedPreferences: widget.sharedPreferences,),
      const ArtistMap(title: 'Carte itérative'),
      FavArtistsSreen(title: 'Artistes préférés', sharedPreferences: widget.sharedPreferences),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: () {
            logoutApp();
          }, icon: const Icon(Icons.logout)),
        ],
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
            FadeThroughTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        ),
        child: pageList[pageIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: const IconThemeData(color: Colors.black),
        selectedItemColor: color,
        currentIndex: pageIndex,
        onTap: (value) {
          setState(() {
            pageIndex = value;
            color = pageIndex == 0
                ? Colors.blue
                : pageIndex == 2
                    ? Colors.pink
                    : Colors.black;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Artistes'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Carte'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoris'),
        ],
      ),
    );
  }
}
