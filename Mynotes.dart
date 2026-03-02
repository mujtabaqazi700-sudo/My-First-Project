import 'package:flutter/material.dart';

class Mynotes extends StatefulWidget {
  final String? title;
  final String? note;

  const Mynotes({super.key, this.title, this.note});

  @override
  State<Mynotes> createState() => _MynotesState();
}

class _MynotesState extends State<Mynotes> {
  late TextEditingController titleController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title ?? '');
    noteController = TextEditingController(text: widget.note ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      //  Same Gradient AppBar
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          widget.title == null ? 'Add Note' : 'Edit Note',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Title",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),

              //  Modern Title Field
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Enter note title",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),

              //  Modern Note Field
              TextField(
                controller: noteController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: "Write your note here...",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              //  Full Width Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty ||
                        noteController.text.isNotEmpty) {
                      Navigator.pop(context, {
                        'title': titleController.text,
                        'note': noteController.text,
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    widget.title == null ? "Save Note" : "Update Note",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
