import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  
    PUT YOUR CREDENTIALS HERE

  ''';


  // set up & connect to the spreadsheet
  static const _spreadsheetId = 'PUT YOUR SPREADSHEET ID HERE';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfNotes = 0;
  static List<List<dynamic>> currentNotes = [
    // [ to do, completed]
  ];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while (
        (await _worksheet!.values.value(column: 1, row: numberOfNotes + 1)) !=
            '') {
      numberOfNotes++;
    }
    // now we know how many notes to load, now let's load them!
    loadNotes();
  }

  // insert a new note
  static Future insert(String note) async {
    if (_worksheet == null) return;
    numberOfNotes++;
    currentNotes.add([note, 0]);
    await _worksheet!.values.appendRow([note, 0]);
  }

  // load existing notes from the spreadsheet
  static Future loadNotes() async {
    if (_worksheet == null) return;

    for (int i = 0; i < numberOfNotes; i++) {
      final String newNote =
          await _worksheet!.values.value(column: 1, row: i + 1);
      if (currentNotes.length < numberOfNotes) {
        currentNotes.add([
          newNote,
          int.parse(await _worksheet!.values.value(column: 2, row: i + 1))
        ]);
      }
    }
    // this will stop the circular loading indicator
    loading = false;
  }

  static Future update(int index, int isTaskCompleted) async {
    _worksheet!.values.insertValue(isTaskCompleted, column: 2, row: index + 1);
  }
}
