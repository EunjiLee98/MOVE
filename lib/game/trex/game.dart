import 'dart:ui' as ui;
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:move/game/trex/game_over/config.dart';
import 'package:move/game/trex/horizon/horizon.dart';
import 'package:move/game/trex/game_config.dart';
import 'package:move/game/trex/game_over/game_over.dart';
import 'package:move/game/trex/obstacle/obstacle.dart';
import 'package:move/game/trex/t_rex/t_rex.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'collision/collision_utils.dart';
import 'horizon/clouds.dart';
import 'package:just_audio/just_audio.dart';

class Bg extends Component with HasGameRef {
  Vector2 size = Vector2.zero();

  late final ui.Paint _paint = ui.Paint()..color = const ui.Color.fromARGB(250, 255, 255, 255); //background color

  @override
  void render(ui.Canvas c) {
    final rect = ui.Rect.fromLTWH(0, 0, size.x, size.y);
    c.drawRect(rect, _paint);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    size = gameSize;
  }
}

enum TRexGameStatus { playing, waiting, gameOver }

class TRexGame extends BaseGame with TapDetector {
  TRexGame( {
    required this.spriteImage,
  }) : super();

  late final config = GameConfig();

  @override
  ui.Color backgroundColor() => const ui.Color.fromARGB(250, 255, 255, 255);

  final ui.Image spriteImage;
  late AudioPlayer player;
  //var scoreList = new List.filled(50, 0, growable: true);

  /// children
  late final tRex = TRex();
  late final horizon = Horizon();
  late final gameOverPanel = GameOverPanel(spriteImage, GameOverConfig());
  late final cloud = Cloud();
  SpriteComponent sun = SpriteComponent();
  SpriteComponent back = SpriteComponent();

  @override
  Future<void> onLoad() async {
    player = AudioPlayer();
    add(Bg());
    back
      ..sprite = await loadSprite('dino_bg.png')
      ..size = Vector2(650, 375)
      ..x = 0
      ..y = 0;
    add(back);
    add(cloud);
    add(horizon);
    add(tRex);
    add(gameOverPanel);
    sun
      ..sprite = await loadSprite('sun.png')
      ..size = Vector2(40.0, 30.0)
      ..x = 475
      ..y = 65;
    add(sun);
  }

  // state
  late TRexGameStatus status = TRexGameStatus.waiting;
  late double currentSpeed = 0.0;
  late double timePlaying = 0.0;
  late int score = 0;

  bool get playing => status == TRexGameStatus.playing;
  bool get gameOver => status == TRexGameStatus.gameOver;

  var result;
  late int temp = 0;

  //bluetooth services
  final StreamController<int> _streamController = StreamController<int>();
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

  void dispose(){
    _streamController.close();
    player.dispose();
  }

  Future<void> soundPlay() async {
    await player.setAsset('assets/audio/jump.mp3');
    player.play();
  }

  void onAction(int gestureNum) {
    // if (gameOver && gesture_num == 1) {
    //   //insertScore();
    //   restart();
    // }

    if((gestureNum == 1 || gestureNum == 2 || gestureNum == 3 || gestureNum == 4) && !gameOver) {
      soundPlay();
      this.score += 1;
      tRex.startJump(currentSpeed);
    }
  }

  // void insertScore() {
  //   scoreList.add(this.score);
  //   print('score : ');
  //   print(this.score);
  //   print('score list : ');
  //   print(scoreList);
  // }

  int returnScore() {
    return this.score;
  }

  int getFinalScore() {
    if (gameOver)
      return this.score;
    else
      return -1;
  }

  void startGame() {
    tRex.status = TRexStatus.running;
    status = TRexGameStatus.playing;
    tRex.hasPlayedIntro = true;
    currentSpeed = config.speed;
  }

  void doGameOver() {
    gameOverPanel.visible = true;
    status = TRexGameStatus.gameOver;
    tRex.status = TRexStatus.crashed;
    currentSpeed = 0.0;
    this.score = 0;
  }

  void restart() {
    status = TRexGameStatus.playing;
    tRex.reset();
    horizon.reset();
    currentSpeed = config.speed;
    gameOverPanel.visible = false;
    timePlaying = 0.0;
    this.score = 0;
  }


  @override
  void update(double dt) {
    super.update(dt);

    if (gameOver) {
      return;
    }

    if (tRex.playingIntro && tRex.x >= tRex.config.startXPos) {
      startGame();
    } else if (tRex.playingIntro) {}

    if (playing) {
      timePlaying += dt;

      final obstacles = horizon.horizonLine.obstacleManager.children;
      final hasCollision = obstacles.isNotEmpty &&
          checkForCollision(obstacles.first as Obstacle, tRex);
      if (!hasCollision) {
        if (currentSpeed < config.maxSpeed) {
          currentSpeed += config.acceleration;
        }
      } else {
        doGameOver();
      }
    }
  }

}