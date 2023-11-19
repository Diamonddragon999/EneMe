import '/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserNameInput extends StatefulWidget {
  final Function(String, String, String) onSubmit;

  const UserNameInput({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _UserNameInputState createState() => _UserNameInputState();
}

class _UserNameInputState extends State<UserNameInput> {
  final TextEditingController _nameController = TextEditingController();
  TimeOfDay _wakeUpTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _bedTime = const TimeOfDay(hour: 22, minute: 0);

  Future<void> _selectTime(BuildContext context, bool isWakeUpTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isWakeUpTime ? _wakeUpTime : _bedTime,
    );

    if (picked != null && picked != (isWakeUpTime ? _wakeUpTime : _bedTime)) {
      setState(() {
        if (isWakeUpTime) {
          _wakeUpTime = picked;
        } else {
          _bedTime = picked;
        }
      });
    }
  }

  Future<void> _submitData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _nameController.text);
      await prefs.setString('wakeUpTime', _wakeUpTime.format(context));
      await prefs.setString('bedTime', _bedTime.format(context));

      widget.onSubmit(
        _nameController.text,
        _wakeUpTime.format(context),
        _bedTime.format(context),
      );

      // Navigate back to the home screen
      MaterialPageRoute(builder: (context) => const HomeScreen());
    } catch (e) {
      // Handle errors here, possibly show a dialog to the user
      debugPrint('Error saving data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Wrap the Scaffold with MaterialApp
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text('Wake-up Time: ${_wakeUpTime.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context, true),
              ),
              ListTile(
                title: Text('Bedtime: ${_bedTime.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context, false),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
