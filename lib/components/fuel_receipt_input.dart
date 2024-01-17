import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ifta/components/fuel_receipt_class.dart';
import 'package:ifta/user_preferences.dart';
import 'dart:convert';

class FuelReceiptInput extends StatefulWidget {
  final FuelReceiptClass fuelReceiptClass = FuelReceiptClass(UniqueKey());
  final Function(FuelReceiptClass fuelReceiptClass) onDelete;
  final Function(FuelReceiptClass fuelReceiptClass) onValuesChanged;

  FuelReceiptInput({Key? key, required this.onDelete, required this.onValuesChanged}) : super(key: key) {
    fuelReceiptClass.setUniqueId = key!;
  }

  @override
  _FuelReceiptInputState createState() => _FuelReceiptInputState();
}

class _FuelReceiptInputState extends State<FuelReceiptInput> {
  String _selectedFuelType = 'Fuel Type 1';
  String _selectedUnit = 'Unit 1';
  String _selectedCurrency = 'Currency 1';
  int _volume = 0;
  double _amountPaid = 0.0;
  List<String> _fuelTypes = [];
  List<String> _fuelUnits = [];
  List<String> _currencies = [];

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

    String fuelTypeString = fuelReceiptValues['FuelType'].toString();
    List<String> fuelTypePairs =
        fuelTypeString.substring(1, fuelTypeString.length - 1).split(', ');
    List<String> fuelTypes = fuelTypePairs.map((pair) {
      return pair.split(':')[1]; // Split the pair and return the key  
    }).toList();

    String fuelUnitString = fuelReceiptValues['FuelUnit'].toString();
    List<String> fuelUnitKeyPAir =
        fuelUnitString.substring(1, fuelUnitString.length - 1).split(', ');
    List<String> fuelUnits = fuelUnitKeyPAir.map((pair) {
      return pair.split(':')[1]; // Split the pair and return the key
    }).toList();

    String currenciesString = fuelReceiptValues['Currency'].toString();
    List<String> currenciesKeyPair =
        currenciesString.substring(1, currenciesString.length - 1).split(', ');
    List<String> currencies = currenciesKeyPair.map((pair) {
      return pair.split(':')[1]; // Split the pair and return the key
    }).toList();

    setState(() {
      _fuelTypes = fuelTypes;
      _fuelUnits = fuelUnits;
      _currencies = currencies;
      _selectedFuelType = _fuelTypes[0];
      _selectedUnit = _fuelUnits[0];
      _selectedCurrency = _currencies[0];
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

  void _handleFuelTypeChanged(String value) {
    setState(() {
      _selectedFuelType = value;
    });
    widget.fuelReceiptClass.setFuelType = _selectedFuelType;
    widget.onValuesChanged(widget.fuelReceiptClass);
  }

  void _handleUnitChanged(String value) {
    setState(() {
      _selectedUnit = value;
    });
    widget.fuelReceiptClass.setFuelUnit = _selectedUnit;
    widget.onValuesChanged(widget.fuelReceiptClass);
  }


  void _handleCurrencyChanged(String value) {
    setState(() {
      _selectedCurrency = value;
    });
    widget.fuelReceiptClass.setCurrency = _selectedCurrency;
    widget.onValuesChanged(widget.fuelReceiptClass);
  }

  void _handleVolumeChanged(int value) {
    setState(() {
      _volume = value;
    });
    widget.fuelReceiptClass.setVolume = _volume;
    widget.onValuesChanged(widget.fuelReceiptClass);
  }

  void _handleAmountChnge(double value) {
    setState(() {
      _amountPaid = value;
    });
    widget.fuelReceiptClass.setTotalAmount = _amountPaid;
    widget.onValuesChanged(widget.fuelReceiptClass);
  }


  @override
  void initState() {
    super.initState();
    UserPreferences.getIftaValues().then((response) {
      assignValuesToDropdowns(response??"");
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
                    TextField(
                      onChanged: (value) =>
                          _handleVolumeChanged(int.parse(value)),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter volume',
                      ),
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
                      _currencies,
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
                    TextField(
                      onChanged: (value) =>
                          _handleAmountChnge(double.parse(value)),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter amount',
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                child: const Text("Remove"),
                onPressed: () => widget.onDelete(widget.fuelReceiptClass),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
