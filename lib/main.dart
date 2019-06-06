import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(MyApp());

//var databaseRef = FirebaseDatabase.instance.reference();
var _list = new List();
int i = 0;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  final _formKey = GlobalKey<FormState>();
  final databaseReference = FirebaseDatabase.instance.reference();


  @override
  void initState() {
//    _getData();
    i = _list.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            (_list != null)?
            ListView.builder(
              itemBuilder: (context, pos) {
                String x = _list[pos];
                return ListTile(
                  dense: true,
                  title: Text(x),
                  trailing: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(onPressed: _update(pos), child: Text('Edit')),
                      IconButton(icon: Icon(Icons.cancel), onPressed: _delete(pos))
                    ],
                  ),
                );
              },
              itemCount: _list.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
            ): Container(),
            Divider(),
            Form(
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter some text';
                  } else
                    _upload(value);
                },
              ),
              key: _formKey,
            ),
            RaisedButton(
              onPressed: () {
                _formKey.currentState.validate();
                _formKey.currentState.reset();
              },
              child: Text('Submit'),
            )
          ],
        ),
      ),
    );
  }

  _upload(String val) {
    print(val);
    databaseReference.child('$i').set(val).then((n){
//      print();
      i++;
      _getData();
    });

  }

  _getData() async {
    databaseReference.once().then((snap) {
      print('Values:');
      print(snap.value);
      _list = snap.value;
      print(_list);
      setState(() {});
    });
  }

  _update(int pos){
    TextEditingController controller = new TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new TextField(
            controller: controller,
            onSubmitted: (text){
              databaseReference.child('$pos').child('$text');
            },
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _delete(int pos){
    databaseReference.child('$pos').remove();
    _getData();
  }
}
