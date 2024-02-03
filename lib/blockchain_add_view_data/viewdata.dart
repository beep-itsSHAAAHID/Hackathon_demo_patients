import 'package:flutter/material.dart';
import 'package:blockchain_demo/blockchain_services/notes_service.dart'; // Import your NotesServices class
import 'package:provider/provider.dart';

class ViewData extends StatefulWidget {
  const ViewData({Key? key}) : super(key: key);

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  late Future<void> fetchNotesFuture;

  @override
  void initState() {
    super.initState();
    final notesService = context.read<NotesServices>();
    fetchNotesFuture = notesService.fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Data from Blockchain'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Notes:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            FutureBuilder<void>(
              future: fetchNotesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return NotesList(); // Widget to display the list of notes
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NotesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notesService = context.read<NotesServices>();

    return Consumer<NotesServices>(
      builder: (context, notes, child) {
        if (notes.notes.isEmpty) {
          return Text('No notes available.');
        } else {
          return ListView.builder(
            itemCount: notes.notes.length,
            itemBuilder: (context, index) {
              final note = notes.notes[index];
              return ListTile(
                title: Text('Title: ${note.title}'),
                subtitle: Text('Description: ${note.description}'),
              );
            },
          );
        }
      },
    );
  }
}
