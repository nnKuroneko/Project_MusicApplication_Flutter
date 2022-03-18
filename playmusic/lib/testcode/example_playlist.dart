import 'package:audio_session/audio_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:playmusic/testcode/common.dart';
import 'package:rxdart/rxdart.dart';


class MyApp extends StatefulWidget {
  
// ตัวอย่าง playlist ของ just audio ที่เค้าให้้มา

  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  late AudioPlayer _player;


  final _playlist = ConcatenatingAudioSource(
      children: [
    // Remove this audio source from the Windows and Linux version because it's not supported yet
    AudioSource.uri(
      Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/playmusic-d056c.appspot.com/o/Music%2FSunshine%20City.mp3?alt=media&token=d8198cce-7603-417a-8970-5ed576a1c108"),
      tag: Song(
        album: "Desired",
        title: "Sunshine City",
        artwork:
        "https://firebasestorage.googleapis.com/v0/b/playmusic-d056c.appspot.com/o/Singer%2Fdesired.jpg?alt=media&token=96edea13-0734-488a-915a-3882f2a8652a",
      ),
    ),
        AudioSource.uri(
          Uri.parse(
              "https://firebasestorage.googleapis.com/v0/b/playmusic-d056c.appspot.com/o/Music%2FWake_Up.mp3?alt=media&token=314b3c60-5b26-4a4e-ac5d-a80a044cb57a"),
          tag: Song(
            album: "Desired",
            title: "Wake Up",
            artwork:
            "https://firebasestorage.googleapis.com/v0/b/playmusic-d056c.appspot.com/o/Singer%2Fdesired.jpg?alt=media&token=96edea13-0734-488a-915a-3882f2a8652a",
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              "https://firebasestorage.googleapis.com/v0/b/playmusic-d056c.appspot.com/o/Music%2Faespa_savage.mp3?alt=media&token=495dc185-c702-4e4d-b9c0-0f5cb2ae8746"),
          tag: Song(
            album: "Aespa",
            title: "Savage",
            artwork:
            "https://firebasestorage.googleapis.com/v0/b/playmusic-d056c.appspot.com/o/Singer%2Faespa_1.jpg?alt=media&token=427093ae-c88b-4774-9c9e-f8ce563da102",
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              "https://firebasestorage.googleapis.com/v0/b/playmusic-d056c.appspot.com/o/Music%2FLight_Switch_xoos.mp3?alt=media&token=f8881d76-3aee-483a-beed-685a89db848a"),
          tag: Song(
            album: "Xooos",
            title: "Light Switch",
            artwork:
            "https://firebasestorage.googleapis.com/v0/b/playmusic-d056c.appspot.com/o/Singer%2Fxooos.jpg?alt=media&token=9599ba2e-1a9c-4b59-815a-8e68cd7bf646",
          ),
        ),


  ]

  );

