import 'dart:io';

import 'package:btsreels/confirmpage.dart';
import 'package:btsreels/variables.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddVideoPage extends StatefulWidget {
  @override
  _AddVideoPageState createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  pickVideo(ImageSource src) async {
    Navigator.pop(context);
    final video = await ImagePicker().getVideo(
      source: src,
      maxDuration: Duration(seconds: 30),
    );
    if (video != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ConfirmPage(File(video.path), video.path, src)),
      );
    }
  }

  showOptionsDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: () => pickVideo(ImageSource.gallery),
              child: Text(
                'Gallery',
                style: mystyle(20),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => pickVideo(ImageSource.camera),
              child: Text(
                'Camera',
                style: mystyle(20),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: mystyle(20),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () => showOptionsDialog(),
        child: Center(
          child: Container(
            width: 190,
            height: 80,
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Center(
              child: Text(
                'Add Video',
                style: mystyle(30, Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
