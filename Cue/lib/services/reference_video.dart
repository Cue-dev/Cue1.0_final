import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class ReferenceVideo {
  String title;
  String source;
  String type;
  List<String> tag;
  Map script;
  int length;
  int views;
  int challenges;
  String thumbnailURL;
  String videoURL;

  VideoPlayerController controller;

  ReferenceVideo(
      {this.title,
      this.source,
      this.type,
      this.tag,
      this.script,
      this.length,
      this.views,
      this.challenges,
      this.videoURL,
      this.thumbnailURL});

  // Video.getFromDB(var value, int i) {
  //   title = value.documents[i].data['title'];
  //   source = value.documents[i].data['source'];
  //   tag = value.documents[i].data['tag'];
  //   likes = value.documents[i].data['likes'];
  //   views = value.documents[i].data['views'];
  //   uploader = value.documents[i].data['uploader'];
  //   videoURL = value.documents[i].data['videoURL'];
  //   thumbnailURL = value.documents[i].data['thumbnailURL'];
  //   script = value.documents[i].data['script'];
  // }

  // setupVideo() {
  //   controller = VideoPlayerController.network(videoURL)
  //     ..initialize().then((_) {
  //       controller.setLooping(true);
  //     });
  // }
}
