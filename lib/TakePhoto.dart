import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class TakePhoto extends StatefulWidget {
  MethodCallBack mMethodCallBack;

  TakePhoto(this.mMethodCallBack);

  @override
  TakePhotoState createState() => new TakePhotoState();
}

typedef MethodCallBack = void Function(File file);

class TakePhotoState extends State<TakePhoto> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency, //透明类型
      child: Container(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(child: InkWell()),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: _takePhoto,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            width: double.infinity,
                            child: Text(
                              '拍照',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),
                    Divider(
                      height: 1,
                    ),
                    Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: _openGallery,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            width: double.infinity,
                            child: Text(
                              '从手机相册选择',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),
                    Container(
                      color: Color(0x66000000),
                      height: 15,
                    ),
                    Material(
                      color: Colors.white,
                      child: InkWell(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          width: double.infinity,
                          child: Text(
                            '取消',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

/*拍照*/
  _takePhoto() async {
    print( "ddddd");
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 600, maxHeight: 800);
    _cropImage(imageFile, isAngle: true);
  }

  /*相册*/
  _openGallery() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 600, maxHeight: 800);
    _cropImage(imageFile);
  }

  Future<Null> _cropImage(File imageFile, {bool isAngle = false}) async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS && isAngle) {
        await FlutterImageCompress.compressAndGetFile(
          imageFile.absolute.path,
          imageFile.absolute.path,
          quality: 88,
          rotate: -90,
        );
      }
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        maxWidth: 512,
        maxHeight: 512,
      );

      widget.mMethodCallBack(croppedFile);
    } catch (e) {}
  }

//  _size2Small(imageFile) async {
//    Help.showLoadingDialog(context);
//    var directory = await getTemporaryDirectory();
//    String path = await Luban.compressImage(CompressObject(
//        imageFile: imageFile,
//        path: directory.path,
//        mode: CompressMode.LARGE2SMALL,
//        step: 10));
//    finish();
//    finish();
//    widget.mMethodCallBack(new File(path));
//  }
}
