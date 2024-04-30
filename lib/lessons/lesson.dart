import 'quiz_option.dart';

class Lesson {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String content;
  final List<QuizQuestion> quiz;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.content,
    required this.quiz,
  });

  factory Lesson.fromMap(Map<dynamic, dynamic> data, String id) {
    var quizData = data['quiz'] as List;
    List<QuizQuestion> quizQuestions = quizData.map((questionData) {
      return QuizQuestion.fromMap(questionData);
    }).toList();

    return Lesson(
      id: id,
      title: data['title'] ?? 'Название отсутствует',
      description: data['description'] ?? 'Описание отсутствует',
      imageUrl: data['imageUrl'],
      content: data['content'] ?? 'Текст отсутствует',
      quiz: quizQuestions,
    );
  }
}
