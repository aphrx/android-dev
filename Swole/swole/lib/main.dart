import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swole',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(child: new Text("Swole", textAlign: TextAlign.center)),
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            
            FloatingActionButton.extended(
              backgroundColor: Colors.green,
              onPressed: () => login(context),
              label: Text('Login with Google'),
            )
          ],
        ),
        ),
    );
  }

    void login(BuildContext context) {

    FutureOr Function(FirebaseUser value) user;
      authService.googleSignIn().then(user);

    
      Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(
        builder: (context) => HomeApp()
      ), 
     ModalRoute.withName("/Home")
    );
  }
}

