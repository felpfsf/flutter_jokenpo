import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_jokenpo_app/jokenpo_icons.dart';
import 'package:provider/provider.dart';

// Main
void main() {
  runApp(const JokenpoApp());
}

// APP
class JokenpoApp extends StatelessWidget {
  const JokenpoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jokenpo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const JokenpoHome(),
    );
  }
}

// Home

class JokenpoHome extends StatefulWidget {
  const JokenpoHome({super.key});

  @override
  State<JokenpoHome> createState() => _JokenpoHomeState();
}

class _JokenpoHomeState extends State<JokenpoHome>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JokenpoController(tickerProvider: this),
      child: Scaffold(
        body: Consumer<JokenpoController>(
          builder: (context, controller, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Jo Ken po',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child:
                      controller.showChoice && controller.pcChoiceImage != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      controller.pcChoiceImage,
                                      size: 80,
                                    ),
                                    const Text('Minha escolha'),
                                  ],
                                ),
                                const Text('X'),
                                Column(
                                  children: [
                                    Icon(
                                      controller.userChoiceImage,
                                      size: 80,
                                    ),
                                    const Text('Sua escolha'),
                                  ],
                                ),
                              ],
                            )
                          : RotationTransition(
                              turns: controller.controller,
                              child: Image.asset(
                                'assets/images/rock-paper-scissors.png',
                                width: 100,
                                height: 100,
                              ),
                            ),
                ),
                const SizedBox(height: 60),
                Text(
                  controller.message,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () => controller.userChoice('rock'),
                          child: const Icon(
                            JokenpoIcons.rock,
                            size: 50,
                          ),
                        ),
                        const Text('Pedra'),
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () => controller.userChoice('paper'),
                          child: const Icon(
                            JokenpoIcons.paper,
                            size: 50,
                          ),
                        ),
                        const Text('Papel'),
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () => controller.userChoice('scissors'),
                          child: const Icon(
                            JokenpoIcons.scissors,
                            size: 50,
                          ),
                        ),
                        const Text('Tesoura'),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class JokenpoController extends ChangeNotifier {
  String _message = 'Faça sua jogada!';
  IconData? _pcChoiceImage;
  IconData? _userChoiceImage;
  bool _showChoice = false;
  bool _isAnimating = false;
  int _playCount = 0;

  late AnimationController _controller;

  String get message => _message;
  IconData? get pcChoiceImage => _pcChoiceImage;
  IconData? get userChoiceImage => _userChoiceImage;
  bool get showChoice => _showChoice;
  bool get isAnimating => _isAnimating;
  AnimationController get controller => _controller;

  JokenpoController({required TickerProvider tickerProvider}) {
    _controller = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 800),
    )..stop();
  }

  void disposeController() {
    _controller.dispose();
  }

  void userChoice(String userChoice) {
    List<String> choices = ['rock', 'paper', 'scissors'];
    int randomNum = Random().nextInt(3);
    String pcChoice = choices[randomNum];

    final Map<String, IconData> images = {
      'rock': JokenpoIcons.rock,
      'paper': JokenpoIcons.paper,
      'scissors': JokenpoIcons.scissors,
    };

    _showChoice = false;
    _message = 'Estou escolhendo...';
    _playCount++;
    _userChoiceImage = images[userChoice];
    _controller.repeat();

    if (_playCount > 1) {
      _isAnimating = true;
      notifyListeners();
    }

    Future.delayed(const Duration(milliseconds: 1000), () {
      _pcChoiceImage = images[pcChoice];
      _showChoice = true;
      _isAnimating = false;
      _controller.stop();
      notifyListeners();

      if ((userChoice == 'rock' && pcChoice == 'scissors') ||
          (userChoice == 'scissors' && pcChoice == 'paper') ||
          (userChoice == 'paper' && pcChoice == 'rock')) {
        _message = "Ah não, você ganhou! :(";
      } else if (userChoice == pcChoice) {
        _message = "Sem graça, deu empate!";
      } else {
        _message = "Uuhl, você perdeu! XD";
      }

      notifyListeners();
    });
  }
}
