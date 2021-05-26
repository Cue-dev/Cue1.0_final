import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Cue/services/feed_test.dart';
import 'package:flutter/material.dart';

class FeedTestModel extends ChangeNotifier {
  final List<FeedTest> _feedTests = [];

  List<FeedTest> get feedTestList => _feedTests;

  Future<List<FeedTest>> loadFeedTests() async {
    // ignore: await_only_futures
    await _feedTests.clear();

    await FirebaseFirestore.instance
        .collection('feedtest')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        FeedTest feedTest = FeedTest(
            description: doc.data()['description'],
            source: doc.data()['source'],
            uploader: doc.data()['uploader'],
            tag: List.from(doc.data()['tag']),
            length: int.tryParse(doc.data()['length'].toString()),
            views: int.tryParse(doc.data()['views'].toString()),
            likes: int.tryParse(doc.data()['likes'].toString()),
            comments: int.tryParse(doc.data()['comments'].toString()),
            public: bool.hasEnvironment(doc.data()['public'].toString()),
            join: bool.hasEnvironment(doc.data()['join'].toString()),
            profileURL: doc.data()['profileURL'],
            thumbnailURL: doc.data()['thumbnailURL'],
            videoURL: doc.data()['videoURL']);
        add(feedTest);
      });
    });
    return _feedTests;
  }

  void add(FeedTest feedTest) {
    _feedTests.add(feedTest);
    notifyListeners();
  }

  void removeAll() {
    _feedTests.clear();
    notifyListeners();
  }
}
