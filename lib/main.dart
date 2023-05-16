import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' hide Image;

void main() {
  print('1. load the GameWidget with runApp()');
  runApp(GameWidget(game: ChickenGame()));
}

class ChickenGame extends FlameGame {
  double chickenScaleFactor = 3.0;

  late SpriteAnimationComponent chicken;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    print('2. load the assets for the game');

    Image chickenImage = await images.load('chicken.png');

    var chickenAnimation = SpriteAnimation.fromFrameData(
      chickenImage,
      SpriteAnimationData.sequenced(
        amount: 14, //number of frames
        stepTime: 0.1, //nbr of seconds between frames
        textureSize: Vector2(32, 34),
      ),
    );

    chicken = SpriteAnimationComponent()
      ..animation = chickenAnimation
      ..size = Vector2(32, 34) * chickenScaleFactor
      ..position = Vector2(200, 100);

    // add sprite to UI
    add(chicken);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // the following is just a demonstration
    // chicken.y += 1;
    // chicken.x -= 1;
  }
}
