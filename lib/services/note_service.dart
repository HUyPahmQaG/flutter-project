import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NoteService {
  static const String key = "notes";

  static Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? data = prefs.getStringList(key);

    if (data == null) return [];

    return data.map((e) => Note.fromJson(e)).toList();
  }

  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data = notes.map((e) => e.toJson()).toList();
    await prefs.setStringList(key, data);
  }
}
