import 'package:flutter/material.dart';
import 'package:ifta/components/fuel_receipt_input.dart';

class JurisdictionInput extends StatefulWidget {
  final VoidCallback onDelete;

  JurisdictionInput({Key? key, required this.onDelete}) : super(key: key);

  @override
  _JurisdictionInputState createState() => _JurisdictionInputState();
}

class _JurisdictionInputState extends State<JurisdictionInput> {
  List<FuelReceiptInput> fieldDataList = [];
  final TextEditingController mileageController = TextEditingController();
  String selectedCountry = 'USA';
  String selectedState = 'State 1';

  void addFields() {
    String uniqueId = 'uniqueId${fieldDataList.length}';
    print(uniqueId);

    setState(() {
      fieldDataList.add(
        FuelReceiptInput(
          key: ValueKey(uniqueId), // Assign a unique ID to this widget
          onDelete: () => removeFields(
              uniqueId), // Pass the existing unique ID to the removeFields method
        ),
      );
    });
  }

  void removeFields(String uniqueId) {
    setState(() {
      fieldDataList.removeWhere((widget) =>
          widget.key ==
          ValueKey(uniqueId)); // Remove the widget with the matching key
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('Country'),
                        DropdownButton<String>(
                          value: selectedCountry,
                          items: <String>['USA', 'Canada', 'Mexico']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCountry = value??'';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('State'),
                        DropdownButton<String>(
                          value: selectedState,
                          items: <String>['State 1', 'State 2', 'State 3']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedState = value??'';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('Mileage'),
                        TextField(
                          controller: mileageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter mileage',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: fieldDataList.isEmpty
                  ? const Center(child: Text('No Fuel Receipt Added'))
                  : Column(
                      children: fieldDataList,
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: Text('Add Fuel Receipt Input'),
                onPressed: addFields,
              ),
              TextButton(
                onPressed: widget.onDelete,
                child: Text('Remove Jurisdiction Input'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mileageController.dispose();
    super.dispose();
  }
}