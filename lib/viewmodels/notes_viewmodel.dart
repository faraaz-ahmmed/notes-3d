import 'dart:async';

import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../services/firebase_service.dart';

class NotesViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  StreamSubscription<List<NoteModel>>? _subscription;

  List<NoteModel> _notes = [];
  String _searchText = '';
  String? _error;
  bool _isLoading = true;

  List<NoteModel> get notes {
    if (_searchText.isEmpty) {
      return _notes;
    }

    final search = _searchText.toLowerCase();

    return _notes.where((note) {
      return note.title.toLowerCase().contains(search) ||
          note.description.toLowerCase().contains(search);
    }).toList();
  }

  String? get error => _error;
  bool get isLoading => _isLoading;

  NotesViewModel() {
    loadNotes();
  }

  // Start Load Notes
  void loadNotes() {
    _subscription = _firebaseService.getNotes().listen(
      (notes) {
        _notes = notes;
        _error = null;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _error = 'Unable to load notes';
        _isLoading = false;
        notifyListeners();
      },
    );
  }
  // End Load Notes

  // Start Search Notes
  void searchNotes(String value) {
    _searchText = value.trim();
    notifyListeners();
  }
  // End Search Notes

  // Start Add Note
  Future<bool> addNote({
    required String title,
    required String description,
  }) async {
    if (title.trim().isEmpty) {
      _error = 'Please enter a title';
      notifyListeners();
      return false;
    }

    try {
      await _firebaseService.addNote(
        title: title,
        description: description,
      );

      _error = null;
      return true;
    } catch (error) {
      _error = 'Unable to add note';
      notifyListeners();
      return false;
    }
  }
  // End Add Note

  // Start Update Note
  Future<bool> updateNote({
    required String id,
    required String title,
    required String description,
  }) async {
    if (title.trim().isEmpty) {
      _error = 'Please enter a title';
      notifyListeners();
      return false;
    }

    try {
      await _firebaseService.updateNote(
        id: id,
        title: title,
        description: description,
      );

      _error = null;
      return true;
    } catch (error) {
      _error = 'Unable to update note';
      notifyListeners();
      return false;
    }
  }
  // End Update Note

  // Start Pin Note
  Future<void> togglePin(NoteModel note) async {
    try {
      await _firebaseService.togglePin(
        id: note.id,
        isPinned: note.isPinned,
      );

      _error = null;
    } catch (error) {
      _error = 'Unable to pin note';
      notifyListeners();
    }
  }
  // End Pin Note

  // Start Delete Note
  Future<void> deleteNote(String id) async {
    try {
      await _firebaseService.deleteNote(id);
      _error = null;
    } catch (error) {
      _error = 'Unable to delete note';
      notifyListeners();
    }
  }
  // End Delete Note

  // Start Dispose
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  // End Dispose
}