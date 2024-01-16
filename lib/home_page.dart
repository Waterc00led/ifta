import 'package:flutter/material.dart';
import 'package:ifta/components/jurisdiction_input.dart';

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

  void addJurisdiction() {
    setState(() {
      jurisdictionList.add(
        Container(
          height: 500, // Set the height as needed
          width: double.infinity, // This will take the full available width
          child: JurisdictionInput(
            key: UniqueKey(),
            onDelete: () => removeJurisdiction(jurisdictionList.length - 1),
          ),
        ),
      );
    });
  }

  void removeJurisdiction(int index) {
    setState(() {
      jurisdictionList.removeAt(index);
    });
  }

  @override
Widget build(BuildContext context) {
  return Stack(
    children: [
      Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: SingleChildScrollView(
          child: jurisdictionList.isEmpty
              ? Center(child: Text('No Jurisdiction Data Entered'))
              : Column(
                  children: jurisdictionList,
                ),
        ),
        floatingActionButton: Container(), // Remove the floating action button
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Card(
          elevation: 5,
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Number of Jurisdiction Records: ${jurisdictionList.length}'),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle submit action here
                      },
                      child: Text('Submit'),
                    ),
                    SizedBox(width: 10), // Add some space between the buttons
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
      ),
    ],
  );
}
}
