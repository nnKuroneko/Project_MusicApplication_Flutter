import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playmusic/screen/mainscreen.dart';
import 'package:playmusic/screen/musicplay.dart';

class Song {
  final String name;
  final String singer;
  final String image;
  final String url;
  final int duration;

  Song(
      {required this.name,
        required this.singer,
        required this.image,
        required this.url,
        required this.duration
        });


  static void forEach(void Function(dynamic item) param0) {}

}

