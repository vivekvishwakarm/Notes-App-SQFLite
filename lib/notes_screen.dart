import 'package:flutter/material.dart';
import 'package:notes/add_notes.dart';
import 'package:notes/db_helper.dart';
import 'package:notes/edit_screen.dart';
import 'package:notes/model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String search = "";
  bool isSearch = false;
  TextEditingController searchController = TextEditingController();

  DBHelper? dbHelper;
  late Future<List<NoteModel>> noteList;

  getData() {
    // Assign the result of getNoteList to noteList
    setState(() {
      noteList = dbHelper!.getNoteList();
    });
  }

  @override
  void initState() {
    dbHelper = DBHelper();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isSearch == false
          ? AppBar(
              centerTitle: true,
              backgroundColor: Colors.brown,
              title: const Text(
                "Notes",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 27),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isSearch = true;
                      });
                    },
                    icon: const Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            )
          : AppBar(
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              leading: BackButton(
                onPressed: () {
                  setState(() {
                    isSearch = false;
                  });
                },
              ),
              title: TextFormField(
                maxLines: 1,
                controller: searchController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                ),
                onChanged: (String value){
                  search = value.toString();
                  setState(() {
                  });

                },
              ),
            ),
      body: SafeArea(
        child: FutureBuilder<List<NoteModel>>(
          future: noteList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading notes"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No notes available"));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {

                if(searchController.text.isEmpty){
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.brown,
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(snapshot.data![index].title.toString()),
                      subtitle:
                      Text(snapshot.data![index].description.toString()),
                      trailing: PopupMenuButton(
                        color: Colors.white,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: ListTile(
                              leading:
                              const Icon(Icons.edit, color: Colors.green),
                              title: const Text("Edit",
                                  style: TextStyle(fontSize: 18)),
                              onTap: () {
                                // Handle edit action
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditScreen(
                                          id: snapshot.data![index].id,
                                          title: snapshot.data![index].title
                                              .toString(),
                                          description: snapshot
                                              .data![index].description
                                              .toString(),
                                        )));

                                // Close the popup
                                // Perform your edit action here
                              },
                            ),
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              leading:
                              const Icon(Icons.delete, color: Colors.red),
                              title: const Text("Delete",
                                  style: TextStyle(fontSize: 18)),
                              onTap: () {
                                // Handle delete action
                                setState(() {
                                  dbHelper!.delete(snapshot.data![index].id!);
                                  noteList = dbHelper!.getNoteList();
                                  snapshot.data!.remove(snapshot.data![index]);
                                  Navigator.pop(context);
                                }); // Close the popup
                                // Perform your delete action here
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }else if(snapshot.data![index].title.toLowerCase().contains(searchController.text.toLowerCase())){
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.brown,
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(snapshot.data![index].title.toString()),
                      subtitle:
                      Text(snapshot.data![index].description.toString()),
                      trailing: PopupMenuButton(
                        color: Colors.white,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: ListTile(
                              leading:
                              const Icon(Icons.edit, color: Colors.green),
                              title: const Text("Edit",
                                  style: TextStyle(fontSize: 18)),
                              onTap: () {
                                // Handle edit action
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditScreen(
                                          id: snapshot.data![index].id,
                                          title: snapshot.data![index].title
                                              .toString(),
                                          description: snapshot
                                              .data![index].description
                                              .toString(),
                                        )));

                                // Close the popup
                                // Perform your edit action here
                              },
                            ),
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              leading:
                              const Icon(Icons.delete, color: Colors.red),
                              title: const Text("Delete",
                                  style: TextStyle(fontSize: 18)),
                              onTap: () {
                                // Handle delete action
                                setState(() {
                                  dbHelper!.delete(snapshot.data![index].id!);
                                  noteList = dbHelper!.getNoteList();
                                  snapshot.data!.remove(snapshot.data![index]);
                                  Navigator.pop(context);
                                }); // Close the popup
                                // Perform your delete action here
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }else{}

              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddNotes()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
