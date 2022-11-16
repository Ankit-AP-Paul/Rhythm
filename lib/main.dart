import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import './pages/onboarding_screen.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // audioPlayer is declared in main.dart ...............................//
    // reason: Only one Instance of AudioPlayer is needed. So It must be declared in main.dart
    //        and passed through Constructors................//
    // Else: Multiple Instances of a player may get created and multiple files may start playing Simultaniously//

    final AudioPlayer audioPlayer = AudioPlayer();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
        splash: Image.asset('images/app_icon.jpg'),
        duration: 3000,
        splashTransition: SplashTransition.rotationTransition,
        backgroundColor: Colors.white,
        nextScreen: OnboardingPage(
          audioPlayer: audioPlayer,
        ),
      ),
    );
  }
}
