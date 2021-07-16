import 'package:bloc/bloc.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class PlayerCubit extends Cubit<SongInfo> {
  PlayerCubit() : super(null);

  AudioPlayer audioPlayer = AudioPlayer();
  FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> playlist;

  BehaviorSubject<double> currentPosition = BehaviorSubject();
  BehaviorSubject<bool> playing = BehaviorSubject();
  

  init() async {
    playlist = await audioQuery.getSongs();
    audioPlayer.positionStream.listen((event) {
      print(event);
      currentPosition.add(event.inMilliseconds.toDouble());
    });
    playing.add(false);
    audioPlayer.playingStream.listen((event) {playing.add(event);});
  }

  setSong(String songUrl) async {
    await audioPlayer.setUrl(songUrl);
    emit(playlist[audioPlayer.currentIndex]);
    print('song set done');
    print('1- ${state.uri}');
    print('2- $songUrl');
  }

  nextSong() async {
    print(audioPlayer.hasNext);
    await audioPlayer.seekToNext();
    print('${audioPlayer.currentIndex}');
    emit(playlist[audioPlayer.currentIndex]);
  }

  prevSong() async {
    await audioPlayer.seekToPrevious();
  }

  play() async {
    await audioPlayer.play();
    playing.add(true);
  }

  pause() async {
    await audioPlayer.pause();
  }

  seek(double time) async {
    print('seeking - ${time.toInt()}');
    print(currentPosition.value);
    await audioPlayer.seek(Duration(milliseconds: time.round()));
    print(audioPlayer.position);
    print(currentPosition.value);
    print(audioPlayer.position);
  }

  static String formatDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }
}