class QuizOption {
  final String text;
  final bool isCorrect;

  QuizOption({required this.text, required this.isCorrect});

  factory QuizOption.fromMap(Map<dynamic, dynamic> data) {
    return QuizOption(
      text: data['text'],
      isCorrect: data['isCorrect'],
    );
  }
}

class QuizQuestion {
  final String question;
  final List<QuizOption> options;

  QuizQuestion({required this.question, required this.options});

  factory QuizQuestion.fromMap(Map<dynamic, dynamic> data) {
    var optionsData = data['options'] as List;
    List<QuizOption> options = optionsData.map((optionData) {
      return QuizOption.fromMap(optionData);
    }).toList();

    return QuizQuestion(
      question: data['question'],
      options: options,
    );
  }
}
