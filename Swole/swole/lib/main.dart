import 'package:flutter/material.dart';
import 'auth.dart';
import 'homepage.dart';

void main() => runApp(HomePage());

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swole',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
      
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            
            FloatingActionButton.extended(
              onPressed: () => authService.googleSignIn(),
              label: Text('Login with Google'),
            )
          ],
        ),
        )
      )
    );
  }
}
