import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_image/flutter_native_image.dart';


class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File file;

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
        title: Text('Image Picker'),
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
            RaisedButton(
              child: Text('upload'),
              onPressed: () {
                showBottomSheet();
              },
            )
          ],
        ),
      ),
    );
  }
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
