import 'package:btsreels/variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as Tago;
import 'package:flutter/material.dart';

class CommentsPage extends StatefulWidget {
  final String id;
  CommentsPage(this.id);
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  String uid;
  TextEditingController commentcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
  }

  publishcomment() async {
    DocumentSnapshot userdoc = await userCollection.doc(uid).get();
    var alldocs =
        await videosCollection.doc(widget.id).collection('comments').get();
    int length = alldocs.docs.length;
    videosCollection
        .doc(widget.id)
        .collection('comments')
        .doc('Comment $length')
        .set({
      'username': userdoc.data()['username'],
      'uid': uid,
      'profilepic': userdoc.data()['profilepic'],
      'comment': commentcontroller.text,
      'likes': [],
      'time': DateTime.now(),
      'id': 'Comment $length',
    });
    commentcontroller.clear();
    DocumentSnapshot doc = await videosCollection.doc(widget.id).get();
    videosCollection.doc(widget.id).update({
      'commentcount': doc.data()['commentcount'] + 1,
    });
  }

  likecomment(String id) async {
    DocumentSnapshot doc = await videosCollection
        .doc(widget.id)
        .collection('comments')
        .doc(id)
        .get();
    if (doc.data()['likes'].contains(uid)) {
      videosCollection.doc(widget.id).collection('comments').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    }else{
      videosCollection.doc(widget.id).collection('comments').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: videosCollection
                      .doc(widget.id)
                      .collection('comments')
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot comment = snapshot.data.docs[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(comment.data()['profilepic']),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  "${comment.data()['username']}",
                                  style: mystyle(
                                    20,
                                    Colors.black,
                                    FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  "${comment.data()['comment']}",
                                  style: mystyle(
                                    20,
                                    Colors.black,
                                    FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                    '${Tago.format(comment.data()['time'].toDate())}'),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("${comment.data()['likes'].length}likes")
                              ],
                            ),
                            trailing: InkWell(
                              onTap: () => likecomment(comment.data()['id']),
                              child: comment.data()['likes'].contains(uid)
                                  ? Icon(Icons.favorite,
                                      size: 25, color: Colors.purple)
                                  : Icon(
                                      Icons.favorite_border_outlined,
                                      size: 25,
                                    ),
                            ),
                          );
                        });
                  },
                ),
              ),
              Divider(),
              ListTile(
                title: TextFormField(
                  controller: commentcontroller,
                  decoration: InputDecoration(
                    labelText: "comment",
                    labelStyle: mystyle(20, Colors.black, FontWeight.w700),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                trailing: OutlineButton(
                  onPressed: () => publishcomment(),
                  borderSide: BorderSide.none,
                  child: Text(
                    'publish',
                    style: mystyle(
                      20,
                      Colors.black,
                      FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
