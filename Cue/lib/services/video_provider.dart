import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Cue/services/reference_video.dart';
import 'package:flutter/material.dart';

class ReferenceVideoModel extends ChangeNotifier {
  final List<ReferenceVideo> _referenceVideos = [];

  List<ReferenceVideo> get referenceVideoList => _referenceVideos;

  Future<List<ReferenceVideo>> loadReferenceVideos() async {
    // ignore: await_only_futures
    await _referenceVideos.clear();

    await FirebaseFirestore.instance
        .collection('ReferenceVideos')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        ReferenceVideo referenceVideo = ReferenceVideo(
            title: doc.data()['title'],
            source: doc.data()['source'],
            type: doc.data()['type'],
            tag: List.from(doc.data()['tag']),
            // script: doc.data()['script'],
            length: int.tryParse(doc.data()['length'].toString()),
            views: int.tryParse(doc.data()['views'].toString()),
            challenges: int.tryParse(doc.data()['challenges'].toString()),
            thumbnailURL: doc.data()['thumbnailURL'],
            videoURL: doc.data()['videoURL']);
        add(referenceVideo);
      });
    });
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
