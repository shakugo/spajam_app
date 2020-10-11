import 'package:flutter/material.dart';
import 'package:spajam_app/calender.dart';
import 'package:spajam_app/uploadPicture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'class_diary.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'かんさつにっき',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'かんさつにっき'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        body: _buildBody(context),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.black,
                    size: 40.0,
                  ),
                  onPressed: () {
                    print("reload");
                  }),
              IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 40.0,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ImageUploadScreen(),
                    ));
                  }),
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
          ),
          // color: Colors.orange,
        ));
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('diary')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildContent(context, snapshot.data.documents[0],
            snapshot.data.documents[snapshot.data.documents.length - 1]);
      },
    );
  }

  Widget _buildContent(
      BuildContext context, DocumentSnapshot data, DocumentSnapshot lastData) {
    final diary = Diary.fromSnapshot(data);
    final lastDiary = Diary.fromSnapshot(lastData);
    var _duration = DateTime.now().difference(lastDiary.date).inDays;
    var _durationMessage = '';
    var imageName = 'images/plants/';

    if (_duration < 0) {
      _durationMessage = '今日から';
    } else {
      _durationMessage = '$_duration' + '日目';
    }

    if (diary.level > 10) {
      imageName = imageName + 'plant5.png';
    } else if (diary.level > 6) {
      imageName = imageName + 'plant4.png';
    } else if (diary.level > 4) {
      imageName = imageName + 'plant3.png';
    } else if (diary.level > 2) {
      imageName = imageName + 'plant2.png';
    } else {
      imageName = imageName + 'plant1.png';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imageName,
            scale: 0.2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '育て始めて:',
              ),
              Text(
                _durationMessage,
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                '育成レベル:',
              ),
              Text(
                'Lv. ' + diary.level.toString(),
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
