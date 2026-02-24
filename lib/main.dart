import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/map_picker_page.dart';
import 'package:instagram_clone/pages/map_sample.dart';
import 'package:instagram_clone/pages/splash_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}






//
//
//
// import 'dart:math';
// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(
//     GameWidget(
//       game: TapGame(),
//     ),
//   );
// }
//
// ///
// /// MAIN GAME
// ///
// class TapGame extends FlameGame {
//   double spawnTimer = 0;
//   late TextComponent scoreText;
//
//   int score = 0;
//
//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();
//
//     // Score UI
//     scoreText = TextComponent(
//       text: 'Score: 0',
//       position: Vector2(10, 10),
//       anchor: Anchor.topLeft,
//       textRenderer: TextPaint(
//         style: const TextStyle(
//           fontSize: 24,
//           color: Colors.white,
//         ),
//       ),
//     );
//
//     add(scoreText);
//   }
//
//   @override
//   void update(double dt) {
//     super.update(dt);
//
//     spawnTimer += dt;
//
//     // Spawn ball every second
//     if (spawnTimer > 1) {
//       spawnTimer = 0;
//
//       final x = Random().nextDouble() * size.x;
//
//       add(
//         FallingBall(
//           position: Vector2(x, -20),
//         ),
//       );
//     }
//   }
//
//   void increaseScore() {
//     score++;
//     scoreText.text = 'Score: $score';
//   }
// }
//
// ///
// /// FALLING BALL COMPONENT
// ///
// class FallingBall extends CircleComponent
//     with TapCallbacks, HasGameRef<TapGame> {
//   FallingBall({required Vector2 position})
//       : super(
//     position: position,
//     radius: 20,
//     paint: Paint()..color = Colors.red,
//   );
//
//   @override
//   void update(double dt) {
//     super.update(dt);
//
//     // Fall down
//     position.y += 150 * dt;
//
//     // Remove if off screen
//     if (position.y > gameRef.size.y + 50) {
//       removeFromParent();
//     }
//   }
//
//   @override
//   void onTapDown(TapDownEvent event) {
//     gameRef.increaseScore();
//     removeFromParent();
//   }
// }
