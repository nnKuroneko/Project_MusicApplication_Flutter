import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';

class MusicWidget extends StatefulWidget {
  const MusicWidget({Key? key}) : super(key: key);

  @override
  _MusicWidgetState createState() => _MusicWidgetState();
}

class _MusicWidgetState extends State<MusicWidget> with SingleTickerProviderStateMixin{

  late AnimationController
  iconController;

  bool isAnimated = false;
  bool showPlay = true;
  bool shopPause = false;

  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    iconController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    audioPlayer.open(Audio('assets/sound/babysharkdance.mp3'),
     autoStart: false,showNotification: true);
   // audioPlayer.open(Audio.network("https://thinknews.com.ng/wp-content/uploads/2021/11/PINKFONG_Baby_Shark_Dance_(thinkNews.com.ng).mp3"),
   //     autoStart: true,showNotification: true);
  }

  void AnimateIcon() {
    setState(() {
      isAnimated = !isAnimated;
      if(isAnimated)
      {
        iconController.forward();
        audioPlayer.play();
      }else{
        iconController.reverse();
        audioPlayer.pause();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    iconController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Playing Audio File Flutter"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network("https://i.pinimg.com/originals/f7/3a/5b/f73a5b4b7262440684a2b5c39e684304.jpg",
                width: 300,),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  InkWell(
                    child: Icon(CupertinoIcons.backward_fill)
                    ,onTap: (){
                    audioPlayer.seekBy(Duration(seconds: -10));
                  },
                  ),
                  GestureDetector(
                    onTap: () {
                      AnimateIcon();
                    },
                    child: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: iconController,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(child: Icon(CupertinoIcons.forward_fill),onTap: (){
                    audioPlayer.seekBy(Duration(seconds: 10));
                    audioPlayer.seek(Duration(seconds: 10));
                    audioPlayer.next();
                  },),
                ],



              ),
            ],
          ),
        ));

  }


}
