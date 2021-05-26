import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class FeedTest {
  String description;
  String source;
  String uploader;
  List<String> tag;
  int length;
  int views;
  int likes;
  int comments;
  bool public;
  bool join;
  String profileURL;
  String thumbnailURL;
  String videoURL;

  VideoPlayerController controller;

  FeedTest(
      {this.source,
        this.tag,
        this.description,
        this.uploader,
        this.likes,
        this.length,
        this.views,
        this.comments,
        this.join,
        this.public,
        this.profileURL,
        this.videoURL,
        this.thumbnailURL
      });
}
