/*import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/database.dart';
import '../util/dialog_box.dart';
import '../util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

    @override
void initState() {
  super.initState();
  if (_myBox.get("TODOLIST") == null) {
    db.createInitialData();
    db.updateDataBase();  // Save initial data to Hive
  } else {
    db.loadData();
  }
}

  final _controller = TextEditingController();
  DateTime selectedDate = DateTime.now(); // For storing the selected date

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {
  setState(() {
    db.toDoList.add([_controller.text, false, selectedDate]);
    _controller.clear();
  });
  Navigator.of(context).pop();
  db.updateDataBase();
}

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
          onSelectDate: (DateTime date) {
            setState(() {
              selectedDate = date;
            });
          },
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 11, 11),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
  
    return ToDoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              taskDate: db.toDoList[index][2],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            );
},

      ),
    );
  }
}*/


import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/database.dart';
import '../util/dialog_box.dart';
import '../util/todo_tile.dart';
import '../NotificationManager.dart'; // Import NotificationManager

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();
  late NotificationManager notificationManager; // Declare NotificationManager

  @override
  void initState() {
    super.initState();
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
      db.updateDataBase();
    } else {
      db.loadData();
    }
    notificationManager = NotificationManager(); // Initialize NotificationManager
    notificationManager.initNotifications();
  }

  final _controller = TextEditingController();
  DateTime selectedDate = DateTime.now(); // For storing the selected date

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {

    
    var newTaskDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      9, 0); // Setting the time to 9 AM

    setState(() {
      db.toDoList.add([_controller.text, false, newTaskDate]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();

    // Schedule notification
    notificationManager.scheduleNotification(newTaskDate);
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
          onSelectDate: (DateTime date) {
            setState(() {
              selectedDate = date;
            });
          },
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 11, 11),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
  
    return ToDoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              taskDate: db.toDoList[index][2],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            );
},

      ),
    );
  }
}
