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

  
  void loadNotes() {                                           // Start Load Notes
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
  }                                                              // End Load Notes

  
  void searchNotes(String value) {                             // Start Search Notes
    _searchText = value.trim();
    notifyListeners();
  }                                                               // End Search Notes

 
  Future<bool> addNote({                                      // Start Add Note
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
  }                                                           // End Add Note

 
  Future<bool> updateNote({                                 // Start Update Note
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
  }                                                       // End Update Note

  
  Future<void> togglePin(NoteModel note) async {         // Start Pin Note
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
  }                                                      // End Pin Note

  
  Future<void> deleteNote(String id) async {             // Start Delete Note
    try {
      await _firebaseService.deleteNote(id);
      _error = null;
    } catch (error) {
      _error = 'Unable to delete note';
      notifyListeners();
    }
  }                                                      // End Delete Note

  
  @override                                            // Start Dispose
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }                                                 // End Dispose
}