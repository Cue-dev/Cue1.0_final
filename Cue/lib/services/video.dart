import 'package:video_player/video_player.dart';

class Video {
  String title;
  String source;
  String tag;
  int likes;
  int views;
  String uploader;
  String videoURL;
  String thumbnailURL;
  Map script;

  VideoPlayerController controller;

  Video(
      {this.title,
      this.source,
      this.tag,
      this.likes,
      this.views,
      this.uploader,
      this.videoURL,
      this.thumbnailURL,
      this.script});

  Video.getFromDB(var value, int i) {
    title = value.documents[i].data['title'];
    source = value.documents[i].data['source'];
    tag = value.documents[i].data['tag'];
    likes = value.documents[i].data['likes'];
    views = value.documents[i].data['views'];
    uploader = value.documents[i].data['uploader'];
    videoURL = value.documents[i].data['videoURL'];
    thumbnailURL = value.documents[i].data['thumbnailURL'];
    script = value.documents[i].data['script'];
  }

  setupVideo() {
    controller = VideoPlayerController.network(videoURL)
      ..initialize().then((_) {
        controller.setLooping(true);
      });
  }
}
