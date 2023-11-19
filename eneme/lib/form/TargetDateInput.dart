import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../util/Helpers.dart';

///The Date Spinner and Label used in the Create and Edit a Target forms
Widget targetDateInput(BuildContext context, DateTime initialDate, Function updateDate) {
  var selectedDate = initialDate;
  return SizedBox(
    width: double.infinity,
    height: 60,
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: Colors.white, // Text Color
        backgroundColor: Colors.white,
        side: BorderSide(color: Theme.of(context).colorScheme.secondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        splashFactory: InkRipple.splashFactory, // For splash effect
      ),
      onPressed: () {
        DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: DateTime(2000, 1, 1),
            maxTime: DateTime.now(),
            onChanged: (date) {
              updateDate(date);
            },
            onConfirm: (date) {
              updateDate(date);
            },
            currentTime: selectedDate, locale: LocaleType.en);
      },
      child: Text(
        'Date: ' + makeReadableDateFromDate(selectedDate.millisecondsSinceEpoch),
        style: const TextStyle(fontFamily: 'OpenSans', fontSize: 24),
      ),
    ),
  );
}
