import 'package:animated_music_indicator/animated_music_indicator.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/components/main_drawer.dart';
import 'package:musicplayer/models/playlist_provider.dart';
import 'package:musicplayer/models/song.dart';
import 'package:musicplayer/pages/song_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final dynamic playlistProvider;

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SongPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text("P L A Y L I S T")),
      drawer: const MainDrawer(),
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) {
          final List<Song> playlist = value.playlist;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: playlist.length,
                  itemBuilder: (context, index) {
                    final Song song = playlist[index];
                    return ListTile(
                      title: Text(
                        song.songName,
                        style: TextStyle(
                          color: (value.currentSongIndex == index)
                              ? Colors.green
                              : null,
                        ),
                      ),
                      subtitle: Text(song.artistName),
                      leading: Image.asset(song.albumArtImagePath),
                      trailing: (value.currentSongIndex == index)
                          ? AnimatedMusicIndicator(
                              animate: value.isPlaying,
                              color: Colors.green,
                            )
                          : null,
                      onTap: () => goToSong(index),
                    );
                  },
                ),
              ),
              if (value.currentSongIndex != null)
                GestureDetector(
                  child: _buildCurrentlyPlayingWidget(value),
                  onTap: () => goToSong(value.currentSongIndex!),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCurrentlyPlayingWidget(PlaylistProvider value) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Album Image
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: AssetImage(
                  value.playlist[value.currentSongIndex!]
                      .albumArtImagePath, // Default image if no song is playing
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value.playlist[value.currentSongIndex!].songName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  value.playlist[value.currentSongIndex!].artistName,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: value.pauseOrResume,
            child: Icon(value.isPlaying ? Icons.pause : Icons.play_arrow,
                size: 32.0),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
