import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skt/screens/create_vehicle.dart';
import 'package:skt/widget/navigation_drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String input = "";

  createTodos() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(input);

    //Map
    Map<String, String> todos = {"todoTitle": input};
    documentReference.set(todos).whenComplete(() {
      print("$input created");
    });
  }

  deleteTodos(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(item);

    documentReference.delete().whenComplete(() {
      print("$item deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          child: Icon(Icons.directions_car),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => CreateVehicle(),
              ),
            );
          },
          heroTag: null,
        ),
        const SizedBox(
          height: 15,
        ),
        FloatingActionButton(
          child: Icon(Icons.text_fields),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  title: const Text("Add Task"),
                  content: TextField(
                    onChanged: (String value) {
                      input = value;
                    },
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // setState((){
                        //   todos.add(input);
                        // });
                        createTodos();
                        Navigator.of(context).pop(); // closes the dialog
                      },
                      child: Text("Add"),
                    )
                  ],
                );
              },
            );
          },
          heroTag: null,
        )
      ]),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if ((snapshot.data! as dynamic).docs.length == 0) {
            return Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Center(child: Text("No tasks")),
            );
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot =
                    (snapshot.data! as dynamic).docs[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    title: Text(documentSnapshot["todoTitle"]),
                    trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            deleteTodos(documentSnapshot["todoTitle"]);
                          });
                        }),
                  ),
                );
              });
        },
      ),
      drawer: NavigationDrawerWidget(),
    );
  }
}
