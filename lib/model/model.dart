class NoteModel {
  final int? id;
  final String title;
  final String description;

  NoteModel({this.id, required this.title, required this.description});

  //for converting a database record back to a NoteModel object
  NoteModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        description = res["description"];

  //for converting a NoteModel object to a map for database operations
  Map<String, Object?> toMap() {
    return {"id": id, "title": title, "description": description};
  }
}