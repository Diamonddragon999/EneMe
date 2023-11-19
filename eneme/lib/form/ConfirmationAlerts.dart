import 'package:flutter/material.dart';
import '../models/DayCountModel.dart';
import '../util/Helpers.dart';

Future<void> showResetDialog(DayCount dayCount, BuildContext currentContext, Function actionFunc) async {
  final todaysDate = makeReadableDateFromDate(DateTime.now().millisecondsSinceEpoch);
  return showDialog<void>(
    context: currentContext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Reset this target?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Doing this will the date of this target to $todaysDate, and the day count back to 0\n'),
              const Text('Alternativley, you can set to a different date or modify details, by tapping the Edit button'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No, Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes, Reset Target'),
            onPressed: () {
              actionFunc(dayCount);
            },
          ),
        ],
      );
    },
  );
}

Future<void> showDeleteDialog(DayCount dayCount, BuildContext currentContext, Function actionFunc) async {
  final targetName = dayCount.title;
  return showDialog<void>(
    context: currentContext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete this target?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want permantly to delete target: $targetName?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No, Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes, Delete Target'),
            onPressed: () {
              actionFunc(dayCount);
            },
          ),
        ],
      );
    },
  );
}
