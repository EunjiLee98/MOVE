import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class PlayPauseAnimation extends StatefulWidget {
  const PlayPauseAnimation({Key? key}) : super(key: key);

  @override
  _PlayPauseAnimationState createState() => _PlayPauseAnimationState();
}

class _PlayPauseAnimationState extends State<PlayPauseAnimation> {
  /// Controller for playback
  late RiveAnimationController _controller;

  /// Is the animation currently playing?
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = OneShotAnimation(
      'jumpingjack',
      autoplay: false,
      onStop: () => setState(() => _isPlaying = false),
      onStart: () => setState(() => _isPlaying = true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: RiveAnimation.asset(
          'assets/rive/character.riv',
          animations: ['default'], // Default Animation
          controllers: [_controller],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Animation 'Close Arm' once
          FloatingActionButton(
            // disable the button while playing the animation
            onPressed: () => _isPlaying ? null : _controller.isActive = true,
            tooltip: 'Jumping Jack',
            child: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}