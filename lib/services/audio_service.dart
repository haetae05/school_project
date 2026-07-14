import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../core/models/ripple_state.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  
  // Listen to state changes to trigger cross-fade
  ref.listen<RippleState>(rippleStateProvider, (previous, next) {
    if (previous != next) {
      service.crossFadeToState(next);
    }
  });
  
  // Ensure we dispose audio players when provider is destroyed
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

class AudioService {
  final AudioPlayer _playerA = AudioPlayer();
  final AudioPlayer _playerB = AudioPlayer();
  
  bool _isPlayingA = true;
  
  // Placeholder network URLs for ambient soundscapes
  final Map<RippleState, String> _audioUrls = {
    RippleState.calm: 'https://cdn.freesound.org/previews/413/413327_6556108-lq.mp3', // Gentle stream
    RippleState.walking: 'https://cdn.freesound.org/previews/174/174488_2400936-lq.mp3', // Walking on leaves
    RippleState.busy: 'https://cdn.freesound.org/previews/209/209581_166070-lq.mp3', // Fast river
    RippleState.danger: 'https://cdn.freesound.org/previews/352/352514_4019029-lq.mp3', // Warning siren/storm
  };

  Future<void> init() async {
    // Start with calm state
    await _playerA.setUrl(_audioUrls[RippleState.calm]!);
    await _playerA.setVolume(1.0);
    await _playerA.setLoopMode(LoopMode.one);
    _playerA.play();
    
    await _playerB.setVolume(0.0);
    await _playerB.setLoopMode(LoopMode.one);
  }

  Future<void> crossFadeToState(RippleState state) async {
    print('[AudioService] Cross-fading to \$state');
    final nextUrl = _audioUrls[state]!;
    
    final activePlayer = _isPlayingA ? _playerA : _playerB;
    final fadingInPlayer = _isPlayingA ? _playerB : _playerA;

    // Load new audio and start playing silently
    await fadingInPlayer.setUrl(nextUrl);
    fadingInPlayer.play();

    // Cross-fade over 2 seconds (20 steps of 100ms)
    for (int i = 1; i <= 20; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      final volume = i / 20.0;
      await fadingInPlayer.setVolume(volume);
      await activePlayer.setVolume(1.0 - volume);
    }

    // Stop old player completely
    await activePlayer.stop();
    _isPlayingA = !_isPlayingA; // Swap active player
  }

  void dispose() {
    _playerA.dispose();
    _playerB.dispose();
  }
}
