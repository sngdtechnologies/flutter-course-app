import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:premiere/screens/Accueil.dart';
import 'package:premiere/screens/Serie.dart';

class VeryfyConnection extends StatefulWidget {
  @override
  _VeryfyConnectionState createState() => _VeryfyConnectionState();
}

class _VeryfyConnectionState extends State<VeryfyConnection> {
  bool _isVisible = false;

  Widget veryfyConnection() {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return Stack(
            children: [
              Positioned(
                  top: 100,
                  left: 100,
                  child: new IgnorePointer(
                    child: new Material(
                      color: Colors.transparent,
                      child: new Opacity(
                        opacity: 1.0,
                        child: Icon(Icons.warning, color: Colors.purple),
                      ),
                    ),
                  )),
              Positioned(child: AccueilScreen()),
            ],
          );
        } else {
          return Stack(
            children: [
              Positioned(child: Serie()),
              Positioned(
                  top: 50,
                  left: 150,
                  child: new IgnorePointer(
                    child: new Material(
                      color: Colors.transparent,
                      child: new Opacity(
                        opacity: 1.0,
                        child: Icon(Icons.warning, color: Colors.purple),
                      ),
                    ),
                  )),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return veryfyConnection();
  }
}
