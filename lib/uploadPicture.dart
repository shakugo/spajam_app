import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart' as path;

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File file;
  int score;

  Future<int> showCupertinoBottomBar() {
    //選択するためのボトムシートを表示
    return showCupertinoModalPopup<int>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            message: Text('写真をアップロードしますか？'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'カメラで撮影',
                ),
                onPressed: () {
                  Navigator.pop(context, 0);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  'アルバムから選択',
                ),
                onPressed: () {
                  Navigator.pop(context, 1);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context, 2);
              },
              isDefaultAction: true,
            ),
          );
        });
  }

  void showBottomSheet() async {
    //ボトムシートから受け取った値によって操作を変える
    final result = await showCupertinoBottomBar();
    File imageFile;

    if (result == 0) {
      imageFile = await ImageUpload(ImageSource.camera).getImageFromDevice();
    } else if (result == 1) {
      imageFile = await ImageUpload(ImageSource.gallery).getImageFromDevice();
    }
    setState(() {
      file = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('しゃしんをあげよう！'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (file != null)
              Container(
                height: 300,
                width: 300,
                child: Image.file(file),
              ),
            if (file == null)
              RaisedButton.icon(
                icon: Icon(Icons.local_florist),
                color: Colors.green,
                textColor: Colors.white,
                label: Text("いまのあさがおをみせて！"),
                onPressed: () {
                  showBottomSheet();
                },
              ),
            if (file != null)
              RaisedButton.icon(
                icon: Icon(Icons.file_upload),
                color: Colors.red,
                textColor: Colors.white,
                label: Text("みんなにもみせよう！！"),
                onPressed: () async {
                  //ここにアップロードするときのこれこれ書いてくれや
                  var score = await _requestCloudVision(file);
                  uploadData(score, file);
                  Navigator.of(context).pop();
                },
              ),
            if (file != null)
              RaisedButton.icon(
                icon: Icon(Icons.local_florist),
                color: Colors.green,
                textColor: Colors.white,
                label: Text("ちがうしゃしんにする！"),
                onPressed: () {
                  showBottomSheet();
                },
              )
          ],
        ),
      ),
    );
  }

  void uploadData(int level, File imageFile) async {
    Timestamp createdAtTimestamp = Timestamp.fromDate(DateTime.now());
    var data = {
      'message': "fullName",
      'level': level,
      'image': path.basename(file.path),
      'date': createdAtTimestamp
    };
    DocumentReference diary =
        await Firestore.instance.collection('diary').add(data);
    print("uploaded");
  }
}

_requestCloudVision(File cameraImage) async {
  String url = "https://vision.googleapis.com/v1/images:annotate";
  String apiKey = "";
  List<int> imageBytes = cameraImage.readAsBytesSync();
  Map json = {
    "requests": [
      {
        "image": {"content": base64Encode(imageBytes)},
        "features": [
          {
            "type": "LABEL_DETECTION",
            "maxResults": 10,
            "model": "builtin/stable"
          }
        ],
        "imageContext": {"languageHints": []}
      }
    ]
  };

  Response response = await http.post(url + "?key=" + apiKey,
      body: jsonEncode(json), headers: {"Content-Type": "application/json"});

  var body = response.body;
  //visionapiのレスポンス中身出力
  int score = 0;

  if (body.contains("Flower")) {
    print("flower exists");
    score += 5;
  } else if (body.contains("Petal")) {
    print("petal exists");
    score += 4;
  } else if (body.contains("Leaf")) {
    print("leaf exists");
    score += 3;
  } else {
    print("nothin");
  }

  return score;
}

//カメラ、ギャラリーからのアップロードはここでやる
class ImageUpload {
  ImageUpload(this.source, {this.quality = 50});

  final ImageSource source;
  final int quality;

  Future<File> getImageFromDevice() async {
    // 撮影/選択したFileが返ってくる
    final imageFile = await ImagePicker().getImage(source: source);
    // Androidで撮影せずに閉じた場合はnullになる
    if (imageFile == null) {
      return null;
    }
    //画像を圧縮
    final File compressedFile = await FlutterNativeImage.compressImage(
        imageFile.path,
        quality: quality);

    return compressedFile;
  }
}
