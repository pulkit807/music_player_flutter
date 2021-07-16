import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:music_player/custom_slider/custom_slider.dart';
import 'package:music_player/player_cubit.dart';

class PlayerWindow extends StatefulWidget {
  @override
  _PlayerWindowState createState() => _PlayerWindowState();
}

class _PlayerWindowState extends State<PlayerWindow> {
  bool isplaying = true;
  PlayerCubit playerCubit;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    playerCubit = context.watch<PlayerCubit>();
    return Scaffold(
      backgroundColor: Color(0xFF07285F),
      body: Stack(
        children: [
          Positioned(
            top: size.height * 0.08 + 10,
            left: size.width * 0.35,
            child: Text(
              "Now Playing",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 22),
            ),
          ),
          Positioned(
            top: size.height * 0.08,
            left: 10.0,
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: 25,
                  color: Colors.white,
                )),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: size.height * 0.82,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF07285F),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF4c6794), blurRadius: 50.0)
                              ]),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.white, //Color(0xFF07285F),

                            backgroundImage:
                                playerCubit.state.albumArtwork == null
                                    ? AssetImage('assets/music.png')
                                    : FileImage(
                                        File(playerCubit.state.albumArtwork)),
                          ),
                        ),
                        SizedBox(height: 40),
                        Text(
                          'Say Sorry', //playerCubit.state.title,
                          style: TextStyle(
                              color: Color(0xFF07285F),
                              fontFamily: 'Comfortaa',
                              fontWeight: FontWeight.w900,
                              fontSize: 18),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Navel Joy', //playerCubit.state.artist,
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: 'Comfortaa',
                              fontWeight: FontWeight.w900,
                              fontSize: 13),
                        ),
                        SizedBox(height: 30),
                        StreamBuilder(
                            stream: playerCubit.currentPosition,
                            builder: (context, snapshot) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.08),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      PlayerCubit.formatDuration(snapshot.data),
                                      style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 10.0),
                                    Expanded(
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                            trackHeight: 3,
                                            thumbShape: CustomSliderThumb(
                                                theme: Color(0xFF07285F)),
                                            overlayShape:
                                                RoundSliderOverlayShape(
                                                    overlayRadius: 0.0),
                                            trackShape: CustomTrackShape()),
                                        child: Slider(
                                          value: snapshot.data,
                                          onChanged: (value) {
                                            setState(() {
                                              playerCubit.seek(value);
                                            });
                                          },
                                          max: playerCubit.audioPlayer.duration
                                              .inMilliseconds
                                              .toDouble(),
                                          min: 0,
                                          activeColor: Color(0xFF07285F),
                                          inactiveColor: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    Text(
                                      PlayerCubit.formatDuration(playerCubit
                                          .audioPlayer.duration.inMilliseconds
                                          .toDouble()),
                                      style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              );
                            }),
                        SizedBox(height: 30.0),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    playerCubit.nextSong();
                                  },
                                  icon: Icon(
                                    Icons.skip_previous_outlined,
                                    color: Color(0xFF07285F),
                                    size: 25,
                                  ),
                                ),
                              ),
                              StreamBuilder<bool>(
                                  stream: playerCubit.playing,
                                  builder: (context, snapshot) {
                                    print('playing - ${snapshot.data}');
                                    return GestureDetector(
                                      onTap: () {
                                        playerCubit.audioPlayer.playing
                                            ? playerCubit.pause()
                                            : playerCubit.play();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF07285F),
                                        ),
                                        child: Icon(
                                          snapshot.data
                                              ? Icons.pause_outlined
                                              : Icons.play_arrow_outlined,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                      ),
                                    );
                                  }),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    playerCubit.nextSong();
                                  },
                                  icon: Icon(
                                    Icons.skip_next_outlined,
                                    color: Color(0xFF07285F),
                                    size: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
