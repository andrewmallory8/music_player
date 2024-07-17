import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:musicplayer/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(
        songName: "So Good",
        artistName: "Neo",
        albumArtImagePath: "assets/images/album_artwork_1.png",
        audioPath: "audio/So Good.mp3"),
    Song(
        songName: "Couldn't Sleep",
        artistName: "Nelly",
        albumArtImagePath: "assets/images/album_artwork_2.png",
        audioPath: "audio/Couldn't Sleep.mp3"),
    Song(
        songName: "One Day",
        artistName: "Rise",
        albumArtImagePath: "assets/images/album_artwork_3.png",
        audioPath: "audio/One Day.mp3"),
    Song(
        songName: "Sake Bomb",
        artistName: "Jade",
        albumArtImagePath: "assets/images/album_artwork_4.jpg",
        audioPath: "audio/Sake Bomb.mp3"),
     Song(
        songName: "Devil is a lie",
        artistName: "Tommy",
        albumArtImagePath: "assets/images/album_artwork_5.png",
        audioPath: "audio/Devil Lie.mp3"),
      Song(
        songName: "Hummingbird",
        artistName: "James",
        albumArtImagePath: "assets/images/spiderman.jpg",
        audioPath: "audio/Humming Bird.mp3"),
      Song(
        songName: "Cool Down",
        artistName: "Digital Mount",
        albumArtImagePath: "assets/images/album_artwork_10.jpg",
        audioPath: "audio/Cool Down.mp3"),
      Song(
        songName: "Cold",
        artistName: "Taz Network",
        albumArtImagePath: "assets/images/album_artwork_9.jpg",
        audioPath: "audio/Cold.mp3"),
      Song(
        songName: "Mona Lisa",
        artistName: "Dominic Fike",
        albumArtImagePath: "assets/images/album_artwork_7.jpg",
        audioPath: "audio/Mona Lisa.mp3"),
      Song(
        songName: "Pirates on a Boat",
        artistName: "Yuno",
        albumArtImagePath: "assets/images/album_artwork_8.jpg",
        audioPath: "audio/Pirates on a Boat.mp3"),
      Song(
        songName: "Killa Killa",
        artistName: "Ksi, Aiyana-Lee",
        albumArtImagePath: "assets/images/ksi2.png",
        audioPath: "audio/Killa Killa.mp3"),
  ];

  int? _currentSongIndex;

  // ----------------------- AUDIO PLAYER ---------------------------

  // audioplayer
  final AudioPlayer _audioPlayer = AudioPlayer();

  //durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  //repeat and shuffle
  bool _repeat = false;
  bool _shuffle = false;

  //toggles
  void toggleRepeat() {
    _repeat = !_repeat;
    notifyListeners();
  }

  void toggleShuffle() {
    _shuffle = !_shuffle;
    notifyListeners();
  }

  //constructor
  PlaylistProvider() {
    listenToDuration();
  }

  //initially not playing
  bool _isPlaying = false;

  // play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop(); // stop current song
    await _audioPlayer.play(AssetSource(path)); // play selected song
    _isPlaying = true;
    notifyListeners();
  }

  //pause
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  //resume
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  //pause or resume based on the state of the player
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  //seek to specific position
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  //play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (isRepeatOn) {
        int temp = _currentSongIndex!;
        currentSongIndex = null;
        currentSongIndex = temp;
        // seek(Duration.zero);
      } else if (isShuffleOn) {
        int newIndex = _currentSongIndex!;
        while (newIndex == _currentSongIndex) {
          newIndex = Random().nextInt(_playlist.length);
        }
        currentSongIndex = newIndex;
      } else {
        // go to next song if it is not the last song
        if (_currentSongIndex! < _playlist.length - 1) {
          currentSongIndex = _currentSongIndex! + 1;
        } else {
          //if it's the last song return to the first
          currentSongIndex = 0;
        }
      }
    }
  }

  //play previous
  void playPreviousSong() {
    // if more than 2 seconds passed, reset the selected song
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    }
    // if its within 2 seconds go to previous song
    else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        // if it is the first song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  //listen to duration

  void listenToDuration() {
    //listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    //listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    //listen for when the song has finished
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  //dispose audioplayer

  //------------------------------ Getters ---------------------------

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  bool get isRepeatOn => _repeat;
  bool get isShuffleOn => _shuffle;

  //------------------------------ Setters ---------------------------
  set currentSongIndex(int? newIndex) {
    if (_currentSongIndex == newIndex) return;
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play();
    }

    notifyListeners();
  }
}
