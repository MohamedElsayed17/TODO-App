import 'package:todo_app/shared/network/local/database_constants.dart';

class Todo {
  int? id;
  String? title;
  String? time;
  String? date;
  String? status;

  Todo({
    this.title,
    this.time,
    this.date,
    this.status,
  });

  Todo.fromMap(Map<String, dynamic> map) {
    id = map['${DatabaseConstants.COLUMN_ID}'];
    title = map['${DatabaseConstants.COLUMN_TITLE}'];
    time = map['${DatabaseConstants.COLUMN_TIME}'];
    date = map['${DatabaseConstants.COLUMN_DATE}'];
    status = map['${DatabaseConstants.COLUMN_STATUS}'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseConstants.COLUMN_ID: id,
      DatabaseConstants.COLUMN_TITLE: title,
      DatabaseConstants.COLUMN_TIME: time,
      DatabaseConstants.COLUMN_DATE: date,
      DatabaseConstants.COLUMN_STATUS: status,
    };
  }
}
