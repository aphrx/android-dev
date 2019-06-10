import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swole',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(title: "Workouts"),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key:key);

  final String title;

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  static String tag = "home-page";

  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('workouts').getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) { 
    return Container(
      child: FutureBuilder(
        future: getPosts(), 
        builder: (_, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: Text("Loading..."),
            );
          } else {
            ListView.builder(
              itemCount: snapshot.data.length, 
              itemBuilder: (_, index){
                return ListTile(
                  title: Text(snapshot.data[index].data['title']),
                );
            });
          }
      }),
    );
  }
}