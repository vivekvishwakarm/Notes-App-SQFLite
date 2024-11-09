class NoteModel{
  final int? id;
  final String title;
  final String description;

  NoteModel({this.id, required this.title, required this.description});

  NoteModel.fromMap(Map<String, dynamic> res):
      id = res["id"],
  title = res["title"],
  description = res["description"];

  Map<String, Object?> toMap(){
    return{
      "id" : id,
      "title" : title,
      "description" : description
    };
}


}