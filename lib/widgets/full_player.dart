//import 'dart:io';
//import 'dart:typed_data';

import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:music_player_app/pages/mini_player.dart';
import 'package:music_player_app/pages/search_page.dart';
import 'package:music_player_app/pages/songs.dart';
import 'package:music_player_app/services/colours.dart';
import 'package:music_player_app/services/global.dart';
import 'package:youtube/youtube_thumbnail.dart';
import '../services/screen_sizes.dart';
import '../services/player_logic.dart';
// import 'package:blurrycontainer/blurrycontainer.dart';

ValueNotifier<String> currSongIdListenable = ValueNotifier<String>(currSongId);
ValueNotifier<int> currSongIndexListenable = ValueNotifier<int>(currSongIndex);
var bgBlur = ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0);

class Player extends StatefulWidget {
  Player({
    Key? key,
    // required this.statusBarColor,
  }) : super(key: key);
  // final Color statusBarColor;
  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  void initState() {
    super.initState();
    // currBG = defaultBG;
    getCurrBG();
    setStatusBackGroundTransParent();
    bgBlur = ImageFilter.blur(sigmaX: 14.0, sigmaY: 14.0);
  }

  final keyOfBackGround = GlobalKey<_AnimatedBackGroundContainerState>();
  Future setStatusBackGroundTransParent() async {
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                Brightness.light, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     // Status bar color
    //     statusBarColor: Colors.transparent,

    //     // Status bar brightness (optional)
    //     statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    //     statusBarBrightness: Brightness.light, // For iOS (dark icons)
    //   ),
    // );
    return
        // SafeArea(
        //   child:
        Stack(
      children: [
        AnimatedBackGroundContainer(
          key: keyOfBackGround,
        ),
        BackdropFilter(
          filter: bgBlur,
          child: GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dy > 10) {
                setState(() {
                  bgBlur = ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0);
                });
                Navigator.pop(context);
              }
              // else if (details.delta.dy > 0) {
              //   miniPlayerVisibilityListenable.value = false;
              // }
            },
            child: Scaffold(
                extendBodyBehindAppBar: true,
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  // child:
                  // SafeArea(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // IconButton(
                        //   onPressed: () {
                        //     Navigator.pop(context);
                        //   },
                        //   icon: const Icon(Icons.arrow_back_ios_new),
                        // ),
                        const SizedBox(
                          height: 60,
                        ),
                        Center(
                          child: Column(
                            children: [
                              //Song Banner..........................................................//

                              const ArtWork(),

                              //Song Name in Marquee.......................................................................................//
                              const SizedBox(
                                height: 50,
                              ),

                              ValueListenableBuilder<int>(
                                  valueListenable: currSongIndexListenable,
                                  builder: (BuildContext context, int songIndex,
                                      Widget? child) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 15, 0),
                                          child: MarqueeText(
                                            text: TextSpan(
                                              text: (currSongIsWeb)
                                                  ? currSongList![songIndex]
                                                      .title
                                                  : currSongName,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style: const TextStyle(
                                              fontSize: 28,
                                            ),
                                            speed: 10,
                                          ),
                                        ),

                                        //Artist Name in Marquee.......................................................................................//

                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 15, 0),
                                          child: MarqueeText(
                                            text: TextSpan(
                                              text: (currSongIsWeb)
                                                  ? currSongList![songIndex]
                                                      .artist
                                                  : currSongArtistName,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                            speed: 10,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),

                              // Container(
                              //   padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              //   child: MarqueeText(
                              //     text: TextSpan(
                              //       text: currSongName,
                              //       style: const TextStyle(color: Colors.white),
                              //     ),
                              //     style: const TextStyle(
                              //       fontSize: 28,
                              //     ),
                              //     speed: 10,
                              //   ),
                              // ),

                              // //Artist Name in Marquee.......................................................................................//

                              // Container(
                              //   padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              //   child: MarqueeText(
                              //     text: TextSpan(
                              //       text: currSongArtistName,
                              //       style: const TextStyle(color: Colors.white),
                              //     ),
                              //     style: const TextStyle(
                              //       fontSize: 18,
                              //     ),
                              //     speed: 10,
                              //   ),
                              // ),

                              const SizedBox(
                                height: 10,
                              ),

                              //Current and End Time of songs....................................//

                              ValueListenableBuilder<Duration>(
                                valueListenable: songPositionListenable,
                                builder: (BuildContext context,
                                    Duration songPosition, Widget? child) {
                                  return Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          songPosition.toString().split(".")[0],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          songDuration.toString().split(".")[0],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              // PlayBack Slider ...................................................//

                              ValueListenableBuilder<Duration>(
                                valueListenable: songPositionListenable,
                                builder: (BuildContext context,
                                    Duration songPosition, Widget? child) {
                                  return Slider(
                                      min: const Duration(microseconds: 0)
                                          .inSeconds
                                          .toDouble(),
                                      value: songPosition.inSeconds.toDouble(),
                                      max: songDuration.inSeconds.toDouble(),
                                      activeColor: Colors.white,
                                      inactiveColor: veryLightPurple,
                                      onChanged: (val) {
                                        setState(() {
                                          changeToSeconds(val.toInt());
                                          val = val;
                                        });
                                      });
                                },
                              ),

                              //Control Buttons....................................................//

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Previous Song Button..........................................//

                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        skipToPrev();
                                      });
                                    },
                                    color: Colors.white,
                                    icon:
                                        const Icon(Icons.skip_previous_rounded),
                                    iconSize: 60,
                                  ),

                                  // Play--Pause Button.............................................//

                                  Stack(
                                    children: [
                                      ValueListenableBuilder<bool>(
                                          valueListenable: isFetchingUri,
                                          builder: (BuildContext context,
                                              bool isFetching, Widget? child) {
                                            if (isFetching) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5.5, 5.5, 0, 0),
                                                child: LoadingAnimationWidget
                                                    .threeArchedCircle(
                                                  color: Colors.white,
                                                  size: 65,
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          }),
                                      ValueListenableBuilder<bool>(
                                          valueListenable: isPlayingListenable,
                                          builder: (BuildContext context,
                                              bool isPlaying, Widget? child) {
                                            return IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (isPlaying) {
                                                    isPlayingListenable.value =
                                                        false;
                                                    audioPlayer.pause();
                                                  } else {
                                                    isPlayingListenable.value =
                                                        true;
                                                    audioPlayer.play();
                                                  }
                                                  setState(() {
                                                    isPlaying = !isPlaying;
                                                  });
                                                });
                                              },
                                              color: Colors.white,
                                              icon: isPlaying
                                                  ? const Icon(
                                                      Icons.pause_circle_filled)
                                                  : const Icon(
                                                      Icons.play_circle_filled),
                                              iconSize: 60,
                                            );
                                          }),
                                    ],
                                  ),

                                  // Next Song Button..........................................//

                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        skipToNext();
                                      });
                                    },
                                    color: Colors.white,
                                    icon: const Icon(Icons.skip_next_rounded),
                                    iconSize: 60,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // ),
                )),
          ),
        ),
      ],
    );
  }

  changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }
}

