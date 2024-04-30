import 'package:fingram/lessons/lesson_card.dart';
import 'package:fingram/lessons/lessons_progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fingram/lessons/lesson.dart';

class LessonsList extends StatefulWidget {
  const LessonsList({super.key});

  @override
  _LessonsListState createState() => _LessonsListState();
}

class _LessonsListState extends State<LessonsList> {
  List<Lesson> lessons = [];
  Map<String, LessonProgress> userProgress = {};

  @override
  void initState() {
    super.initState();
    loadUserLessonsAndProgress();
  }

  void loadUserLessonsAndProgress() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference lessonsRef = FirebaseDatabase.instance.ref('lessons');
    DatabaseReference progressRef =
        FirebaseDatabase.instance.ref('users/$userId/progress');

    DatabaseEvent lessonsEvent = await lessonsRef.once();
    if (lessonsEvent.snapshot.exists) {
      Map<dynamic, dynamic> lessonsMap =
          lessonsEvent.snapshot.value as Map<dynamic, dynamic>;
      List<Lesson> loadedLessons = [];
      lessonsMap.forEach((key, value) {
        loadedLessons.add(Lesson.fromMap(value, key));
      });

      loadedLessons.sort((a, b) => a.id.compareTo(b.id));

      DatabaseEvent progressEvent = await progressRef.once();
      Map<String, LessonProgress> progressMap = {};
      if (progressEvent.snapshot.exists) {
        Map<dynamic, dynamic> values =
            progressEvent.snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          progressMap[key] =
              LessonProgress(lessonId: key, isCompleted: value['isCompleted']);
        });
      }

      setState(() {
        lessons = loadedLessons;
        userProgress = progressMap;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        Lesson lesson = lessons[index];
        LessonProgress progress =
            userProgress[lesson.id] ?? LessonProgress(lessonId: lesson.id);
        return LessonCard(lesson: lesson, progress: progress);
      },
    );
  }
}
