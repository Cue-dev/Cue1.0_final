import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference videoCollection =
      FirebaseFirestore.instance.collection('videos');

  Future createUserData(String nickName, String description) async {
    return await userCollection.doc(uid).set({
      'name': nickName,
      'description': description,
      'follwing': 0,
      'follower': 0,
    });
  }

  Future createSaveBothList(String listName) async {
    return await userCollection
        .doc(uid)
        .collection('savedList')
        .doc('savedActList')
        .collection(listName);
  }

  Future createSaveScriptList(String listName) async {
    return await userCollection
        .doc(uid)
        .collection('savedList')
        .doc('savedScriptList')
        .collection(listName);
  }

  // Future createVideoData(String title, String uploader, String url) async {
  //   return await videoCollection.doc('$title:${user.uid}').set({
  //     'title': title,
  //     'likes': 0,
  //     'views': 0,
  //     'uploader': uploader,
  //     'videoURL': url,
  //   });
  // }
}

Future getVideoSnapshots() async {
  return FirebaseFirestore.instance.collection('videos').get();
}