class ArtWork extends StatelessWidget {
  const ArtWork({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isFetchingUri,
        builder: (BuildContext context, bool isFetching, Widget? child) {
          if (isFetching) {
            return SizedBox(
              height: logicalWidth * 0.8,
              width: logicalWidth * 0.8,
              child: LoadingAnimationWidget.prograssiveDots(
                  color: Colors.white, size: 150),
            );
          } else {
            return ValueListenableBuilder<String>(
              valueListenable: currSongIdListenable,
              builder:
                  (BuildContext context, String currSongId, Widget? child) {
                if (currSongIsWeb) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(20),
                        ),
                        child: SizedBox(
                          // color: Colors.amber,
                          height: logicalWidth * 0.8,
                          width: logicalWidth * 0.8,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(20),
                              ),
                              child: Image.network(
                                YoutubeThumbnail(
                                        youtubeId: currSongId.toString())
                                    .hd(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: FutureBuilder<Uint8List>(
                      future: audioQuery.getArtwork(
                          size: Size(logicalWidth * 0.75, logicalWidth * 0.75),
                          type: ResourceType.SONG,
                          id: newDepricatedSongList[currSongIndex].id),
                      builder: (_, snapshot) {
                        if (snapshot.data == null) {
                          // print(newDepricatedSongList[currSongIndex].id);
                          return const SizedBox(
                            height: 250.0,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return SizedBox(
                          height: logicalWidth * 0.75,
                          width: logicalWidth * 0.75,
                          child: Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: SizedBox(
                                  height: logicalWidth * 0.75,
                                  width: logicalWidth * 0.75,
                                  child: Image.asset(
                                    'svg/No-Artwork-square-transparent.png',
                                    fit: BoxFit.contain,
                                    scale: 0.5,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                );
                // QueryArtworkWidget(
                //   nullArtworkWidget: SizedBox(
                //     height: logicalWidth * 0.75,
                //     width: logicalWidth * 0.75,
                //     child: ClipRRect(
                //         borderRadius:
                //             const BorderRadius.all(Radius.circular(10)),
                //         child: Image.asset(
                //             'svg/No-Artwork-square-transparent.png')),
                //   ),
                //   id: int.parse(currSongId),
                //   type: ArtworkType.AUDIO,
                //   artworkQuality: FilterQuality.high,
                //   artworkHeight: logicalWidth * 0.75,
                //   artworkWidth: logicalWidth * 0.75,
                // );
              },
            );
          }
        });
  }
}

class AnimatedBackGroundContainer extends StatefulWidget {
  const AnimatedBackGroundContainer({super.key});

  @override
  State<AnimatedBackGroundContainer> createState() =>
      _AnimatedBackGroundContainerState();
}

class _AnimatedBackGroundContainerState
    extends State<AnimatedBackGroundContainer> {
  @override
  void initState() {
    super.initState();
    //getCurrBG();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isFetchingUri,
        builder: (BuildContext context, bool isFetching, Widget? child) {
          if (isFetching) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(defaultBG),
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else {
            if (!currSongIsWeb) {
              return FutureBuilder<Uint8List>(
                future: audioQuery.getArtwork(
                  size: const Size(550, 550),
                  type: ResourceType.SONG,
                  id: newDepricatedSongList[currSongIndex].id,
                ),
                builder: (_, snapshot) {
                  if (snapshot.data == null) {
                    // print("fjkahfjk\n\n\n\n");
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(defaultBG),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }
                  return Stack(
                    children: [
                      (!currSongIsWeb)
                          ? Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: (snapshot.data!.isEmpty)
                                      ? MemoryImage(defaultBG)
                                      : MemoryImage(snapshot.data!),
                                  fit: BoxFit.cover,
                                ),
                                color: const Color.fromARGB(119, 0, 0, 0),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    YoutubeThumbnail(
                                            youtubeId: currSongId.toString())
                                        .mq(),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                color: const Color.fromARGB(119, 0, 0, 0),
                              ),
                            ),
                      Container(
                        color: const Color.fromARGB(119, 0, 0, 0),
                      ),
                    ],
                  );
                  // print(currBG.toString());
                },
              );
            } else {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      YoutubeThumbnail(youtubeId: currSongId.toString()).mq(),
                    ),
                    fit: BoxFit.cover,
                  ),
                  color: const Color.fromARGB(119, 0, 0, 0),
                ),
              );
            }
          }
        });
  }
}
