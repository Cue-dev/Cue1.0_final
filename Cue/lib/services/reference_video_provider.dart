import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Cue/services/reference_video.dart';
import 'package:flutter/material.dart';

class ReferenceVideoModel extends ChangeNotifier {
  final List<ReferenceVideo> _referenceVideos = [];

  List<ReferenceVideo> get referenceVideoList => _referenceVideos;

  Future<List<ReferenceVideo>> loadReferenceVideos() async {
    // ignore: await_only_futures
    // await _referenceVideos.clear();

    await FirebaseFirestore.instance
        .collection('ReferenceVideos')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        ReferenceVideo referenceVideo = ReferenceVideo(
            title: doc['title'],
            source: doc['source'],
            type: doc['type'],
            tag: List.from(doc['tag']),
            script: doc['script'],
            length: int.tryParse(doc['length'].toString()),
            views: int.tryParse(doc['views'].toString()),
            challenges: int.tryParse(doc['challenges'].toString()),
            thumbnailURL: doc['thumbnailURL'],
            videoURL: doc['videoURL']);
        add(referenceVideo);
      });
    });
    print(_referenceVideos.length);
    return _referenceVideos;
  }

  void add(ReferenceVideo referenceVideo) {
    _referenceVideos.add(referenceVideo);
    notifyListeners();
  }

  void removeAll() {
    _referenceVideos.clear();
    notifyListeners();
  }
}
