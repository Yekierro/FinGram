import 'package:fingram/button/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'lessons_list.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  _LessonsPageState createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  int coins = 0;

  @override
  void initState() {
    super.initState();
    loadCoins();
  }

  void loadCoins() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference coinsRef =
        FirebaseDatabase.instance.ref('users/$userId/coins');
    DataSnapshot snapshot = await coinsRef.get();
    if (snapshot.exists && snapshot.value != null) {
      setState(() {
        coins = int.parse(snapshot.value.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Уроки'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.monetization_on,
                      size: 40, color: Colors.yellow),
                  onPressed: () {
                    Navigator.pushNamed(context, 'shop');
                  },
                ),
                Text(
                  ' $coins',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              size: 50,
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'user_profile');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          RoundedButton(
            colour: Colors.blueAccent,
            title: 'Играть',
            onPressed: () {
              Navigator.pushNamed(context, 'game');
            },
          ),
          const Expanded(
            child: LessonsList(),
          ),
        ],
      ),
    );
  }
}
