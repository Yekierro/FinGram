import 'package:fingram/games/users_score.dart';
import 'package:fingram/games/users_score_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GameHighScoreTable extends StatefulWidget {
  const GameHighScoreTable({super.key});

  @override
  _GameHighScoreTableState createState() => _GameHighScoreTableState();
}

class _GameHighScoreTableState extends State<GameHighScoreTable> {
  List<UserScore> userScores = [];

  @override
  void initState() {
    super.initState();
    loadHighScores();
  }

  void loadHighScores() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('users');
    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      List<UserScore> loadedScores = [];
      snapshot.children.forEach((userSnapshot) {
        if (userSnapshot.child('games/work/highScore').exists) {
          loadedScores.add(UserScore.fromSnapshot(userSnapshot));
        }
      });

      loadedScores.sort((a, b) => b.highScore.compareTo(a.highScore));

      setState(() {
        userScores = loadedScores;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Scores'),
      ),
      body: ListView.builder(
        itemCount: userScores.length,
        itemBuilder: (context, index) {
          return UserScoreCard(userScore: userScores[index], index: index);
        },
      ),
    );
  }
}
