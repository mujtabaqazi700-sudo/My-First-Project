import 'package:app/Login.dart';
import 'package:app/Mynotes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Note extends StatefulWidget {
  static const String routeName = '/note';

  final String username;
  final String email;

  const Note({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  Box? notesBox;
  @override
  void initState() {
    super.initState();
    openBox();
  }

  @override
  Future<void> openBox() async {
    notesBox = await Hive.openBox('notesBox_${widget.email}');
    setState(() {});
  }

  void addNote(String title, String note) {
    if (notesBox == null) return; // ← ADD THIS LINE

    String formattedDate =
        DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

    notesBox!.add({
      'title': title,
      'note': note,
      'date': formattedDate,
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      //  Gradient AppBar
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.blueAccent),
        ),
        title: const Text(
          'My Notes',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text(
                widget.username,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(widget.email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  widget.username.isNotEmpty
                      ? widget.username[0].toUpperCase()
                      : '',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                ),
              ),
            ),

            // Drawer Items
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Login.routeName,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: notesBox == null
          ? const SizedBox()
          : notesBox!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 0.6,
                        child: Image.asset(
                          'lib/images/person1.png',
                          width: 180,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'No notes yet!',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: notesBox!.length,
                  itemBuilder: (context, index) {
                    var note = notesBox!.getAt(index) as Map;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        shadowColor: Colors.black26,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      note['title'] ?? '',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Mynotes(
                                                title: note['title'],
                                                note: note['note'],
                                              ),
                                            ),
                                          );

                                          if (result != null) {
                                            setState(() {
                                              notesBox!.putAt(index, {
                                                'title': result['title'],
                                                'note': result['note'],
                                                'date': note['date'],
                                              });
                                            });
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                              title: const Text('Delete Note'),
                                              content: const Text(
                                                  'Are you sure you want to delete this note?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Cancel'),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red),
                                                  onPressed: () {
                                                    setState(() {
                                                      notesBox!.deleteAt(index);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),

                              const SizedBox(height: 8),

                              Text(
                                note['note'] ?? '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 5),
                                  Text(
                                    note['date'] ?? '',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

      //  Modern FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        elevation: 6,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Mynotes()),
          );

          if (result != null) {
            addNote(result['title'], result['note']);
          }
        },
      ),
    );
  }
}
