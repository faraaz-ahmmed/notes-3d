import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';
import '../viewmodels/notes_viewmodel.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotesViewModel>();

    // Start Body
    return Scaffold(
      backgroundColor: const Color(0xffeef2ff),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff6c4df6),
        foregroundColor: Colors.white,
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.add),
        label: const Text('New Note'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Start Header
                  const Text(
                    'My Notes',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff29255e),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${viewModel.notes.length} notes',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  // End Header

                  const SizedBox(height: 22),

                  // Start Search
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffeef2ff),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-5, -5),
                          blurRadius: 12,
                        ),
                        BoxShadow(
                          color: Color(0x305c6692),
                          offset: Offset(5, 5),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: viewModel.searchNotes,
                      decoration: const InputDecoration(
                        hintText: 'Search notes',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xff6c4df6),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 17,
                        ),
                      ),
                    ),
                  ),
                  // End Search

                  const SizedBox(height: 25),

                  // Start Notes
                  Expanded(
                    child: _NotesContent(
                      viewModel: viewModel,
                      onEdit: (note) => _openEditor(
                        context,
                        note: note,
                      ),
                    ),
                  ),
                  // End Notes
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // End Body
  }

  // Start Editor
  void _openEditor(
    BuildContext context, {
    NoteModel? note,
  }) {
    showDialog(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<NotesViewModel>(),
        child: _NoteEditor(note: note),
      ),
    );
  }
  // End Editor
}

class _NotesContent extends StatelessWidget {
  final NotesViewModel viewModel;
  final ValueChanged<NoteModel> onEdit;

  const _NotesContent({
    required this.viewModel,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Start Loading
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xff6c4df6),
        ),
      );
    }
    // End Loading

    // Start Error
    if (viewModel.error != null && viewModel.notes.isEmpty) {
      return Center(
        child: Text(
          viewModel.error!,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 16,
          ),
        ),
      );
    }
    // End Error

    // Start Empty Notes
    if (viewModel.notes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.note_alt_outlined,
              size: 75,
              color: Color(0xff6c4df6),
            ),
            SizedBox(height: 15),
            Text(
              'No notes found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff29255e),
              ),
            ),
          ],
        ),
      );
    }
    // End Empty Notes

    // Start Notes Grid
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 1;

        if (constraints.maxWidth >= 900) {
          columns = 3;
        } else if (constraints.maxWidth >= 600) {
          columns = 2;
        }

        return GridView.builder(
          padding: const EdgeInsets.only(bottom: 90),
          itemCount: viewModel.notes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            mainAxisExtent: 220,
          ),
          itemBuilder: (context, index) {
            final note = viewModel.notes[index];

            return _NoteCard(
              note: note,
              onEdit: () => onEdit(note),
              onPin: () => viewModel.togglePin(note),
              onDelete: () => viewModel.deleteNote(note.id),
            );
          },
        );
      },
    );
    // End Notes Grid
  }
}

class _NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onEdit;
  final VoidCallback onPin;
  final VoidCallback onDelete;

  const _NoteCard({
    required this.note,
    required this.onEdit,
    required this.onPin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Start Note Card
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xffeef2ff),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            offset: Offset(-6, -6),
            blurRadius: 14,
          ),
          BoxShadow(
            color: Color(0x305c6692),
            offset: Offset(6, 6),
            blurRadius: 14,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff29255e),
                  ),
                ),
              ),
              IconButton(
                onPressed: onPin,
                icon: Icon(
                  note.isPinned
                      ? Icons.push_pin
                      : Icons.push_pin_outlined,
                  color: note.isPinned
                      ? const Color(0xffffa000)
                      : Colors.black45,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              note.description.isEmpty
                  ? 'No description'
                  : note.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                height: 1.5,
                color: Colors.black54,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                '${note.updatedAt.day}/${note.updatedAt.month}/${note.updatedAt.year}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xff6c4df6),
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
    // End Note Card
  }
}

class _NoteEditor extends StatefulWidget {
  final NoteModel? note;

  const _NoteEditor({this.note});

  @override
  State<_NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<_NoteEditor> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.note?.title ?? '',
    );

    descriptionController = TextEditingController(
      text: widget.note?.description ?? '',
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // Start Save Note
  Future<void> saveNote() async {
    setState(() => isSaving = true);

    final viewModel = context.read<NotesViewModel>();
    bool success;

    if (widget.note == null) {
      success = await viewModel.addNote(
        title: titleController.text,
        description: descriptionController.text,
      );
    } else {
      success = await viewModel.updateNote(
        id: widget.note!.id,
        title: titleController.text,
        description: descriptionController.text,
      );
    }

    if (!mounted) return;

    setState(() => isSaving = false);

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.error ?? 'Something went wrong'),
        ),
      );
    }
  }
  // End Save Note

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    // Start Editor Body
    return Dialog(
      backgroundColor: const Color(0xffeef2ff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 550,
          maxHeight: width < 600 ? 550 : 600,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    widget.note == null ? 'New Note' : 'Edit Note',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff29255e),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  filled: true,
                  fillColor: Colors.white54,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: TextField(
                  controller: descriptionController,
                  expands: true,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    labelText: 'Write your note',
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: Colors.white54,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: isSaving ? null : saveNote,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xff6c4df6),
                  ),
                  child: isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Save Note'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // End Editor Body
  }
}