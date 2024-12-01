import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:premiere/VeryfyConnection.dart';
import 'package:premiere/pushMessageService.dart';
import 'package:premiere/screens/Loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(Premiere());
}

class Premiere extends StatefulWidget {
  // Set default `_initialized` and `_error` state to false
  @override
  _PremiereState createState() => _PremiereState();
}

class _PremiereState extends State<Premiere> {
  String _notificationMsg = 'Pas de message';
  bool _initialized = false;
  bool _error = false;
  User user;

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
    //   MessageService firebaseMessaging = MessageService();
    //   firebaseMessaging.setNotifications();
    //   firebaseMessaging.streamCtlr.stream.listen((msgData) {
    //     _changeMsg(msgData);
    //   });
  }

  // _changeMsg(String msg) {
  //   setState(() {
  //     _notificationMsg = msg;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return Center(
        child: Text('Erreur de démarage'),
      );
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return MaterialApp(
        title: 'Mes Proff',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: Loading(),
      );
    }

    return MaterialApp(
      title: 'Mes Proff',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          color: Colors.blue,
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        primaryColor: Colors.blue,
      ),
      home: VeryfyConnection(),
      // home: user != null ? Profil() : AccueilScreen(),
    );
  }
}
