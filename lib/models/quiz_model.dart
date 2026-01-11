import 'package:cloud_firestore/cloud_firestore.dart';
import 'question_model.dart';

class Quiz {
  final String id;
  final String teacherId;
  final String title;
  final String subject;
  final String topic;
  final String status; // 'draft', 'active', 'archived'
  final String difficulty; // 'easy', 'medium', 'hard'
  final String accessCode; // The 6-char code for students
  final int timeLimitSeconds;
  final DateTime createdAt;
  final List<Question> questions; 

  Quiz({
    required this.id,
    required this.teacherId,
    required this.title,
    required this.subject,
    required this.topic,
    required this.status,
    required this.difficulty,
    required this.accessCode,
    required this.timeLimitSeconds,
    required this.createdAt,
    this.questions = const [],
  });

  factory Quiz.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Quiz(
      id: doc.id,
      teacherId: data['teacherId'] ?? '',
      title: data['title'] ?? '',
      subject: data['subject'] ?? '',
      topic: data['topic'] ?? '',
      status: data['status'] ?? 'draft',
      difficulty: data['difficulty'] ?? 'medium',
      accessCode: data['accessCode'] ?? '',
      timeLimitSeconds: data['timeLimitSeconds'] ?? 1800,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      questions: (data['questions'] as List<dynamic>?)
          ?.map((q) => Question.fromMap(q))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'teacherId': teacherId,
      'title': title,
      'subject': subject,
      'topic': topic,
      'status': status,
      'difficulty': difficulty,
      'accessCode': accessCode,
      'timeLimitSeconds': timeLimitSeconds,
      'createdAt': Timestamp.fromDate(createdAt),
      'questions': questions.map((q) => q.toMap()).toList(),
    };
  }
}