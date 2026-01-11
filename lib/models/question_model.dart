class Question {
  final String id;
  final String type; // 'mcq' or 'qa'
  final String questionText;
  final List<String> options; // For MCQs
  final dynamic correctAnswer; // Int index for MCQ, String for QA
  final String aiExplanation;
  final String sourceRef; // e.g., "Page 12"
  final int points;

  Question({
    required this.id,
    required this.type,
    required this.questionText,
    this.options = const [],
    required this.correctAnswer,
    this.aiExplanation = '',
    this.sourceRef = '',
    this.points = 1,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'].toString(), // Ensure ID is string even if int in DB
      type: map['type'] ?? 'mcq',
      questionText: map['questionText'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswer: map['correctAnswer'],
      aiExplanation: map['aiExplanation'] ?? '',
      sourceRef: map['sourceRef'] ?? '',
      points: map['points'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'questionText': questionText,
      'options': options,
      'correctAnswer': correctAnswer,
      'aiExplanation': aiExplanation,
      'sourceRef': sourceRef,
      'points': points,
    };
  }
}