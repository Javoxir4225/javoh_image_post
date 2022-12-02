class PostModel {
  String? id;
  String? fullname;
  String? listname;
  String? content;
  String? location;
  String? date;

  PostModel({
    this.id,
    this.fullname,
    this.listname,
    this.content,
    this.location,
    this.date,
  });

  PostModel.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    fullname = data["fullname"];
    listname = data["listname"];
    content = data["content"];
    location = data["location"];
    date = data["date"];
  }
  Map<String, dynamic> toJson() {
    return {
      "id":id,
      "fullname": fullname,
      "listname": listname,
      "content": content,
      "location": location,
      "date": date,
    };
  }
}
