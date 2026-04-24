class JournalEntry {
  Id? id;
  String? title;
  String? content;
  String? date;
  String? sentiment;

  JournalEntry({this.id, this.title, this.content, this.date, this.sentiment});

  JournalEntry.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? Id.fromJson(json['id']) : null;
    title = json['title'];
    content = json['content'];
    date = json['date'];
    sentiment = json['sentiment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id!.toJson();
    }
    data['title'] = title;
    data['content'] = content;
    data['date'] = date;
    data['sentiment'] = sentiment;
    return data;
  }
}

class Id {
  int? timestamp;
  String? date;

  Id({this.timestamp, this.date});

  Id.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timestamp'] = timestamp;
    data['date'] = date;
    return data;
  }
}
