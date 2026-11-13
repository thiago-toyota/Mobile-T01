
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

final musicProvider =
    NotifierProvider<MusicController, bool>(MusicController.new);

class MusicController extends Notifier<bool> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  bool build() {
    return false;
  }

  Future<void> toggleMusic() async {
    if (state) {
      await _audioPlayer.pause();
      state = false;
    } else {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(0.5);

      await _audioPlayer.play(
        AssetSource('audio/background.mp3'),
      );

      state = true;
    }
  }

  Future<void> stopMusic() async {
    await _audioPlayer.stop();
    state = false;
  }
}
