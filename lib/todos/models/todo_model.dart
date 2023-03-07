import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String content;
  final Timestamp created;
  final Timestamp updated;
  final bool done;

  Todo(
      {
      required this.content,
      required this.created,
      required this.updated,
      required this.done});

  factory Todo.fromJson(String str) => Todo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
      content: json["Content"],
      created: json["Created"],
      updated: json["Updated"],
      done: json["Done"]);
  Map<String, dynamic> toMap() => {
        "Content": content,
        "Created": created,
        "Updated": updated,
        "Done": done,
      };
}
