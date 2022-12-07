import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:music_player_app/pages/full_player.dart';
import 'package:music_player_app/pages/mini_player_and_b_nav.dart';
import 'package:music_player_app/widgets/b_nav.dart';
import 'package:page_animation_transition/animations/bottom_to_top_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import '../pages/mini_player.dart';
import '../services/player_logic.dart';

class CircularMiniPlayer extends StatefulWidget {
  const CircularMiniPlayer({super.key});

  @override
  State<CircularMiniPlayer> createState() => _CircularMiniPlayerState();
}

class _CircularMiniPlayerState extends State<CircularMiniPlayer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 70,
      child: ValueListenableBuilder<bool>(
          valueListenable: miniPlayerVisibilityListenable,
          builder: (BuildContext context, bool playing, Widget? child) {
            if (playing) {
              // print('affsdfasf');
              // Future.delayed(const Duration(milliseconds: 10), () {
              //   bNavPaddingListenable.value =
              //       const EdgeInsets.fromLTRB(0, 0, 0, 0);
              // });
              return GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dy < 0) {
                    Navigator.of(context).push(
                      PageAnimationTransition(
                          page: const Player(),
                          pageAnimationType: BottomToTopTransition()),
                    );
                  } else if (details.delta.dy > 0) {
                    audioPlayer.stop();
                    bNavPaddingListenable.value =
                        const EdgeInsets.fromLTRB(0, 0, 45, 0);
                    miniPlayerVisibilityListenable.value = false;
                  }
                },
                onTap: () {
                  if (isPlaying) {
                    isPlayingListenable.value = false;
                    audioPlayer.pause();
                  } else {
                    isPlayingListenable.value = true;
                    audioPlayer.play();
                  }
                  isPlaying = !isPlaying;
                },
                // onTap: () {
                //   Navigator.of(context).push(
                //     PageAnimationTransition(
                //         page: const Player(),
                //         pageAnimationType: BottomToTopTransition()),
                //   );
                // },
                child: const MiniArtWork(),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