  int _addedCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {


    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('ระบบเออเร่อ : $e');
        });
    try {
      // Preloading audio is not currently supported on Linux.
      await _player.setAudioSource(_playlist, preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux);


    } catch (e) {
      // Catch load errors: 404, invalid url...
      print("เออเร่อ โหลดเพลงไม่ได้ : $e");
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
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
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


  final CollectionReference playlist = FirebaseFirestore.instance.collection('playlist');

  @override
  Widget build(BuildContext context) {

    final CollectionReference playlist = FirebaseFirestore.instance.collection('playlist');

    return Scaffold(

      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon:Icon(Icons.arrow_back_ios,),
          onPressed: (){
            Navigator.pop(context);
            _player.stop();
          },
        ),
        backgroundColor: Colors.black12,
        elevation: 0,
        actions: [

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Playlist Music",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(("เพลย์ลิสเริ่มต้น" ) , style: TextStyle(fontSize: 15))
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 8, left: 15),
            child: Icon(Icons.my_library_music, size: 30),
          )



        ],
      ),
        body: SafeArea(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder<SequenceState?>(
                  stream: _player.sequenceStateStream,
                  builder: (context, snapshot) {

                    final state = snapshot.data;
                    if (state?.sequence.isEmpty ?? true) return SizedBox();

                    final metadata = state!.currentSource!.tag as Song;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Center(child: Image.network(metadata.artwork,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,)

                            ),
                          ),
                        ),
                        Text(metadata.album,
                            style: TextStyle(color: Colors.white),),
                        Text(metadata.title
                        ,style: TextStyle(color: Colors.white),
                        ),

                      ],
                    );
                  },
                ),

              ),
              ControlButtons(_player),
              StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return SeekBar(
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition:
                    positionData?.bufferedPosition ?? Duration.zero,
                    onChangeEnd: (newPosition) {
                      _player.seek(newPosition);
                    },
                  );
                },
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  StreamBuilder<LoopMode>(
                    stream: _player.loopModeStream,
                    builder: (context, snapshot) {
                      final loopMode = snapshot.data ?? LoopMode.off;
                      const icons = [
                        Icon(Icons.repeat, color: Colors.white),
                        Icon(Icons.repeat, color: Colors.red),
                        Icon(Icons.repeat_one, color: Colors.red),
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
                  Expanded(
                    child: Text(
                      "Playlist",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,

                    ),
                  ),
                  StreamBuilder<bool>(

                    stream: _player.shuffleModeEnabledStream,
                    builder: (context, snapshot) {
                      final shuffleModeEnabled = snapshot.data ?? false;
                      return IconButton(
                        icon: shuffleModeEnabled
                            ? Icon(Icons.shuffle, color: Colors.red)
                            : Icon(Icons.shuffle, color: Colors.white),
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
              Container(

                height: 100.0,

                child: StreamBuilder<SequenceState?>(
                  stream: _player.sequenceStateStream,
                  builder: (context, snapshot) {

                    final state = snapshot.data;
                    final sequence = state?.sequence ?? [];

                    return ReorderableListView(
                      onReorder: (int oldIndex, int newIndex) {
                        if (oldIndex < newIndex) newIndex--;
                        _playlist.move(oldIndex, newIndex);
                      },
                      children: [
                        for (var i = 0; i < sequence.length; i++)
                          Dismissible(

                            key: ValueKey(sequence[i]),

                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                            onDismissed: (dismissDirection) {
                              _playlist.removeAt(i);
                            },
                            child: Material(

                              color: i == state!.currentIndex
                                  ? Colors.black
                                  : Colors.black,

                              child: ListTile(
                                title: Text(sequence[i].tag.title as String ,
                                  style: TextStyle(
                                  color: Colors.white,
                                 ),
                                ),
                                onTap: () {
                                  _player.seek(Duration.zero, index: i);
                                },
                              ),
                            ),
                          ),
                      ],
                    );

                  },
                ),
              ),




            ],
          ),
        ),
    //  floatingActionButton: FloatingActionButton(
    //    child: Icon(Icons.add),
    //    onPressed: () {
    //      _playlist.add(AudioSource.uri(
    //        Uri.parse("asset:///audio/nature.mp3"),
    //        tag: Song(
    //          album: "Public Domain",
    //          title: "Nature Sounds ${++_addedCount}",
    //          artwork:
    //          "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
    //        ),
    //      ));
    //    },
    //  ),

      );

  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.volume_up,color: Colors.white),
          onPressed: () {
            showSliderDialog(

              context: context,
              title: "เพิ่ม & ลดเสียงเพลง",
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
            icon: Icon(Icons.skip_previous,color: Colors.white),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
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
                width: 64.0,
                height: 64.0,
                child: CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(Icons.play_arrow,color: Colors.white),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(Icons.pause,color: Colors.white),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: Icon(Icons.replay,color: Colors.white),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices!.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_next,color: Colors.white),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "เพิ่ม & ลดความเร็ว",
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

class playlist extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final CollectionReference playlist = FirebaseFirestore.instance.collection('playlist');

    return Container(
        child: StreamBuilder(
            stream: playlist.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData){
                return Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                        ConcatenatingAudioSource(
                          children: [
                            AudioSource.uri(
                              Uri.parse(
                                  documentSnapshot['url'].toString()),
                              tag: Song(
                                album: documentSnapshot['name'].toString(),
                                title: documentSnapshot['singer'].toString(),
                                artwork:
                                documentSnapshot['image'].toString(),
                              ),
                            ),
                          ],
                        );
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        )
    );
  }
}

class Song {
  final String album;
  final String title;
  final String artwork;

  Song({
    required this.album,
    required this.title,
    required this.artwork,
  });
}

