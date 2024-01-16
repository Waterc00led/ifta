import 'package:flutter/material.dart';
import 'package:ifta/user_preferences.dart';
import 'dart:convert';

class FuelReceiptInput extends StatefulWidget {
  final VoidCallback onDelete;

  FuelReceiptInput({Key? key, required this.onDelete}) : super(key: key);

  @override
  _FuelReceiptInputState createState() => _FuelReceiptInputState();
}

class _FuelReceiptInputState extends State<FuelReceiptInput> {
  String _selectedFuelType = 'Fuel Type 1';
  String _selectedUnit = 'Unit 1';
  String _selectedCurrency = 'Currency 1';
  String _volume = '';
  String _amountPaid = '';
  List<String> _fuelTypes = [];
  List<String> _fuelUnits = [];

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

  List<DropdownMenuItem<String>> _getDropdownMenuItems(String values) {
    // Assuming values are in the format '[value1:value1, value2:value2, ...]'
    List<String> pairs = values.substring(1, values.length - 1).split(', ');
    return pairs.map((pair) {
      List<String> splitPair = pair.split(':');
      return DropdownMenuItem<String>(
        value: splitPair[0],
        child: Text(splitPair[1]),
      );
    }).toList();
  }

  void assignValuesToDropdowns(String serverResponse) {
    Map<String, dynamic> responseObj = jsonDecode(serverResponse);
    Map<String, dynamic> fuelReceiptValues =
        responseObj['FuelReceipt']['values'];

    String fuelTypeString = fuelReceiptValues['FuelType'].toString();
    List<String> fuelTypePairs =
        fuelTypeString.substring(1, fuelTypeString.length - 1).split(', ');
    List<String> fuelTypes = fuelTypePairs.map((pair) {
      return pair.split(':')[0]; // Split the pair and return the key
    }).toList();

    String fuelUnitString = fuelReceiptValues['FuelUnit'].toString();
    List<String> fuelUnitKeyPAir =
        fuelUnitString.substring(1, fuelUnitString.length - 1).split(', ');
    List<String> fuelUnits = fuelUnitKeyPAir.map((pair) {
      return pair.split(':')[0]; // Split the pair and return the key
    }).toList();

    setState(() {
      _fuelTypes = fuelTypes;
      _fuelUnits = fuelUnits;
      _selectedFuelType = _fuelTypes[0];
    });
  }

  TextField buildTextField(
      String hint, String value, ValueChanged<String> onChanged) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hint,
      ),
      controller: TextEditingController(text: value),
      onChanged: onChanged,
    );
  }

  @override
  void initState() {
    super.initState();
    UserPreferences.getIftaValues().then((response) {
      print("response: " + response!);
      assignValuesToDropdowns(response!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text('Fuel Type'),
                    buildDropdownButton(
                      _fuelTypes,
                      _selectedFuelType,
                      (value) => setState(() => _selectedFuelType = value!),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10), // Add space
              Expanded(
                child: Column(
                  children: [
                    const Text('Volume'),
                    buildTextField(
                      'Volume',
                      _volume,
                      (value) => setState(() => _volume = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10), // Add space
              Expanded(
                child: Column(
                  children: [
                    const Text('Unit'),
                    buildDropdownButton(
                      _fuelUnits,
                      _selectedUnit,
                      (value) => setState(() => _selectedUnit = value!),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10), // Add space
              Expanded(
                child: Column(
                  children: [
                    const Text('Currency'),
                    buildDropdownButton(
                      ['Currency 1', 'Currency 2', 'Currency 3'],
                      _selectedCurrency,
                      (value) => setState(() => _selectedCurrency = value!),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10), // Add space
              Expanded(
                child: Column(
                  children: [
                    const Text('Amount Paid'),
                    buildTextField(
                      'Amount Paid',
                      _amountPaid,
                      (value) => setState(() => _amountPaid = value),
                    ),
                  ],
                ),
              ),
              TextButton(
                child: Text("Remove"),
                onPressed: widget.onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
