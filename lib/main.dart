import 'package:flutter/material.dart';
import 'package:spajam_app/calender.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'あさがおかんさつにっき',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'あさがおかんさつにっき'),
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
  int _counter = 5;
  int _level = 10;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/plants/plant1.png',
              scale: 0.2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '育て始めて:',
                ),
                Text(
                  '$_counter' + '日目',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  '育成レベル:',
                ),
                Text(
                  'Lv. ' + '$_level',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        Row(),
        IconButton(
            icon: Icon(
              Icons.camera_alt,
              color: Colors.black,
              size: 40.0,
            ),
            onPressed: () => print("camera")),
        IconButton(
            icon: Icon(
              Icons.event_note,
              color: Colors.black,
              size: 40.0,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CalenderApp(),
              ));
            }),
      ],
    );
  }
}
