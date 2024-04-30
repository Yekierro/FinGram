import 'package:fingram/games/users_score.dart';
import 'package:flutter/material.dart';

class UserScoreCard extends StatelessWidget {
  final UserScore userScore;
  final int index;

  const UserScoreCard(
      {super.key, required this.userScore, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text("${index + 1}."),
        title: Text('${userScore.name}, ${userScore.age}'),
        subtitle: Text('High Score: ${userScore.highScore}'),
      ),
    );
  }
}
