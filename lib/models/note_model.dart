import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String description;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
  });

  // Start Firestore Data
  factory NoteModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    return NoteModel(
      id: document.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isPinned: data['isPinned'] ?? false,
      createdAt: _getDateTime(data['createdAt']),
      updatedAt: _getDateTime(data['updatedAt']),
    );
  }
  // End Firestore Data

  // Start Map Data
  Map<String, dynamic> toMap() {
    return {
      'title': title.trim(),
      'description': description.trim(),
      'isPinned': isPinned,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
  // End Map Data

  // Start Date Converter
  static DateTime _getDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    return DateTime.now();
  }
  // End Date Converter
}