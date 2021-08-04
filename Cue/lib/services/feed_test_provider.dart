import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Cue/services/feed_test.dart';
import 'package:flutter/material.dart';

class FeedTestModel extends ChangeNotifier {
  final List<FeedTest> _feedTests = [];

  List<FeedTest> get feedTestList => _feedTests;

  Future<List<FeedTest>> loadFeedTests() async {
    // ignore: await_only_futures
    // if (_feedTests.isNotEmpty)
    //   await _feedTests.clear();

    await FirebaseFirestore.instance
        .collection('feedtest')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        FeedTest feedTest = FeedTest(
            description: doc['description'],
            source: doc['source'],
            uploader: doc['uploader'],
            tag: List.from(doc['tag']),
            length: int.tryParse(doc['length'].toString()),
            views: int.tryParse(doc['views'].toString()),
            likes: int.tryParse(doc['likes'].toString()),
            comments: int.tryParse(doc['comments'].toString()),
            public: bool.hasEnvironment(doc['public'].toString()),
            join: bool.hasEnvironment(doc['join'].toString()),
            profileURL: doc['profileURL'],
            thumbnailURL: doc['thumbnailURL'],
            videoURL: doc['videoURL']);
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
