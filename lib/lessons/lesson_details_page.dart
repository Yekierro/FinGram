import 'package:fingram/button/rounded_button.dart';
import 'package:fingram/lessons/lessons_progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'lesson.dart';
import 'quiz_option.dart';

class LessonDetailsPage extends StatefulWidget {
  final Lesson lesson;

  const LessonDetailsPage({super.key, required this.lesson});

  @override
  _LessonDetailsPageState createState() => _LessonDetailsPageState();
}

class _LessonDetailsPageState extends State<LessonDetailsPage> {
  Map<int, String?> selectedOptions = {};
  Map<int, bool> isCorrect = {};
  bool allAnswersChecked = false;

  void _checkAllAnswers() {
    bool allCorrect = true;

    for (int i = 0; i < widget.lesson.quiz.length; i++) {
      QuizQuestion question = widget.lesson.quiz[i];
      String? selected = selectedOptions[i];

      if (selected != null) {
        bool correct = question.options
            .any((option) => option.text == selected && option.isCorrect);
        isCorrect[i] = correct;

        if (!correct) allCorrect = false;
      } else {
        allCorrect = false;
        isCorrect.remove(i);
      }
    }

    setState(() {
      allAnswersChecked = true;
    });

    if (allCorrect) {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Поздравляем!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: const Text(
            'Ты молодец! \n Урок пройден.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: RoundedButton(
                    colour: Colors.blueAccent,
                    title: 'Вернуться на главную',
                    onPressed: () {
                      _markLessonAsCompleted();
                      Navigator.pushNamedAndRemoveUntil(
                          context, 'Уроки', (Route<dynamic> route) => false);
                    })),
          ],
        );
      },
    );
  }

  void _markLessonAsCompleted() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String lessonId = widget.lesson.id;

    DatabaseReference progressRef =
        FirebaseDatabase.instance.ref('users/$userId/progress/$lessonId');
    DataSnapshot progressSnapshot = await progressRef.get();

    if (progressSnapshot.exists) {
      if (progressSnapshot.value is Map) {
        var progressData = progressSnapshot.value as Map<dynamic, dynamic>;

        bool isCompleted = progressData['isCompleted'] == true;
        if (isCompleted) {
          print("Урок уже был завершен, монеты не начисляются.");
        } else {
          await updateLessonProgress(userId, lessonId, true);
          await incrementCoins(userId, 5);
        }
      } else {
        print("Неверный формат данных для прогресса урока.");
      }
    }
  }

  Future<void> incrementCoins(String userId, int coinsToAdd) async {
    DatabaseReference coinsRef =
        FirebaseDatabase.instance.ref('users/$userId/coins');
    DataSnapshot snapshot = await coinsRef.get();
    int currentCoins = (snapshot.exists && snapshot.value != null)
        ? int.parse(snapshot.value.toString())
        : 0;
    await coinsRef.set(currentCoins + coinsToAdd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(widget.lesson.imageUrl, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.lesson.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Text(widget.lesson.description),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(widget.lesson.content,
                  style: const TextStyle(fontSize: 20)),
            ),
            const Divider(),
            ...widget.lesson.quiz.asMap().entries.map((entry) {
              int idx = entry.key;
              QuizQuestion quiz = entry.value;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Вопрос: ${quiz.question}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  ...quiz.options.map((option) => ListTile(
                        title: Text(option.text),
                        leading: Radio<String>(
                          value: option.text,
                          groupValue: selectedOptions[idx],
                          onChanged: (String? value) {
                            setState(() {
                              selectedOptions[idx] = value;
                            });
                          },
                        ),
                      )),
                  if (allAnswersChecked)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        isCorrect[idx] != null && isCorrect[idx]!
                            ? "Правильный ответ!"
                            : "Неправильный ответ!",
                        style: TextStyle(
                          color: isCorrect[idx] != null && isCorrect[idx]!
                              ? Colors.green
                              : Colors.red,
                          fontSize: 18,
                        ),
                      ),
                    ),
                ],
              );
            }),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RoundedButton(
                    colour: Colors.blueAccent,
                    title: 'Проверить все ответы',
                    onPressed: _checkAllAnswers)),
          ],
        ),
      ),
    );
  }
}
