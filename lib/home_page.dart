import 'package:flutter/material.dart';
import 'package:ifta/about_us.dart';
import 'package:ifta/api_service.dart';
import 'package:ifta/components/jurisdiction_class.dart';
import 'package:ifta/components/jurisdiction_input.dart';
import 'package:ifta/login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> jurisdictionList = [];
  List<Key> jurisdictionKeys = []; // Keep track of the keys of the widgets

  List<JurisdictionClass> jurisdictionValues = [];

  void handleJurisdictionValuesChanged(JurisdictionClass jurisdictionClass) {
    print("Change in Jurisdiction Values");
    int index = jurisdictionValues.indexWhere(
        (element) => element.getUniqueId == jurisdictionClass.getUniqueId);
    if (index == -1) {
      print("Adding Jurisdiction Class");
      jurisdictionValues.add(jurisdictionClass);
    } else {
      print("Updating Jurisdiction Class");
      jurisdictionValues[index] = jurisdictionClass;
    }
  }

  void addJurisdiction() {
    Key uniqueId = UniqueKey(); // Create a unique key for each widget
    jurisdictionKeys.add(uniqueId); // Add the key to the list of keys

    setState(() {
      jurisdictionList.add(
        ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: 500), // Set the maximum height as needed
          child: JurisdictionInput(
            key: uniqueId, // Assign a unique key to this widget
            onDelete: (jurisdictionClass) => removeJurisdiction(
                jurisdictionClass), // Pass the unique ID to the removeFields method
            onValuesChanged: handleJurisdictionValuesChanged,
          ),
        ),
      );
    });
  }

  void removeJurisdiction(JurisdictionClass jurisdictionClass) {
    print(jurisdictionClass.toJson());
    int indexToRemove = jurisdictionKeys.indexOf(jurisdictionClass
        .uniqueId); // Find the index of the key in the list of keys

    // remove JurisdictionClass from jurisdictionValues
    jurisdictionValues.remove(jurisdictionClass);

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
            ListTile(
  title: Text('About Us'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AboutUsPage()),
    );
  },
),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10), // Add margin
              child: Card(
                color: Colors.blue[100], // Set the background color of the card
                child: Padding(
                  padding: EdgeInsets.all(10), // Add padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Year Quarter',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      DropdownButton<String>(
                        hint: Text('Select an item'),
                        items: <String>[
                          'First item',
                          'Second item',
                          'Third item'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                            jurisdictionValues.forEach(
                              (element) => print(element.toJson()),
                            );
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
