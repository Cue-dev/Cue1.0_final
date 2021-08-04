import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Cue/services/user_video.dart';
import 'package:flutter/material.dart';

class UserVideoModel extends ChangeNotifier {
  final List<UserVideo> _userVideos = [];

  List<UserVideo> get userVideoList => _userVideos;

  Future<List<UserVideo>> loadUserVideos() async {
    // ignore: await_only_futures
    // await _userVideos.clear();

    await FirebaseFirestore.instance
        .collection('UserVideos')
        .orderBy('likes',descending:true) // TODO : 캡스톤 용 수정할 것!
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        UserVideo userVideo = UserVideo(
          description: doc['description'],
          source: doc['source'],
          uploader: doc['uploader'],
          nickname: doc['nickname'],
          title: doc['title'],
          type: doc['type'],
          tag: doc['tag'],
          length: int.tryParse(doc['length'].toString()),
          views: int.tryParse(doc['views'].toString()),
          likes: int.tryParse(doc['likes'].toString()),
          comments: int.tryParse(doc['comments'].toString()),
          public: bool.hasEnvironment(doc['public'].toString()),
          join: bool.hasEnvironment(doc['join'].toString()),
          profileURL: doc['profileURL'],
          thumbnailURL: doc['thumbnailURL'],
          videoURL: doc['videoURL'],
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
