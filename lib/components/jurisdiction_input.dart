import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ifta/components/fuel_receipt_input.dart';
import 'package:ifta/user_preferences.dart';

class JurisdictionInput extends StatefulWidget {
  final VoidCallback onDelete;

  JurisdictionInput({Key? key, required this.onDelete}) : super(key: key);

  @override
  _JurisdictionInputState createState() => _JurisdictionInputState();
}

class _JurisdictionInputState extends State<JurisdictionInput> {
  List<FuelReceiptInput> fieldDataList = [];
  final TextEditingController mileageController = TextEditingController();
  String _selectedCountry = 'USA';
  String _selectedState = 'State 1';

  List<String> _countries = [];
  List<String> _states = [];

  DropdownButton<String> buildDropdownButton(List<String> items,
      String selectedValue, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      value: selectedValue,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }


  void assignValuesToDropdowns(String serverResponse) {
    Map<String, dynamic> responseObj = jsonDecode(serverResponse);
    Map<String, dynamic> fuelReceiptValues =
        responseObj['FuelReceipt']['values'];

        print("ok1");

    String countriesString = fuelReceiptValues['Country'].toString();
    List<String> countriesKeyValuePair =
        countriesString.substring(1, countriesString.length - 1).split(', ');
    List<String> countries = countriesKeyValuePair.map((pair) {
      return pair.split(':')[1]; // Split the pair and return the key  
    }).toList();

    print(countries);

    String statesString = fuelReceiptValues['Jurisdiction'].toString();
    List<String> statesKeyValuePair =
        statesString.substring(1, statesString.length - 1).split(', ');
    List<String> states = statesKeyValuePair.map((pair) {
      return pair.split(':')[1]; // Split the pair and return the key
    }).toList();

    print(states);

    setState(() {
      _countries = countries;
      _states = states;
      _selectedCountry = _countries[0];
      _selectedState = _states[0];
    });
  }

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
  void initState() {
    super.initState();
    UserPreferences.getIftaValues().then((value) => assignValuesToDropdowns(value!));
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
                        buildDropdownButton(_countries , _selectedCountry, (value) => setState(() => _selectedCountry = value!),)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('State'),
                        buildDropdownButton(_states, _selectedState,
                            (value) => setState(() => _selectedState = value!),),
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