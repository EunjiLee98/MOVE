import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class PlayPauseAnimation extends StatefulWidget {
  const PlayPauseAnimation({Key? key}) : super(key: key);

  @override
  _PlayPauseAnimationState createState() => _PlayPauseAnimationState();
}

class _PlayPauseAnimationState extends State<PlayPauseAnimation> {
  /// Controller for playback
  late RiveAnimationController close_controller;

  late RiveAnimationController open_controller;

  /// Is the animation currently playing?
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    close_controller = OneShotAnimation(
      '팔오므리기',
      autoplay: false,
      onStop: () => setState(() => _isPlaying = false),
      onStart: () => setState(() => _isPlaying = true),
    );
    open_controller = OneShotAnimation(
      '팔벌리기',
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
          'assets/rive/jumpingjack.riv',
          animations: ['기본'], // Default Animation
          controllers: [close_controller, open_controller],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Animation 'Close Arm' once
          FloatingActionButton(
            // disable the button while playing the animation
            onPressed: () => _isPlaying ? null : close_controller.isActive = true,
            tooltip: 'Close Arm',
            child: const Icon(Icons.close),
          ),
          SizedBox(width: 20,),
          // Animation 'Open Arm' once
          FloatingActionButton(
            // disable the button while playing the animation
            onPressed: () => _isPlaying ? null : open_controller.isActive = true,
            tooltip: 'Open Arm',
            child: const Icon(Icons.open_in_full),
          ),
        ],
      ),
    );
  }
}