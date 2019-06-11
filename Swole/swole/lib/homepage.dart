import 'auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Constants.dart';


class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ListPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> { 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(child: new Text(widget.title, textAlign: TextAlign.center)),      
      ),
      body: new Container(
        
    ),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
  
}
  
class _ListPageState  extends State<ListPage>{
  
  Future getWorkouts() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection("workouts").getDocuments();

    return qn.documents;
 
  }

  void choice(String choice){
    if(choice == Constants.logout){
      print("Logging out");
      authService.signOut();
    } else if (choice == Constants.settings){
      print(authService.currUser().toString());
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
      appBar: AppBar(
        title: new Center(child: new Text("", textAlign: TextAlign.center)),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choice,
            itemBuilder: (BuildContext context){
              return Constants.choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice));
              }).toList();
            },
            )
        ],
        bottom: TabBar(
          tabs: <Widget>[
            Tab(
              text: "Food"
            ),
            Tab(
              text: "Home"
            ),
            Tab(
              text: "Workouts"
            ),
          ],
        ),  
      ),
      body:
      Container(
      child: FutureBuilder(
        future: getWorkouts(),
        builder: (_, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: Text("Loading..."),
          );
        } else {
          return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index){
                    return ListTile(title: Text(snapshot.data[index].data["title"]),);
                  }
            );
        }
      },
      ),
    )
    )
    );
  }

}