import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ifta/components/fuel_receipt_input.dart';
import 'package:ifta/components/jurisdiction_class.dart';
import 'package:ifta/user_preferences.dart';

class JurisdictionInput extends StatefulWidget {
  final JurisdictionClass jurisdictionClass = JurisdictionClass(UniqueKey());
  final Function(JurisdictionClass jurisdictionClass) onDelete;
  final Function(JurisdictionClass jurisdictionClass) onValuesChanged;

  JurisdictionInput(
      {Key? key, required this.onDelete, required this.onValuesChanged})
      : super(key: key) {
    jurisdictionClass.setUniqueId = key!;
  }

  @override
  _JurisdictionInputState createState() => _JurisdictionInputState();
}

class _JurisdictionInputState extends State<JurisdictionInput> {
  List<FuelReceiptInput> _fuelReceiptInputs = [];
  final TextEditingController mileageController = TextEditingController();
  String _selectedCountry = 'USA';
  String _selectedState = 'State 1';
  int _mileage = 0;

  List<String> _countries = [];
  List<String> _states = [];

  bool isExpanded = false; // Add this line

  void _handleMileageChange(int value) {
    setState(() {
      _mileage = value;
    });
    widget.jurisdictionClass.setMileage = value;
    widget.onValuesChanged(widget.jurisdictionClass);
  }

  void _handleCountryChanged(String value) {
    setState(() {
      _selectedCountry = value;
    });
    widget.jurisdictionClass.setCountry = _selectedCountry;
    widget.onValuesChanged(widget.jurisdictionClass);
  }

  void _handleStateChanged(String value) {
    setState(() {
      _selectedState = value;
    });
    widget.jurisdictionClass.setState = _selectedState;
    widget.onValuesChanged(widget.jurisdictionClass);
  }

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

    String countriesString = fuelReceiptValues['Country'].toString();
    List<String> countriesKeyValuePair =
        countriesString.substring(1, countriesString.length - 1).split(', ');
    List<String> countries = countriesKeyValuePair.map((pair) {
      return pair.split(':')[1]; // Split the pair and return the key
    }).toList();

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
    Key uniqueId = UniqueKey();

    print("added");
    print(uniqueId);

    setState(() {
      _fuelReceiptInputs.add(
        FuelReceiptInput(
            key: uniqueId, // Assign a unique ID to this widget
            onDelete: (fuelReceiptClass) => {
                  removeFields(fuelReceiptClass.getUniqueId),
                }, // Pass the existing unique ID to the removeFields method
            onValuesChanged: (fuelReceiptClass) => {
                  widget.jurisdictionClass
                      .addFuelReceiptClass(fuelReceiptClass),
                  widget.onValuesChanged(widget.jurisdictionClass),
                }),
      );
    });

    widget.onValuesChanged(widget.jurisdictionClass);
  }

  void removeFields(Key uniqueId) {
    print("removed");
    print(uniqueId);

    setState(() {
      _fuelReceiptInputs.removeWhere((element) => element.key == uniqueId);
    });

    widget.jurisdictionClass.removeFuelReceiptClass(uniqueId);
    widget.onValuesChanged(widget.jurisdictionClass);
  }

  @override
  void initState() {
    super.initState();
    UserPreferences.getIftaValues()
        .then((value) => assignValuesToDropdowns(value!));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.lightBlue[50], // This will be the background color
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('Country'),
                        buildDropdownButton(_countries, _selectedCountry,
                            (value) => _handleCountryChanged(value!)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('State'),
                        buildDropdownButton(
                          _states,
                          _selectedState,
                          (value) => _handleStateChanged(value!),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('Mileage'),
                        TextField(
                          onChanged: (value) =>
                              _handleMileageChange(int.tryParse(value) ?? 0),
                          controller: mileageController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter mileage',
                          ),
                        ),
                      ],
                    ),
                  ),
                ], // This is the missing closing bracket
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: _fuelReceiptInputs.isEmpty
                    ? const Center(child: Text('No Fuel Receipt Added'))
                    : Column(
                        children: _fuelReceiptInputs,
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
                  onPressed: () => widget.onDelete(widget.jurisdictionClass),
                  child: Text('Remove Jurisdiction Input'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    mileageController.dispose();
    super.dispose();
  }
}
