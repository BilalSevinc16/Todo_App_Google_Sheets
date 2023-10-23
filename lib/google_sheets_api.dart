import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = {
    "type": "service_account",
    "project_id": "pacific-aurora-402709",
    "private_key_id": "be23bc5cd51d71918f755ecd7dc00f2280588d94",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCHyKdlGcOQMHa3\no4iDOTXRdJ6Xqvczi1Ut4ZazrPuzQnm2blDiJ+9wzMVJvxHsU6VtkqzuU2z82TQi\nTcCWdayDQ48EsoRvJsNxIbQo1qXxRURtKMcgaA6b7K2g8GliuUmO9PDvk4sbR4XP\nDWpfWBAIVlM17i+FooWj6LLTlUGQqnzg0wj00OMEeyWgrkxKXjZ4hQc0xqHPTybW\nOFajbIoHjBvQc1upuQoUuLa2Gr24V0Pq6jmDnge/jeYTzLUPLAB0WcdOugvUK3Kh\nTQh6It+y0ttp/pssoeOjcHJAokzfzLHXKQ2uX5g9+MW0OUodWZOLx/9T75pEmn1u\nTKTOgXdxAgMBAAECggEAAXcidYHBXFAl6iy63DyDopxl2oH2ZQqSt2dls4/+f1Bn\nJ7yhqp98QEPJIzGgy0kPuiAE9fVlpzDTz6ULtY1Pg1MOeIznEdvETHy85kYC6xNY\nkLjEdYqinI9MTvuEjfj3z1yV0Hu/irfN3MaIBIoa0gXhTqMrb+opc5kUcST9XNbn\n0kdXrT3Z2ATJ5vaSi9zk2/NTwfOIwQcxKAtwAxF0R0lrVMN3vgh4uKZPntoMaxup\nRTCp5K3xovmlR3OjiK/FnekhlW1EdW/mHbuacNqmwdYi5BrDIywgXGBhGYf8jJDA\nhINw2PTa5owcHaJHCAdiIAZAkVFqgFFE9HgUO5DTIQKBgQC/SWzuCcy4ubTW6R9r\n+tJxR0N4UcMNDZH1D4tzN+bi2xiHbnfZ83DtsWNTRxAR0BqUVOnTmQ6hvED9AOiK\nWBhKJ+rnSXsLTLgwv3uNNOLz3YJJtqj2Ozw6jnRLXa8z1rJDbrBZ9WvVgUnz3wXz\nhh3QNHUfAR/R4f5C+KDwLPIdkQKBgQC1uFZ1jqevXXr/K1UcX5WF5DxNZn51T+LY\nqiUazAhvO3Ybu53NtQclXtHuZUaNefpbQlLNmP+QwLoPlEZIzjTwlxJnvXO1OKX+\no5iEMQegjRNRAxFEmJ9q/ZjjC3zK4Tl4D+nHwAcIox22/2Y9FxwYvEkfeWdH7WuD\nxGf8GExL4QKBgDY8hWxAzxEZZpMA6m3dYknIIPM+i4Vp8ZaAX9O9Z/Oul5fe1JCx\nm7VpdHYqUf4a+U5RfTMH1MQ68lpKJaUEMW7lPo9xoDel+xunT0rMUgU/Ky/nYKTg\nSsV3mrW7zG9wUn8YJVx8X6Tb0bIZ7EAOKOnd1c+CrBkAcO1gPZGbzNJhAoGAHcYw\nVF6lVvRoHLsK3PVEWIXG45+xhKMsNffa0IMxtpf1iCG7f2Lz4smgeAEcCD4+KQm6\n63jwFtWdJsRSp8cxoWH/YAQIm17Gw+wmJzKpX0L+MT3hbG3dYPhgPoM5VTyF4Agr\nc9Eg1ed0DPHX3JaWwe7HxGJt67kY7qQVrZaFmcECgYASV/n/0cY+PKF7rDEIFc1z\nmyDg4Ghx9/plCZJ0cWwjsSaG73ywpv6B/lVApzHveTsnxzGB0eMJeFaa3JC+9L41\n2lGwTXYG7HmxBd472/ggYECgqdyc1AFL4Id1X4KHOcNTKm2c03hvuz55Sim4Md+R\nMEytsH+JgobR9Fg3PVnHYg==\n-----END PRIVATE KEY-----\n",
    "client_email":
        "flutter-gsheets-tutorial@pacific-aurora-402709.iam.gserviceaccount.com",
    "client_id": "117281399532955293407",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheets-tutorial%40pacific-aurora-402709.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  // set up & connect to the spreadsheet
  static const _spreadsheetId = "1iKsbXL5KJSt6iwnWWw3ZSC80-iXlG0brlZd4lJ-EeDA";
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
