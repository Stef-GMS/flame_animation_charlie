import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' hide Image;

void main() {
  print('1. load the GameWidget with runApp()');
  runApp(GameWidget(game: ChickenGame()));
}

class ChickenGame extends FlameGame {
  double chickenScaleFactor = 3.0;

  late SpriteAnimationComponent chicken;
  late SpriteComponent background;
  late final JoystickComponent joystick;
  bool chickenFlipped = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    Flame.device.setLandscape();

    print('2. load the assets for the game');

    background = SpriteComponent()
      ..sprite = await loadSprite('background.png')
      ..size = size;
    add(background);

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

    final joystickKnobPaint = BasicPalette.blue.withAlpha(200).paint();
    final joystickBackgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(
        radius: 30,
        paint: joystickKnobPaint,
      ),
      background: CircleComponent(
        radius: 60,
        paint: joystickBackgroundPaint,
      ),
      margin: const EdgeInsets.only(
        left: 40,
        bottom: 40,
      ),
    );

    add(joystick);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // the following is just a demonstration
    // chicken.y += 1;
    // chicken.x -= 1;
    chicken.position.add(joystick.relativeDelta * 300 * dt);

    if (joystick.relativeDelta[0] < 0 && chickenFlipped) {
      chickenFlipped = false;
      chicken.flipHorizontallyAroundCenter();
    }
    if (joystick.relativeDelta[0] > 0 && !chickenFlipped) {
      chickenFlipped = true;
      chicken.flipHorizontallyAroundCenter();
    }
    //print(joystick.relativeDelta);
  }
}
