import 'package:fingram/button/rounded_button.dart';
import 'package:fingram/games/game_high_score_table.dart';
import 'package:fingram/games/game_screen.dart';
import 'package:fingram/lessons/lessons_page.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  final int highScore = 250;

  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Время работать"),
      ),
      body: Container(
        color: const Color.fromARGB(255, 37, 107, 139),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Время работать',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Ловите падающие деньги корзинкой, чтобы набрать очки. Старайтесь не упускать валюту, так как вы будете уставать. Как только у вас закончится выносливость, игра закончится. Удачи! \n\n 100 очков - 1 монетка :)',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            RoundedButton(
                colour: Colors.blueAccent,
                title: 'Начать игру',
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GameScreen()));
                }),
            RoundedButton(
                colour: Colors.blueAccent,
                title: 'Таблица лидеров',
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GameHighScoreTable()));
                }),
            RoundedButton(
                colour: Colors.blueAccent,
                title: 'Вернуться на главную',
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LessonsPage()));
                }),
          ],
        ),
      ),
    );
  }
}
