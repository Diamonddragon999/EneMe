import 'dart:convert';

/// This is the Model that all DayCounts follow,and this file
/// contains the basic manipulation methods done on the object
/// Licensed Under MIT, (C) 2019 Alicia Sykes <as@mail.as93.net>

DayCount clientFromJson(String str) {
  final jsonData = json.decode(str);
  return DayCount.fromMap(jsonData);
}

String clientToJson(DayCount data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class DayCount {
  int id;
  String title;
  int date;

  DayCount({required this.id, required this.title, required this.date});

  factory DayCount.fromMap(Map<String, dynamic> json) => DayCount(
    id: json["id"],
    title: json["title"],
    date: int.parse(json["date"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "date": date,
  };
}