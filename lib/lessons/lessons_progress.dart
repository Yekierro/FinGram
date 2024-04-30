import 'package:firebase_database/firebase_database.dart';

class LessonProgress {
  final String lessonId;
  bool isCompleted;

  LessonProgress({required this.lessonId, this.isCompleted = false});

  Map<String, dynamic> toMap() {
    return {
      'isCompleted': isCompleted,
    };
  }
}

Future<void> updateLessonProgress(
    String userId, String lessonId, bool isCompleted) async {
  DatabaseReference progressRef =
      FirebaseDatabase.instance.ref('users/$userId/progress/$lessonId');
  try {
    await progressRef.update({'isCompleted': isCompleted});
    print('Progress updated successfully for lesson ID: $lessonId');
  } catch (e) {
    print('Error updating progress for lesson ID: $lessonId: $e');
  }
}

void loadUserProgress(
    String userId, Function(Map<String, LessonProgress>) onProgressLoaded) {
  DatabaseReference ref =
      FirebaseDatabase.instance.ref('users/$userId/progress');

  ref.once().then((DatabaseEvent snapshot) {
    Map<String, LessonProgress> progressMap = {};
    if (snapshot.snapshot.value != null) {
      Map<dynamic, dynamic> values =
          snapshot.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, value) {
        progressMap[key] =
            LessonProgress(lessonId: key, isCompleted: value['isCompleted']);
      });
      onProgressLoaded(progressMap);
      print("User progress loaded successfully for user $userId.");
    } else {
      print("No progress found for user $userId.");
    }
  }).catchError((error) {
    print('Error loading user progress for user $userId: $error');
  });
}
