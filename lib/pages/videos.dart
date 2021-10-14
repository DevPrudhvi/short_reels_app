

import 'package:btsreels/pages/comments.dart';
import 'package:btsreels/pages/widgets/circle_animation.dart';
import 'package:btsreels/variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';

class Videopage extends StatefulWidget {
  @override
  _VideopageState createState() => _VideopageState();
}

class _VideopageState extends State<Videopage> {
  Stream mystream;
  String uid;

  initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
    mystream = videosCollection.snapshots();
  }

  buildProfile(String url) {
    return Container(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: (60 / 2 - 50 / 2),
          child: Container(
            width: 50,
            height: 50,
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(url),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: (60 / 2) - (20 / 2),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ]),
    );
  }

  buildMusicAlbum(String url) {
    return Container(
      padding: EdgeInsets.all(5),
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[500],
            Colors.grey[700],
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Image(
        image: NetworkImage(url, scale: 8),
      ),
    );
    
  }

  likedvideo(String id) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot doc = await videosCollection.doc(id).get();
    if (doc.data()['likes'].contains(uid)) {
      videosCollection.doc(id).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      videosCollection.doc(id).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder(
          stream: mystream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return PageView.builder(
                itemCount: snapshot.data.docs.length,
                controller: PageController(
                  initialPage: 0,
                  viewportFraction: 1,
                ),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  DocumentSnapshot videos = snapshot.data.docs[index];
                  return Stack(
                    children: [
                      //video
                      VideoPlayerItem(videos.data()['videourl']),
                      Column(
                        children: [
                          //top section
                          Container(
                            height: 100,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Following',
                                  style: mystyle(
                                    17,
                                    Colors.white,
                                    FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  'For You',
                                  style: mystyle(
                                    17,
                                    Colors.white,
                                    FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //middle section
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 70,
                                    padding: EdgeInsets.only(left: 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          videos.data()['username'],
                                          style: mystyle(
                                            15,
                                            Colors.white,
                                            FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          videos.data()['caption'],
                                          style: mystyle(
                                            15,
                                            Colors.white,
                                            FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.music_note,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              videos.data()['songname'],
                                              style: mystyle(
                                                15,
                                                Colors.white,
                                                FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                // right section
                                Container(
                                  width: 100,
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          12),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildProfile(videos.data()['profilepic']),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () =>
                                                likedvideo(videos.data()['id']),
                                            child: Icon(
                                              Icons.favorite,
                                              size: 45,
                                              color: videos
                                                      .data()['likes']
                                                      .contains(uid)
                                                  ? Colors.deepPurple
                                                  : Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 7),
                                          Text(
                                            videos
                                                .data()['likes']
                                                .length
                                                .toString(),
                                            style: mystyle(
                                              15,
                                              Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CommentsPage(
                                                  videos.data()['id'],
                                                ),
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.comment,
                                              size: 45,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 7),
                                          Text(
                                            videos.data()['commentcount'].toString(),
                                            style: mystyle(
                                              15,
                                              Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: Icon(
                                              Icons.share,
                                              size: 45,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 7),
                                          Text(
                                            '15',
                                            style: mystyle(
                                              15,
                                              Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      CircleAnimation(buildMusicAlbum(
                                          videos.data()['profilepic']))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                });
          }),
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videourl;
  VideoPlayerItem(this.videourl);
  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  CachedVideoPlayerController cachedVideoPlayerController;
  @override
  void initState() {
    super.initState();
    cachedVideoPlayerController = CachedVideoPlayerController.network(
      widget.videourl,
    )..initialize().then((value) {
        cachedVideoPlayerController.play();
        cachedVideoPlayerController.setVolume(1);
        cachedVideoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose(){
    super.dispose();
    cachedVideoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: CachedVideoPlayer(cachedVideoPlayerController),
    );
  }
}
