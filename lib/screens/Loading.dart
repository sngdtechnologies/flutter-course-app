import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Text(
          'Chargement . . .',
          style: TextStyle(color: Colors.white, fontSize: 15.0),
        ),
      ),
    );
  }
}
