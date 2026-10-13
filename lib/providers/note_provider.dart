import 'package:flutter/material.dart';
import '../data/models/note_model.dart';
import '../data/services/hive_service.dart';

class NoteProvider with ChangeNotifier {
  List<NoteModel> _notes = [];

  List<NoteModel> get notes => _notes;

  NoteProvider() {
    loadNotes();
  }

  Future<void> loadNotes() async {
    final rawList = await HiveService.getNotes();
    _notes = rawList.map((e) => NoteModel.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> addNote(NoteModel item) async {
    _notes.add(item);
    await HiveService.saveNotes(_notes.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> editNote(NoteModel updatedItem) async {
    final index = _notes.indexWhere((e) => e.id == updatedItem.id);
    if (index != -1) {
      _notes[index] = updatedItem;
      await HiveService.saveNotes(_notes.map((e) => e.toJson()).toList());
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((e) => e.id == id);
    await HiveService.saveNotes(_notes.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> updateNote(NoteModel updatedItem) async {
    await editNote(updatedItem);
  }
}
