import 'package:flutter/material.dart';
// Use an alias if there's a naming conflict
import '../models/DayCountModel.dart';
import '../util/Database.dart';
import 'package:folding_cell/folding_cell.dart';
//import '../models/DayCountModel.dart';
//import '../util/Database.dart';
import '../util/Helpers.dart';
import '../form/ConfirmationAlerts.dart';

class DisplayDayCount extends StatefulWidget {
  final DayCount dayCountData;
  final GlobalKey<ScaffoldState> scaffoldState;
  final Function updateState;

  const DisplayDayCount({
    super.key,
    required this.dayCountData,
    required this.scaffoldState,
    required this.updateState,
  });

  @override
  _DisplayDayCountState createState() => _DisplayDayCountState();
}

class _DisplayDayCountState extends State<DisplayDayCount> {
  late DayCount dayCount;
  late BuildContext currentContext;
  late Function
      parentUpdate; // Stores reference to a StateUpdate function in the Parent view
  late GlobalKey<SimpleFoldingCellState> _foldingCellKey;

  @override
  void initState() {
    super.initState();
    dayCount = widget.dayCountData;
    currentContext = context;
    parentUpdate = widget.updateState;
    _foldingCellKey = GlobalKey<SimpleFoldingCellState>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _foldingCellKey.currentState?.toggleFold();
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        child: SimpleFoldingCell.create(
          key: _foldingCellKey,
          frontWidget: _buildOuterTopWidget(context),
          cellSize: Size(MediaQuery.of(context).size.width, 125),
          padding: const EdgeInsets.all(15),
          animationDuration: const Duration(milliseconds: 300),
          borderRadius: 5,
          innerWidget: null,
        ),
      ),
    );
  }

  /// From a given date, uses helper function to find days, then appends string
  String getDayCountText(int date) {
    return makeDayCountFromDate(
          DateTime.fromMillisecondsSinceEpoch(date),
        ).toString() +
        " Days";
  }

  /// The topper half of the FoldingCell, shown when it is closed, shows the number of days
  Widget _buildOuterTopWidget(BuildContext context) {
    return Container(
      color: const Color(0xff6200ED),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildDateDisplayWidget(context, false),
        ],
      ),
    );
  }

  /// The topper half of the FoldingCell, shown once it is open, shows date in full format
  Widget _buildInnerTopWidget(BuildContext context) {
    return Container(
      color: const Color(0xff8A28FF),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildDateDisplayWidget(context, true),
        ],
      ),
    );
  }

  /// Shows how long the target has been running for, either in Days or Readable Date
  Widget _buildDateDisplayWidget(BuildContext context, bool open) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Text(
            dayCount.title + (open ? ' Since' : ' For '),
            style: TextStyle(
              color: Colors.deepPurple[100],
              fontFamily: 'OpenSans',
              fontSize: 24,
            ),
          ),
          Text(
            open
                ? makeReadableDateFromDate(dayCount.date)
                : getDayCountText(dayCount.date),
            style: TextStyle(
              color: Colors.deepPurple[100],
              fontFamily: 'OpenSans',
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            open ? 'Tap to hide Options' : 'Tap for more Options',
            style: TextStyle(
              color: Colors.deepPurple[300],
              fontFamily: 'OpenSans',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// The Option Button, contained in the OptionButtonRowWidget
  Widget _buildOptionsButtonWidget(
      String text, IconData icon, Function() action) {
    return ElevatedButton(
      onPressed: action,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff8A28FF), // Background color
        padding: const EdgeInsets.all(10.0),
      ),
      child: Row(
        // Horizontal icon + text
        children: <Widget>[
          Icon(
            icon,
            color: Colors.deepPurple[100],
          ),
          const SizedBox(
              width: 8), // Add some spacing between the icon and the text
          Text(
            text,
            style: TextStyle(color: Colors.deepPurple[100]),
          ),
        ],
      ),
    );
  }

  /// The widget containing the Reset, Edit and Delete buttons
  Widget _buildOptionsButtonRowWidget(
      DayCount dayCount, GlobalKey<ScaffoldState> scaffoldState) {
    return Container(
      color: Colors.blueGrey[100],
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildOptionsButtonWidget('Reset', Icons.update,
              () => showResetDialog(dayCount, currentContext, resetDays)),
          _buildOptionsButtonWidget('Edit', Icons.edit,
              () => _showEditDialog(widget.scaffoldState, dayCount)),
          _buildOptionsButtonWidget('Delete', Icons.delete,
              () => showDeleteDialog(dayCount, currentContext, deleteItem)),
        ],
      ),
    );
  }

  /// Pops open a dialog, with the Edit form in it
  void _showEditDialog(
      GlobalKey<ScaffoldState> scaffoldState, DayCount dayCount) {
    showDialog(
      context: currentContext,
      builder: (currentContext) {
        return AlertDialog(
          title: const Text('Edit Target'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DayCountFormWidget(
              isEditing: true,
              existingDayCount: dayCount,
              scaffoldState: scaffoldState,
              doneFunction: updateUiAfterChange,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        );
      },
    );
  }

  /// Calls to DB to delete a given daycount, and calls to update UI
  void deleteItem(DayCount dayCountToDelete) {
    DBProvider.db.deleteDayCount(dayCountToDelete.id);
    updateUiAfterChange(
        'Target: \'' + dayCountToDelete.title + '\' has been deleted');
  }

  /// Sets the current date of a selected record to Today, then updates the UI
  void resetDays(DayCount dayCountToUpdate) {
    // Make the Update
    dayCountToUpdate.date = DateTime.now().millisecondsSinceEpoch;
    DBProvider.db.updateDayCount(dayCountToUpdate);
    updateUiAfterChange(
        'Target: \'' + dayCountToUpdate.title + '\' has been reset to today');
  }

  /// Closes dialog, show success snackbar and updates the parent state
  void updateUiAfterChange(String successMsg) {
    // Close the dialog
    Navigator.of(currentContext).pop();

    // Show a success message
    final snackBar = SnackBar(content: Text(successMsg));
    ScaffoldMessenger.of(currentContext).showSnackBar(snackBar);

    // Update the parent state
    parentUpdate();
  }
}

class DayCountFormWidget extends StatefulWidget {
  final bool isEditing;
  final DayCount existingDayCount;
  final GlobalKey<ScaffoldState> scaffoldState;
  final Function doneFunction;

  const DayCountFormWidget({
    super.key,
    required this.isEditing,
    required this.existingDayCount,
    required this.scaffoldState,
    required this.doneFunction,
  });

  @override
  DayCountFormState createState() => DayCountFormState();
}

class DayCountFormState extends State<DayCountFormWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: Implement the build method for the DayCountFormWidget
    throw UnimplementedError();
  }
}

class NfuHome extends StatefulWidget {
  final String title;
  const NfuHome({Key? key, required this.title}) : super(key: key);

  @override
  _NfuHomeState createState() => _NfuHomeState();
}

class _NfuHomeState extends State<NfuHome> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  void navigateToAddNewItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              DayCountAddEdit(scaffoldState: scaffoldState, isEditing: false)),
    );
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<DayCount>>(
        future: DBProvider.db.getAllDayCounts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<DayCount>> snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                DayCount dayCountData = snapshot.data![index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    // Implementation of deletion logic
                  },
                  child: displayDayCount(
                      context, dayCountData, scaffoldState, updateState),
                );
              },
            );
          } else {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You don\'t have any targets yet\n\nTap the Add button to get started\n\n\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.35),
                    fontSize: 36,
                    shadows: <Shadow>[
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                ),
              ],
            ));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToAddNewItem();
        },
        tooltip: 'Add a new target',
        child: const Icon(Icons.add),
      ),
    );
  }
}
