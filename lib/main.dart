import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_jokenpo_app/jokenpo_icons.dart';

void main() {
  runApp(const JokenpoApp());
}

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

class JokenpoHome extends StatefulWidget {
  const JokenpoHome({super.key});

  @override
  State<JokenpoHome> createState() => _JokenpoHomeState();
}

class _JokenpoHomeState extends State<JokenpoHome>
    with SingleTickerProviderStateMixin {
  String _message = 'Faça sua jogada!';
  IconData? _pcChoiceImage;
  IconData? _userChoiceImage;
  bool _showChoice = false;
  bool _isAnimating = false;
  int _playCount = 0;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..stop();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _randomChoice() {
    List<String> choices = ['rock', 'paper', 'scissors'];
    int rdnNum = Random().nextInt(3);
    return choices[rdnNum];
  }

  String _getResultMessage(String userChoice, String pcChoice) {
    if (userChoice == pcChoice) {
      return "Sem graça, deu empate!";
    }
    if ((userChoice == 'rock' && pcChoice == 'scissors') ||
        (userChoice == 'scissors' && pcChoice == 'paper') ||
        (userChoice == 'paper' && pcChoice == 'rock')) {
      return "Ah não, voce ganhou! :(";
    } else {
      return "Uuhl, voce perdeu! XD";
    }
  }

  IconData _getIcon(String choice) {
    final Map<String, IconData> images = {
      'rock': JokenpoIcons.rock,
      'paper': JokenpoIcons.paper,
      'scissors': JokenpoIcons.scissors,
    };
    return images[choice]!;
  }

  void _userChoice(String userChoice) {
    String pcChoice = _randomChoice();

    setState(() {
      _showChoice = false;
      _message = 'Estou escolhendo...';
      _playCount++;
      _userChoiceImage = _getIcon(userChoice);

      if (_playCount > 1) {
        _controller.repeat();
        _isAnimating = true;
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _pcChoiceImage = _getIcon(pcChoice);
        _showChoice = true;
        _isAnimating = false;
        _controller.repeat();
        _message = _getResultMessage(userChoice, pcChoice);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Jo ken po',
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _showChoice && _pcChoiceImage != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Icon(
                            _pcChoiceImage,
                            size: 80,
                          ),
                          const Text('Minha escolha')
                        ],
                      ),
                      const Text('X'),
                      Column(
                        children: [
                          Icon(
                            _userChoiceImage!,
                            size: 80,
                          ),
                          const Text('Sua escolha')
                        ],
                      )
                    ],
                  )
                : RotationTransition(
                    key: const ValueKey('image'),
                    turns: _controller,
                    child: Image.asset(
                      'assets/images/rock-paper-scissors.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
          ),
          const SizedBox(height: 60),
          Text(
            _message,
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
                    onTap: () => _userChoice('rock'),
                    child: const Icon(
                      JokenpoIcons.rock,
                      size: 50,
                    ),
                  ),
                  const Text('Rock')
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () => _userChoice('paper'),
                    child: const Icon(
                      JokenpoIcons.paper,
                      size: 50,
                    ),
                  ),
                  const Text('Paper')
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () => _userChoice('scissors'),
                    child: const Icon(
                      JokenpoIcons.scissors,
                      size: 50,
                    ),
                  ),
                  const Text('Scissors')
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
