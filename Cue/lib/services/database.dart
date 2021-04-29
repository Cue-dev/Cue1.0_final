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

// TODO: 콜렉션을 추가하려면 문서가 하나 필요하다. 이걸 어떻게 할 것인가...!!!!!!
// Dialog 내에서 저장목록 추가 누르면 보여주기만 하고 저장 버튼 눌러서 저장할 때 그때 디비 건들까?
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
