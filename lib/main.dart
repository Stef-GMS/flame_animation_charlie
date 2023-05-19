import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' hide Image;

void main() {
  print('setup game orientation');
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  print('1. load the GameWidget with runApp()');
  runApp(GameWidget(game: ChickenGame()));
}

class ChickenGame extends FlameGame {
  double chickenScaleFactor = 3.0;

  late SpriteAnimationComponent chicken;
  late SpriteComponent background;
  late final JoystickComponent joystick;
  bool chickenFlipped = false;
  final world = World();
  late final CameraComponent cameraComponent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    print('2. load the assets for the game');

    print('3. load map');
    var homeMap = await TiledComponent.load('level_1.tmx', Vector2(16, 16));
    print('4. add map to game');
    //add(homeMap);
    double mapHeight = 16.0 * homeMap.tileMap.map.height;
    double mapWidth = 16.0 * homeMap.tileMap.map.width;

    cameraComponent = CameraComponent.withFixedResolution(
      world: world,
      width: mapWidth,
      height: mapHeight,
    );
    addAll([world, cameraComponent]);

    cameraComponent.viewfinder.anchor = Anchor.topLeft;

    world.add(homeMap); // This replaces adding directly to the game

    print('5. load charlie the chicken');
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
    //add(chicken);
    world.add(chicken);

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

    bool moveLeft = joystick.relativeDelta[0] < 0;
    bool moveRight = joystick.relativeDelta[0] > 0;
    bool moveUp = joystick.relativeDelta[1] < 0;
    bool moveDown = joystick.relativeDelta[1] > 0;

    double chickenVectorX = (joystick.relativeDelta * 300 * dt)[0];
    double chickenVectorY = (joystick.relativeDelta * 300 * dt)[1];

    // chicken is moving horizontally and prevents chicken from going off screen horizontally
    if ((moveLeft && chicken.x > 0) || (moveRight && chicken.x < size[0])) {
      chicken.position.add(Vector2(chickenVectorX, 0));
    }

    // chicken is moving vertically and prevents chicken from going off screen vertically
    if ((moveUp && chicken.y > 0) ||
        (moveDown && chicken.y < size[1] - chicken.height)) {
      chicken.position.add(Vector2(0, chickenVectorY));
    }
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
