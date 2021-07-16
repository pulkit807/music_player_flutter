import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/player_cubit.dart';
import 'player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrackList extends StatefulWidget {
  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  FlutterAudioQuery _audioQuery = FlutterAudioQuery();
  List<SongInfo> songs;
  int currentIndex;

  @override
  initState() {
    super.initState();
    getSongs();
  }

  getSongs() async {
    songs = await _audioQuery.getSongs();
    setState(() {
      songs = songs;
      print(songs.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(Icons.music_note, color: Colors.black),
        title: Text('Music App', style: TextStyle(color: Colors.black)),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: songs.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(songs[index].title),
          subtitle: Text(songs[index].artist),
          onTap: () async {
            currentIndex = index;
            await context.read<PlayerCubit>().setSong(songs[index].uri);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => PlayerWindow()));
          },
        ),
      ),
    );
  }
}
