import 'package:firebase_database/firebase_database.dart';

class UserScore {
  final String name;
  final String age;
  final int highScore;

  UserScore({required this.name, required this.age, required this.highScore});

  factory UserScore.fromSnapshot(DataSnapshot snapshot) {
    String name =
        snapshot.child('information/name').value as String? ?? 'No Name';
    String age = snapshot.child('information/age').value as String? ?? 'No Age';
    int highScore = int.parse(
        (snapshot.child('games/work/highScore').value as int? ?? 0).toString());

    return UserScore(
      name: name,
      age: age,
      highScore: highScore,
    );
  }
}
