import 'package:fingram/lessons/lesson_details_page.dart';
import 'package:flutter/material.dart';
import 'package:fingram/lessons/lesson.dart';
import 'package:fingram/lessons/lessons_progress.dart';

class LessonCard extends StatefulWidget {
  final Lesson lesson;
  final LessonProgress progress;

  const LessonCard({
    Key? key,
    required this.lesson,
    required this.progress,
  }) : super(key: key);

  @override
  _LessonCardState createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.progress.isCompleted ? Colors.green : Colors.white,
      child: ListTile(
        leading: widget.lesson.imageUrl.isNotEmpty
            ? Image.asset(widget.lesson.imageUrl,
                width: 50, height: 50, fit: BoxFit.cover)
            : const Icon(Icons.image_not_supported),
        title: Text(widget.lesson.title),
        subtitle: Text(widget.lesson.description),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonDetailsPage(lesson: widget.lesson),
            ),
          );
        },
      ),
    );
  }
}
