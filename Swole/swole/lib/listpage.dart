import 'package:swole/main.dart';
import 'package:swole/settings.dart';
import 'auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Constants.dart';

class DetailPage extends StatefulWidget {

  final DocumentSnapshot workout;
  DetailPage({this.workout});

  @override
  _DetailPageState createState() => _DetailPageState();
    
  }
  
class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(child: new Text(widget.workout.data["title"], textAlign: TextAlign.center)),
        actions: <Widget>[
          IconButton(
           icon: Icon(Icons.delete),
           onPressed:() {
            var firestore = Firestore.instance;
            firestore.collection("user_data").document(authService.currUser().uid).collection("workouts").document(widget.workout.documentID).delete();
           },
            
            )
        ]
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            
          ],
        ),
        ),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
  
}
  
class _ListPageState  extends State<ListPage> with SingleTickerProviderStateMixin{
  TabController _tabController;

  Future getWorkouts() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection("user_data").document(authService.currUser().uid).collection("workouts").getDocuments();

    return qn.documents;
 
  }

  void addWorkouts(String name) async {
    print("Request to add: " + name);
    var firestore = Firestore.instance;

    firestore.collection("user_data").document(authService.currUser().uid).collection("workouts").document("tim").setData({"title": name});
  }

  Future getFood() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection("user_data").document(authService.currUser().uid).collection("food").getDocuments();

    return qn.documents;
 
  }

  navigateToDetail(DocumentSnapshot workout){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(workout: workout,)));
  }

  void choice(String choice){
    if(choice == Constants.logout){
      print("Logging out");
      authService.signOut();
      Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(
        builder: (context) => MyApp()
      ), 
     ModalRoute.withName("/Home")
    );
      
    } else if (choice == Constants.settings){
      print(authService.currUser().toString());
      Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => SettingApp())
      );
      
    }

    else if (choice == Constants.workout){
      showDialog(
    context: context,
    builder: (BuildContext context) {
      final myController = TextEditingController();
            return AlertDialog(
              content: Form(
                key: null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(controller: myController,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("Submit"),
                  onPressed: () {
                    addWorkouts(myController.text);
                  },
                ),
              )
            ],
          ),
        ),
      );
    });
    }
    
  }

  void initState(){
    _tabController = new TabController(length: 3, vsync: this);
  }

  
  void dispose(){
    _tabController.dispose();
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
          controller: _tabController,
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
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          Container(
                child: FutureBuilder(
                  future: getFood(),
                  builder: (_, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: Text("Loading..."),
                    );
                  } else {
                    return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (_, index){
                              return Card( 
                                child: Container(
                                  padding: EdgeInsets.all(0),
                                  height: 80,
                                  child: Center(child:Text(snapshot.data[index].data["date"], style: new TextStyle(fontSize: 16),)),
                                )
                              );
                            }
                      );
                  }
                },
                
                ),
                
                
              ), 
          Container(
            child: 
              Column(
                children: 
                  <Widget>[
                    Text("Currently unavailable.."),
                    new Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: OutlineButton(
                      child: Text("Hello"),
                      onPressed: () {
                        print("hi");
                      },
                    ),
                      ),
                    ),
                    
                  ],
                  )
              
              
          ),
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
                              return
                                InkWell( 

                                child: Card(
                                  child:Container(
                                  padding: EdgeInsets.all(0),
                                  height: 80,
                                  child: Center(child:Text(snapshot.data[index].data["title"], style: new TextStyle(fontSize: 16),)
                                  ),
                                  
                                ),),
                                onTap: () => navigateToDetail(snapshot.data[index]),
                              
                              
                              );
                              
                            }
                      );
                  }
                },
                ),
              ),


        ],),
      )
      
    
    );
  }

}