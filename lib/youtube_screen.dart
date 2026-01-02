// import 'package:enhanced_url_launcher/enhanced_url_launcher_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeScreen extends StatefulWidget {
  const YoutubeScreen({super.key, required this.url});
  final String url;
  @override
  State<YoutubeScreen> createState() => _YoutubeScreenState();
}

class _YoutubeScreenState extends State<YoutubeScreen> {
  late YoutubePlayerController ycontroller;

  @override
  void initState() {
    super.initState();

    // allowing rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    // converting link to youtube id
    final vid = YoutubePlayer.convertUrlToId(widget.url);
    // create a youtube controller
    ycontroller = YoutubePlayerController(
        initialVideoId: vid!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
        ));
  }

  @override
  dispose() {

    // dismissing rotation mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ycontroller
      .addListener(() {
        if (!ycontroller.value.isFullScreen) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
        }
      });

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: ycontroller,
              topActions: [
                IconButton(
                    onPressed: () {
                      // .....setting back button in player...................
                      if (ycontroller.value.isFullScreen) {
                        ycontroller.toggleFullScreenMode();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      shadows: [
                        Shadow(
                            color: Colors.white,
                            offset: Offset.zero,
                            blurRadius: 2)
                      ],
                    ))
              ],
            ),
            builder: (context, player) => Center(
                  child: player,
                )),
      ),
    );
  }
}

// .............url launcher....................
class Launcher {
  Future<void> launch(String url) async {
    if (!await launchUrlString(url, mode: LaunchMode.externalApplication)) {
      throw ("could not launch");
    }
  }
}