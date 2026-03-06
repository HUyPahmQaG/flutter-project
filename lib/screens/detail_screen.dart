import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart';

class DetailScreen extends StatefulWidget {
  final Note? note;
  const DetailScreen({super.key, this.note});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  Future<void> saveNote() async {
    final notes = await NoteService.getNotes();

    if (widget.note == null) {
      notes.add(
        Note(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: titleController.text,
          content: contentController.text,
          createdAt: DateTime.now(),
        ),
      );
    } else {
      widget.note!.title = titleController.text;
      widget.note!.content = contentController.text;
    }

    await NoteService.saveNotes(notes);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await saveNote();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ===== TIÊU ĐỀ =====
              TextField(
                controller: titleController,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: "Nhập tiêu đề...",
                  border: InputBorder.none,
                ),
              ),

              const Divider(thickness: 1.2),

              /// ===== NỘI DUNG =====
              Expanded(
                child: TextField(
                  controller: contentController,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: "Nhập nội dung ghi chú...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
