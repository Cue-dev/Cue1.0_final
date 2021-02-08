import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Cue/services/video.dart';
import 'package:flutter/material.dart';

class VideoModel extends ChangeNotifier {
  final List<Video> _videos = [];

  List<Video> get videoList => _videos;

  Future<List<Video>> loadVideos() async {
    // ignore: await_only_futures
    await _videos.clear();

    await FirebaseFirestore.instance
        .collection('videos')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Video video = Video(
            title: doc.data()['title'],
            source: doc.data()['source'],
            tag: doc.data()['tag'],
            likes: int.tryParse(doc.data()['likes'].toString()),
            views: int.tryParse(doc.data()['views'].toString()),
            uploader: doc.data()['uploader'],
            videoURL: doc.data()['videoURL'],
            thumbnailURL: doc.data()['thumbnailURL'],
            script: doc.data()['script']);
        add(video);
      });
    });
    return _videos;
  }

  void add(Video video) {
    _videos.add(video);
    notifyListeners();
  }

  void removeAll() {
    _videos.clear();
    notifyListeners();
  }
}
