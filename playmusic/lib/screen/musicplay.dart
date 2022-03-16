import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';


import 'package:audio_manager/audio_manager.dart';
import 'package:audio_session/audio_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:playmusic/api/database.dart';
import 'package:playmusic/home_screen.dart';
import 'package:playmusic/music.dart';
import 'package:playmusic/screen/listmusic.dart';
import 'package:playmusic/screen/mainscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:playmusic/testcode/common.dart';
import 'package:rxdart/rxdart.dart';


class MusicPlayer extends StatefulWidget {

  String name, image, url, singer ;
  int duration;

  MusicPlayer({required this.name,required this.image,required this.url,required this.singer,required this.duration});


  @override
  _MusicPlayerState createState() => _MusicPlayerState();

}

//double currentSlider = 0;

class _MusicPlayerState extends State<MusicPlayer> with WidgetsBindingObserver {



  Widget bottommusic() {

    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(child:
        Icon(Icons.skip_previous_outlined,color: Colors.white, size: 40)
          ,onTap: (){



          },
        ),
        InkWell(child:
        Icon(Icons.play_arrow,color: Colors.white, size: 40)
          ,onTap: (){

            //playNext();



          },


        ),

        InkWell(child:
        Icon(Icons.skip_next_outlined,color: Colors.white, size: 40)
          ,onTap: (){

            //playNext();



          },
        ),
      ],
    );
  }

  late final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    try {
      await _player.setAudioSource(
          AudioSource.uri(
              Uri.parse(widget.url)));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {

      _player.stop();
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));





  @override
  Widget build(BuildContext context) {

    final CollectionReference createmusicplaylist = FirebaseFirestore.instance.collection('playlist');


    return Stack(
      children: [
        Hero(
          tag: "image",
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.image), fit: BoxFit.cover)),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon:Icon(Icons.arrow_back_ios,),
              onPressed: (){
                Navigator.pop(context);
                _player.stop();
              },
            ),
            backgroundColor: Colors.black26,
            elevation: 0,
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "คุณกำลังฟังเพลง",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text((widget.name ) , style: TextStyle(fontSize: 15))
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 8, left: 15),
                child: Icon(Icons.music_note_sharp, size: 30),
              )
            ],
          ),

          body: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 50, left: 20, right: 20),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  blurRadius: 14,
                  spreadRadius: 16,
                  color: Colors.black.withOpacity(0.2),
                )
              ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    height: 280,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            width: 1.5, color: Colors.white.withOpacity(0.2))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                          EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),

                              IconButton(
                                icon: Icon(Icons.add,color: Colors.white,size: 40,),
                                onPressed: () async {

                                  if(createmusicplaylist.where('name') == widget.name) {

                                    Fluttertoast.showToast(
                                        msg: 'เพลงนี้อยู่ในเพลย์ลิสเรียบร้อยแล้ว',
                                        gravity: ToastGravity.TOP
                                    );

                                  } else {
                                  await createmusicplaylist.add({
                                  "name": widget.name,
                                  "image" : widget.image,
                                  "url" : widget.url,
                                  "singer": widget.singer,
                                  "duration": widget.duration,
                                  });
                                  Fluttertoast.showToast(
                                      msg: 'เพิ่มเข้าเพลย์ลิสเรียบร้อยแล้ว',
                                      gravity: ToastGravity.TOP
                                  );
                                  }

                                },

                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            widget.singer,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                        StreamBuilder<PositionData>(
                          stream: _positionDataStream,
                          builder: (context, snapshot) {
                            final positionData = snapshot.data;
                            return SeekBar(
                              duration: positionData?.duration ?? Duration.zero,
                              position: positionData?.position ?? Duration.zero,
                              bufferedPosition:
                              positionData?.bufferedPosition ?? Duration.zero,
                              onChangeEnd: _player.seek,
                            );

                          },
                        ),


                  //     Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 20),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text( Duration(seconds: currentSlider.toInt())
                  //               .toString()
                  //               .split('.')[0]
                  //               .substring(2),
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //           Text( Duration(seconds: currentSlider.toInt())
                  //               .toString()
                  //               .split('.')[0]
                  //               .substring(2),
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //
                  //         ],
                  //
                  //       ),
                  //     ),


                        SizedBox(
                          height: 10,
                        ),



                       // bottommusic(), // widget ปุ่มเพลง
                        ControlButtons(_player),

                        SizedBox(
                          height: 10,
                        ),


                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder<LoopMode>(
                                stream: _player.loopModeStream,
                                builder: (context, snapshot) {
                                  final loopMode = snapshot.data ?? LoopMode.off;
                                  const icons = [
                                    Icon(Icons.repeat, color: Colors.white , size: 40),
                                    Icon(Icons.repeat, color: Colors.red , size: 40),
                                    Icon(Icons.repeat_one, color: Colors.red , size: 40),
                                  ];
                                  const cycleModes = [
                                    LoopMode.off,
                                    LoopMode.all,
                                    LoopMode.one,
                                  ];
                                  final index = cycleModes.indexOf(loopMode);
                                  return IconButton(
                                    icon: icons[index],
                                    onPressed: () {
                                      _player.setLoopMode(cycleModes[
                                      (cycleModes.indexOf(loopMode) + 1) %
                                          cycleModes.length]);
                                    },
                                  );
                                },
                              ),


                              StreamBuilder<bool>(
                                stream: _player.shuffleModeEnabledStream,
                                builder: (context, snapshot) {
                                  final shuffleModeEnabled = snapshot.data ?? false;
                                  return IconButton(
                                    icon: shuffleModeEnabled
                                        ? Icon(Icons.shuffle, color: Colors.red, size: 40)
                                        : Icon(Icons.shuffle, color: Colors.white, size: 40),
                                    onPressed: () async {
                                      final enable = !shuffleModeEnabled;
                                      if (enable) {
                                        await _player.shuffle();
                                      }
                                      await _player.setShuffleModeEnabled(enable);
                                    },
                                  );
                                },
                              ),

                            ],
                          ),
                        ),


                         ],


                    ),

                  ),
                ),
              ),
            ),
          ),

        ),

      ],

    );


  }





}


class VerticalSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;

  const VerticalSlider({
    Key? key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
            thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 2),
            trackShape: RectangularSliderTrackShape(),
            trackHeight: 6),
        child: Slider(
          value: value,
          max: max,
          min: min,
          //label: currentpostlabel,
          //divisions: maxduration,
          inactiveColor: Colors.white70,
          activeColor: Colors.red,
          onChanged: (double value) async {

          },
        ),


      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        IconButton(
          icon: Icon(Icons.volume_up,color: Colors.white,),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "เพิ่ม / ลด เสียงเพลง",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),

        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_previous_outlined,color: Colors.white, size: 40),
            onPressed: () async {
              await player.seek(Duration(seconds: 0));
            },
          ),
        ),

        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: EdgeInsets.all(8.0),
                width: 40.0,
                height: 40.0,
                child: CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(Icons.play_arrow),
                iconSize: 40.0,
                color: Colors.white,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(Icons.pause),
                iconSize: 40.0,
                color: Colors.white,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: Icon(Icons.replay),
                iconSize: 40.0,
                color: Colors.white,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),

        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_next_outlined,color: Colors.white, size: 40),
            onPressed: () async {
              await player.seek(Duration(seconds: 600));
            },
          ),
        ),

        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "ความเร็วของเพลง",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),


      ],

    );
  }
}