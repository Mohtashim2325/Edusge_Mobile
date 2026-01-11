import 'package:cloud_firestore/cloud_firestore.dart';

class Submission {
  final String id;
  final String quizId;
  final String studentId;
  final String studentName;
  final double score;
  final double maxScore;
  final String status; // 'pending' (if teacher needs to grade) or 'graded'
  final Map<String, dynamic> answers; // Key: QuestionID, Value: User Answer
  final DateTime submittedAt;
  final String? teacherFeedback;

  Submission({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.studentName,
    required this.score,
    required this.maxScore,
    required this.status,
    required this.answers,
    required this.submittedAt,
    this.teacherFeedback,
  });

  factory Submission.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Submission(
      id: doc.id,
      quizId: data['quizId'] ?? '',
      studentId: data['studentId'] ?? '',
      studentName: data['studentName'] ?? 'Unknown',
      score: (data['score'] ?? 0).toDouble(),
      maxScore: (data['maxScore'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      answers: Map<String, dynamic>.from(data['answers'] ?? {}),
      submittedAt: (data['submittedAt'] as Timestamp).toDate(),
      teacherFeedback: data['teacherFeedback'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quizId': quizId,
      'studentId': studentId,
      'studentName': studentName,
      'score': score,
      'maxScore': maxScore,
      'status': status,
      'answers': answers,
      'submittedAt': Timestamp.fromDate(submittedAt),
      'teacherFeedback': teacherFeedback,
    };
  }
}