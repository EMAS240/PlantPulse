import 'package:audioplayers/audioplayers.dart';

class PlayerSounds {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> pS(int numberSound) async {
    String audioPath = '';
    if (numberSound == 1) {
      audioPath = 'app_alert_tone_016.mp3';
    } else if (numberSound == 2) {
      audioPath = 'app_alert_tone_011.mp3';
    } else if (numberSound == 3) {
      audioPath = 'app_alert_tone_012.mp3';
    } else if (numberSound == 4) {
      audioPath = 'app_alert_tone_010.mp3';
    } else if (numberSound == 5) {
      audioPath = 'error-126627.mp3';
    } else if (numberSound == 6) {
      audioPath = 'm.wav';
    } else if (numberSound == 7) {
      audioPath = 'b.mp3';
    } else if (numberSound == 8) {
      audioPath = 'p.mp3';
    }

    await _audioPlayer.play(AssetSource(audioPath));
  }
}
