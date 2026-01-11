import 'package:cloud_firestore/cloud_firestore.dart';

class StudyDocument {
  final String id;
  final String userId;
  final String name;
  final String fileUrl; // Firebase Storage URL
  final String fileType; // 'pdf', 'docx', etc.
  final String size; // Human readable string e.g. "2.5 MB"
  final DateTime uploadedAt;
  final bool isProcessed; // True if AI has indexed it for chat

  StudyDocument({
    required this.id,
    required this.userId,
    required this.name,
    required this.fileUrl,
    required this.fileType,
    required this.size,
    required this.uploadedAt,
    this.isProcessed = false,
  });

  factory StudyDocument.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudyDocument(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      fileUrl: data['fileUrl'] ?? '',
      fileType: data['fileType'] ?? 'unknown',
      size: data['size'] ?? '',
      uploadedAt: (data['uploadedAt'] as Timestamp).toDate(),
      isProcessed: data['isProcessed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'size': size,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
      'isProcessed': isProcessed,
    };
  }
}