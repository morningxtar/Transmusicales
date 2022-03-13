import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:transmusicales/screens/artists.dart';
import 'package:transmusicales/screens/fav_artists.dart';
import 'package:transmusicales/screens/map.dart';
import 'package:transmusicales/utils/data_utils.dart';
import 'package:animations/animations.dart';

void main() async{
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Les Transmusicales'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Widget> pageList;
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    pageList = <Widget>[
      const ArtistsSreen(title: 'Artistes'),
      const ArtistMap(title: 'Carte itérative'),
      const FavArtistsSreen(title: 'Artistes préférés'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
        selectedItemColor: Colors.black,
        currentIndex: pageIndex,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Artistes'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Carte'

          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favoris'
          ),
        ],
      ),
    );
  }
}
