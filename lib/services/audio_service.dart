import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static AudioPlayer? _player;

  static Future<void> _play(String fileName) async {
    try {
      _player?.dispose();
      _player = AudioPlayer();
      await _player!.setVolume(1.0);
      await _player!.play(AssetSource('audio/$fileName'));
    } catch (e) {
      print('Audio error: $e');
    }
  }

  static Future<void> playGoodChoice() async {
    await _play('good_choice.mp3');
  }

  static Future<void> playThankYou() async {
    await _play('thank_you.mp3');
  }
}