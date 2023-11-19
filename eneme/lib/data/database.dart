import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];

  // reference our box
  final _myBox = Hive.box('mybox');

  // run this method if this is the 1st time ever opening this app
  void createInitialData() {
  DateTime defaultDate = DateTime.now();
  toDoList = [
    ["Make Tutorial", false, defaultDate],
    ["Do Exercise", false, defaultDate],
  ];
}

  // load the data from database
  void loadData() {
  var loadedData = _myBox.get("TODOLIST");
  if (loadedData != null && loadedData.isNotEmpty) {
    toDoList = loadedData.map((item) {
      // If the loaded item doesn't have a date, add a default date
      if (item.length == 2) {
        return [item[0], item[1], DateTime.now()];
      }
      return item;
    }).toList();
  }
}

  // update the database
  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
