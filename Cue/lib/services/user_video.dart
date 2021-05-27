import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class UserVideo {
  String description;
  String source;
  String uploader;
  String tag;
  int length;
  int views;
  int likes;
  int comments;
  bool public;
  bool join;
  String profileURL;
  String thumbnailURL;
  String videoURL;
  String title;
  String nickname;
  String type;

  VideoPlayerController controller;

  UserVideo(
      {this.source,
        this.tag,
        this.description,
        this.uploader,
        this.likes,
        this.length,
        this.views,
        this.comments,
        this.join,
        this.title,
        this.type,
        this.public,
        this.nickname,
        this.profileURL,
        this.videoURL,
        this.thumbnailURL});
}
