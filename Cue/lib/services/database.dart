import 'package:Cue/services/auth_provider.dart';
import 'package:Cue/services/reference_video.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference videoCollection =
      FirebaseFirestore.instance.collection('videos');
  final CollectionReference userVideoCollection =
      FirebaseFirestore.instance.collection('UserVideos');

  Future createUserData(String? nickName, String? description) async {
    return await userCollection.doc(uid).set({
      'name': nickName,
      'description': description,
      'following': 0,
      'follower': 0,
    });
  }

  Future createSavedVideoList(String listName) async {
    await userCollection
        .doc(uid)
        .collection('savedVideoList')
        .doc(listName)
        .set({'exist': 'TRUE'});

    return await userCollection
        .doc(uid)
        .collection('savedVideoList')
        .doc(listName)
        .collection(listName)
        .doc('getListName')
        .set({'name': listName});
  }

  Future saveVideo(String listName, ReferenceVideo video) async {
    await userCollection
        .doc(uid)
        .collection('savedVideoList')
        .doc(listName)
        .collection(listName)
        .doc('${video.source}:${video.title}')
        .set({
      'title': video.title,
      'source': video.source,
      'type': video.type,
      'tag': video.tag,
      'script': video.script,
      'length': video.length,
      'views': video.views,
      'challenges': video.challenges,
      'thumbnailURL': video.thumbnailURL,
      'videoURL': video.videoURL
    });
  }

  Future createSavedScriptList(String listName) async {
    await userCollection
        .doc(uid)
        .collection('savedScriptList')
        .doc(listName)
        .set({'exist': 'TRUE'});

    return await userCollection
        .doc(uid)
        .collection('savedScriptList')
        .doc(listName)
        .collection(listName)
        .doc('getListName')
        .set({'name': listName});
  }

  Future saveScript(
      String listName, String? source, String? title, Map? script) async {
    await userCollection
        .doc(uid)
        .collection('savedScriptList')
        .doc(listName)
        .collection(listName)
        .doc('script-$source:$title')
        .set({
      'script': script,
    });
  }

  Future uploadUserVideo(String title, String description, bool public,
      bool join, ReferenceVideo video, String userVideoURL) async {
    return await userVideoCollection.doc('$title:$uid').set({
      'title': title,
      'description': description,
      'source': video.source,
      'type': video.type,
      'uploader': uid,
      'tag': '#연기연습', // TODO: 해쉬태그 기능
      'length': video.length,
      'views': 0,
      'likes': 0,
      'public': public,
      'join': join,
      'thumbnailURL': video.thumbnailURL,
      'videoURL': userVideoURL,
    });
  }
}

Future getVideoSnapshots() async {
  return FirebaseFirestore.instance.collection('videos').get();
}
