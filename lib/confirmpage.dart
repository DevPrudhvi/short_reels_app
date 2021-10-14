import 'package:btsreels/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmPage extends StatefulWidget {
  final File videofile;
  final String videopath_astring;
  final ImageSource imageSource;

  ConfirmPage(this.videofile, this.videopath_astring, this.imageSource);
  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  CachedVideoPlayerController controller;
  bool isuploading = false;
  TextEditingController musicController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  FlutterVideoCompress flutterVideoCompress = FlutterVideoCompress();

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = CachedVideoPlayerController.file(widget.videofile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  compressvideo() async {
    if (widget.imageSource == ImageSource.gallery) {
      return widget.videofile;
    } else {
      final compressedvideo = await flutterVideoCompress.compressVideo(
        widget.videopath_astring,
        quality: VideoQuality.MediumQuality,
      );
      return File(compressedvideo.path);
    }
  }

  getpreviewimage() async {
    final previewimage = await flutterVideoCompress.getThumbnailWithFile(
      widget.videopath_astring,
    );
    return previewimage;
  }

  uploadvideotostorage(String id) async {
    UploadTask uploadTask =
        videosfolder.child(id).putFile(await compressvideo());
    TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadimagetostorage(String id) async {
    UploadTask uploadTask =
        imagesfolder.child(id).putFile(await getpreviewimage());
    TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadVideo() async {
    setState(() {
      isuploading = true;
    });
    try{var firebaseuseruid = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot userdoc = await userCollection.doc(firebaseuseruid).get();
    var alldocs = await videosCollection.get();
    int length = alldocs.docs.length;
    String video = await uploadvideotostorage("Video_$length");
    String previewimage = await uploadimagetostorage("Video_$length");
    videosCollection.doc("Video_$length").set({
      'username': userdoc.data()['username'],
      'uid': firebaseuseruid,
      'profilepic': userdoc.data()['profilepic'],
      'id': "Video_$length",
      'likes': [],
      'commentcount': 0,
      'sharecount': 0,
      'songname': musicController.text,
      'caption': captionController.text,
      'videourl': video,
      'previewimage': previewimage,
    });
    Navigator.pop(context);}
    catch(e){
      print(e);
    }
    }
  

  Widget build(BuildContext context) {
    return Scaffold(
      body: isuploading == true? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Uploading....", style: mystyle(20,Colors.purpleAccent,FontWeight.bold),),
            SizedBox(height:20),
            CircularProgressIndicator(),
          ],
        )
      ) : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: CachedVideoPlayer(controller),
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      controller: musicController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "song name",
                          labelStyle: mystyle(
                            20,
                          ),
                          prefixIcon: Icon(Icons.music_note),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    margin: EdgeInsets.only(right: 40),
                    child: TextField(
                      controller: captionController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Caption",
                          labelStyle: mystyle(
                            20,
                          ),
                          prefixIcon: Icon(Icons.closed_caption),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  color: Colors.lightBlue,
                  onPressed: () => uploadVideo(),
                  child: Text(
                    'Upload Video',
                    style: mystyle(20, Colors.white),
                  ),
                ),
                RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: mystyle(20, Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
