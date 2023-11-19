import 'package:flutter/material.dart';
import '../util/Database.dart';
//import 'package:Eneme/form/TargetNameInput.dart' hide targetNameInput;
import '../models/DayCountModel.dart';

// Assuming targetDateInput is defined in TargetdateInput.dart
import 'package:Eneme/form/TargetdateInput.dart';

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



// Create a Form widget.
class DayCountFormState extends StatefulWidget {
  final bool isEditing;
  final DayCount existingDayCount;
  final GlobalKey<ScaffoldState> scaffoldState;
  final Function doneFunction;

  const DayCountFormState({
    required Key key,
    required this.isEditing,
    required this.existingDayCount,
    required this.scaffoldState,
    required this.doneFunction,
  }) : super(key: key);

  @override
  DayCountScreen createState() => DayCountScreen(isEditing, existingDayCount, scaffoldState, doneFunction);
}

class DayCountScreen extends State<DayCountFormState> {
  bool isEditing;
  DayCount existingDayCount;
  GlobalKey<ScaffoldState> scaffoldState;
  Function doneFunction;

  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  final targetNameController = TextEditingController();
  int currentDayCountId = 0;

  DayCountScreen(this.isEditing, this.existingDayCount, this.scaffoldState, this.doneFunction) {
    addInitialValues();
  }

  @override
  void dispose() {
    targetNameController.dispose();
    super.dispose();
  }

  void addInitialValues() {
    if (isEditing) {
      currentDayCountId = existingDayCount.id;
      targetNameController.text = existingDayCount.title;
      selectedDate = DateTime.fromMillisecondsSinceEpoch(existingDayCount.date);
    }
  }

  void updateDateState(DateTime newDate) {
    setState(() => selectedDate = newDate);
  }

  void handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      var targetName = targetNameController.text;
      var targetDate = selectedDate.millisecondsSinceEpoch;
      var dayCountData = DayCount(title: targetName, date: targetDate, id: currentDayCountId);

      if (isEditing) {
        await DBProvider.db.updateDayCount(dayCountData);
        doneFunction('${dayCountData.title} has been updated');
      } else {
        await DBProvider.db.insertDayCount(dayCountData);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('\'$targetName\' has been added')));
        Navigator.pop(context);
      }
    }
  }

  Widget targetSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyan,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Save',
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double paddingValue = isEditing ? 2 : 24;
    final double maxHeight = isEditing ? 300 : 600;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight, minWidth: 300),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: isEditing ? null : AppBar(title: const Text('Add new Target')),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: paddingValue * 2, horizontal: paddingValue),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(padding: EdgeInsets.all(6)),
                targetNameInput(targetNameController),
                const Padding(padding: EdgeInsets.all(12)),
                targetDateInput(context, selectedDate, updateDateState),
                const Padding(padding: EdgeInsets.all(12)),
                targetSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
