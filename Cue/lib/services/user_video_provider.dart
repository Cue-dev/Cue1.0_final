import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Cue/services/user_video.dart';
import 'package:flutter/material.dart';

class UserVideoModel extends ChangeNotifier {
  final List<UserVideo> _userVideos = [];

  List<UserVideo> get userVideoList => _userVideos;

  Future<List<UserVideo>> loadUserVideos() async {
    // ignore: await_only_futures
    await _userVideos.clear();

    await FirebaseFirestore.instance
        .collection('UserVideos')
        .orderBy('likes',descending:true) // TODO : 캡스톤 용 수정할 것!
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        UserVideo userVideo = UserVideo(
            description: doc.data()['description'],
            source: doc.data()['source'],
            uploader: doc.data()['uploader'],
            nickname: doc.data()['nickname'],
            title: doc.data()['title'],
            type: doc.data()['type'],
            tag: doc.data()['tag'],
            length: int.tryParse(doc.data()['length'].toString()),
            views: int.tryParse(doc.data()['views'].toString()),
            likes: int.tryParse(doc.data()['likes'].toString()),
            comments: int.tryParse(doc.data()['comments'].toString()),
            public: bool.hasEnvironment(doc.data()['public'].toString()),
            join: bool.hasEnvironment(doc.data()['join'].toString()),
            profileURL: doc.data()['profileURL'],
            thumbnailURL: doc.data()['thumbnailURL'],
            videoURL: doc.data()['videoURL'],
           );
        add(userVideo);
      });
    });
    return _userVideos;
  }

  void add(UserVideo userVideo) {
    _userVideos.add(userVideo);
    notifyListeners();
  }

  void removeAll() {
    _userVideos.clear();
    notifyListeners();
  }
}
