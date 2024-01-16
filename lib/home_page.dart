import 'package:flutter/material.dart';
import 'package:ifta/api_service.dart';
import 'package:ifta/components/jurisdiction_input.dart';
import 'package:ifta/login_page.dart';

class FieldData {
  final String title;
  final String hint;

  FieldData(this.title, this.hint);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> jurisdictionList = [];
  List<String> jurisdictionKeys = []; // Keep track of the keys of the widgets

  void addJurisdiction() {
    String uniqueId = 'uniqueId${jurisdictionList.length}';
    jurisdictionKeys.add(uniqueId); // Add the key to the list of keys

    setState(() {
      jurisdictionList.add(
        ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: 500), // Set the maximum height as needed
          child: JurisdictionInput(
            key: ValueKey(uniqueId), // Assign a unique key to this widget
            onDelete: () => removeJurisdiction(
                uniqueId), // Pass the unique ID to the removeFields method
          ),
        ),
      );
    });
  }

  void removeJurisdiction(String uniqueId) {
    int indexToRemove = jurisdictionKeys
        .indexOf(uniqueId); // Find the index of the key in the list of keys
    print(indexToRemove.toString() + " indexToRemove");
    print(uniqueId + " uniqueId");

    if (indexToRemove != -1) {
      setState(() {
        jurisdictionKeys
            .removeAt(indexToRemove); // Remove the key from the list of keys
        jurisdictionList
            .removeAt(indexToRemove); // Remove the widget at the same index
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                await ApiService.logout();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: jurisdictionList.isEmpty
                    ? Center(child: Text('No Jurisdiction Data Entered'))
                    : Column(
                        children: jurisdictionList,
                      ),
              ),
            ),
            Card(
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'Number of Jurisdiction Records: ${jurisdictionList.length}'),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle submit action here
                          },
                          child: Text('Submit'),
                        ),
                        SizedBox(
                            width: 10), // Add some space between the buttons
                        ElevatedButton(
                          onPressed: addJurisdiction,
                          child: Text('Add Jurisdiction'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
