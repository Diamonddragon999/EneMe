import 'package:flutter/material.dart';
import 'homescreen.dart';

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;
  TimeOfDay _wakeUpTime =
      const TimeOfDay(hour: 7, minute: 0); // Default wake-up time
  TimeOfDay _bedTime = const TimeOfDay(hour: 22, minute: 0); // Default bedtime

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    // Load wake-up time and bedtime from SharedPreferences
  }

  void _saveSettings() {
    widget.onUserDataChanged(_nameController.text, _wakeUpTime.format(context),
        _bedTime.format(context));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully updated data'),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
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
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final String userName;
  final Function(String, String, String) onUserDataChanged;

  const SettingsScreen({
    Key? key,
    required this.userName,
    required this.onUserDataChanged,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}
