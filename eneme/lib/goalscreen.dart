import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';


class GoalsScreen extends StatefulWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  TimeOfDay selectedTime = TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
          // Your goals list or content here
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGoalOptions,
        tooltip: 'Add Goal',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showPredefinedGoals() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose your weapon!'),
          content: SingleChildScrollView(
            child: ListBody(  
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.fitness_center), // Icon for Get in Shape
                  title: const Text('Get in Shaape'),
                  subtitle: const Text(
                      'A fitness routine to help you get that dream body.'),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Handle the goal selection here
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.self_improvement), // Icon for Meditation
                  title: const Text('Meditation'),
                  subtitle: const Text(
                      'Daily meditation for mental clarity and emotion control.'),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Handle the goal selection here
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.phone_locked), // Icon for Social Media Detox
                  title: const Text('Social Media Detox'),
                  subtitle: const Text(
                      'Reduce social media usage for a healthier lifestyle.'),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Handle the goal selection here
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bedtime), // Icon for Better Sleep
                  title: const Text('Better Sleep'),
                  subtitle: const Text('Improve your sleep patterns and quality.'),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Handle the goal selection here
                  },
                ),
                ListTile(
                  leading: const Icon(Icons
                      .sentiment_satisfied_alt), // Icon for Daily Gratitude
                  title: const Text('Daily Gratitude'),
                  subtitle:
                      const Text('Practice daily gratitude to enhance positivity.'),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Handle the goal selection here
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddGoalOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Time to level up?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Ready-made Goal'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showPredefinedGoals(); // Call the predefined goals dialog
                },
              ),
              ListTile(
                leading: const Icon(Icons.create),
                title: const Text('Custom Goal'),
                onTap: () {
                  Navigator.of(context).pop();
                  // Navigate to Custom Goal Setup
                },
              ),
            ],
          ),
        );
      },
    );
  }
}