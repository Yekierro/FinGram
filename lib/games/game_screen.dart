import 'dart:async';
import 'dart:math';
import 'package:fingram/button/rounded_button.dart';
import 'package:fingram/games/game.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double basketX = 0;
  double basketWidth = 50;
  double basketY = 400;
  double deathZoneY = 450;
  int score = 0;
  int lives = 3;
  int highScore = 0;
  List<Offset> fruits = [];
  Random random = Random();
  late Timer fruitTimer;
  late Timer dropTimer;
  String basketImage = 'assets/game/basket.png';
  String selectedBasketImage = 'assets/game/basket.png';

  @override
  void initState() {
    super.initState();
    loadHighScore();
    loadSelectedBasket();
    fruitTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      addFruit();
    });
    startFruitDrop();
  }

  void loadSelectedBasket() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference selectedBasketRef =
        FirebaseDatabase.instance.ref('users/$userId/selectedBasket');
    DataSnapshot snapshot = await selectedBasketRef.get();
    if (snapshot.exists && snapshot.value != null) {
      setState(() {
        selectedBasketImage = snapshot.value.toString();
      });
    }
  }

  void addFruit() {
    double x =
        random.nextDouble() * (MediaQuery.of(context).size.width - basketWidth);
    setState(() {
      fruits.add(Offset(x, 0));
    });
  }

  void startFruitDrop() {
    dropTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted || lives <= 0) {
        timer.cancel();
      } else {
        updateFruitPosition();
      }
    });
  }

  void updateFruitPosition() {
    List<Offset> tempFruits = [];
    bool shouldUpdateState = false;

    for (var fruit in fruits) {
      double newY = fruit.dy + 5;
      if (newY > deathZoneY) {
        lives--;
        shouldUpdateState = true;
        if (lives == 0) {
          showGameOverDialog();
          fruitTimer.cancel();
          dropTimer.cancel();
          return;
        }
      } else if (newY + 170 >= basketY &&
          newY <= basketY + 170 &&
          fruit.dx >= basketX &&
          fruit.dx <= basketX + basketWidth) {
        score += 10;
        if (score % 100 == 0) {
          incrementCoins(1);
        }
        highScore = max(score, highScore);
        shouldUpdateState = true;
      } else {
        tempFruits.add(Offset(fruit.dx, newY));
        shouldUpdateState = true;
      }
    }

    if (shouldUpdateState) {
      setState(() {
        fruits = tempFruits;
      });
    }
  }

  void moveBasket(double dx) {
    setState(() {
      basketX = dx.clamp(0, MediaQuery.of(context).size.width - basketWidth);
    });
  }

  void showGameOverDialog() {
    updateHighScore();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Рабочий день закончился!"),
          content: Text("Ваш результат: $score"),
          actions: <Widget>[
            RoundedButton(
                colour: Colors.blueAccent,
                title: 'Назад',
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainMenu()));
                })
          ],
        );
      },
    );
  }

  void updateHighScore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final highScoreRef =
        FirebaseDatabase.instance.ref('users/$uid/games/work/highScore');
    final snapshot = await highScoreRef.get();

    if (snapshot.exists && snapshot.value != null) {
      int currentHighScore = int.parse(snapshot.value.toString());
      if (score > currentHighScore) {
        highScoreRef.set(score);
      }
    } else {
      highScoreRef.set(score);
    }
  }

  void incrementCoins(int coinsToAdd) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference coinsRef =
        FirebaseDatabase.instance.ref('users/$userId/coins');
    coinsRef.get().then((snapshot) {
      int currentCoins = snapshot.exists && snapshot.value != null
          ? int.parse(snapshot.value.toString())
          : 0;
      coinsRef.set(currentCoins + coinsToAdd);
    });
  }

  void loadHighScore() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference highScoreRef =
        FirebaseDatabase.instance.ref('users/$userId/games/work/highScore');
    DataSnapshot snapshot = await highScoreRef.get();

    if (snapshot.exists && snapshot.value != null) {
      int onlineHighScore = int.parse(snapshot.value.toString());
      setState(() {
        highScore = max(highScore, onlineHighScore);
      });
    }
  }

  @override
  void dispose() {
    fruitTimer.cancel();
    dropTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Время работать"),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          moveBasket(details.globalPosition.dx - basketWidth / 2);
        },
        child: Stack(
          children: buildGameObjects(),
        ),
      ),
    );
  }

  List<Widget> buildGameObjects() {
    List<Widget> widgets = [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/game/background.jpg'),
            fit: BoxFit.fill,
          ),
        ),
      ),
      Positioned(
        left: basketX,
        bottom: basketY,
        child: Container(
          width: basketWidth,
          height: 50,
          child: Image.asset(basketImage),
        ),
      ),
      Positioned(
        top: deathZoneY - 10,
        left: 0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 10,
          color: Colors.transparent,
        ),
      ),
      Positioned(
        top: 0,
        right: 10,
        child: Text('Результат: $score',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      Positioned(
        top: 0,
        left: 10,
        child: Text('Выносливость: $lives',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      Positioned(
        top: 50,
        right: 10,
        child: Text('Рекорд: $highScore', style: const TextStyle(fontSize: 20)),
      ),
      ...fruits
          .map((fruit) => Positioned(
                left: fruit.dx,
                top: fruit.dy,
                child: Container(
                  width: 50,
                  height: 50,
                  child: Image.asset('assets/game/apple.png'),
                ),
              ))
          .toList(),
    ];

    return widgets;
  }
}
