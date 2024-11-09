import 'package:flutter/material.dart';
import 'package:notes/db_helper.dart';
import 'package:notes/model.dart';
import 'package:notes/notes_screen.dart';

class EditScreen extends StatefulWidget {
  final String title, description;
  final int? id;
  const EditScreen(
      {super.key, required this.title, required this.description, this.id});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController titleController =
      TextEditingController(text: widget.title);
  late TextEditingController descriptionController =
      TextEditingController(text: widget.description);

  DBHelper? dbHelper;
  late Future<List<NoteModel>> noteList;

  @override
  void initState() {
    dbHelper = DBHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.brown,
        title: const Text(
          "Notes",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.02),
              height: height * 0.43,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.brown),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05, vertical: height * 0.01),
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      maxLines: 1,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                      ),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 10,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: 'Description',
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            ElevatedButton(
              onPressed: () {
                dbHelper!
                    .edit(
                  NoteModel(
                    id: widget.id,
                    title: titleController.text.toString(),
                    description: descriptionController.text.toString(),
                  ),
                )
                    .then((value) {
                  noteList = dbHelper!.getNoteList();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Update successfully"),
                    backgroundColor: Colors.green,
                  ));
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotesScreen()));
                }).onError((error, stackTrack) {
                  print("Error");
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                minimumSize: Size(
                  width * 0.5,
                  height * 0.06,
                ),
              ),
              child: const Text(
                "Add",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
