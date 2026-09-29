import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _notesCollection {
    return _firestore.collection('notes');
  }

  // Start Get Notes
  Stream<List<NoteModel>> getNotes() {
    return _notesCollection
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      final notes = snapshot.docs
          .map((document) => NoteModel.fromFirestore(document))
          .toList();

      notes.sort((first, second) {
        if (first.isPinned == second.isPinned) {
          return second.updatedAt.compareTo(first.updatedAt);
        }

        return first.isPinned ? -1 : 1;
      });

      return notes;
    });
  }
  // End Get Notes

  // Start Add Note
  Future<void> addNote({
    required String title,
    required String description,
  }) async {
    await _notesCollection.add({
      'title': title.trim(),
      'description': description.trim(),
      'isPinned': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  // End Add Note

  // Start Update Note
  Future<void> updateNote({
    required String id,
    required String title,
    required String description,
  }) async {
    await _notesCollection.doc(id).update({
      'title': title.trim(),
      'description': description.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  // End Update Note

  // Start Pin Note
  Future<void> togglePin({
    required String id,
    required bool isPinned,
  }) async {
    await _notesCollection.doc(id).update({
      'isPinned': !isPinned,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  // End Pin Note

  // Start Delete Note
  Future<void> deleteNote(String id) async {
    await _notesCollection.doc(id).delete();
  }
  // End Delete Note
}