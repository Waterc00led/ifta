import 'package:flutter/material.dart';
import 'package:ifta/components/fuel_receipt_input.dart';

class FieldData {
  final String title;
  final String hint;

  FieldData(this.title, this.hint);
}

class JurisdictionInput extends StatefulWidget {
  final VoidCallback onDelete;

  const JurisdictionInput({Key? key, required this.onDelete}) : super(key: key);

  @override
  _JurisdictionInputState createState() => _JurisdictionInputState();
}

class _JurisdictionInputState extends State<JurisdictionInput> {
  List<FieldData> fieldDataList = [
    FieldData('Fuel Receipt 1', 'Enter fuel receipt details'),
  ];

  void addFields() {
    setState(() {
      fieldDataList.add(FieldData('Fuel Receipt ${fieldDataList.length + 1}',
          'Enter fuel receipt details'));
    });
  }

  void removeFields(int index) {
    setState(() {
      fieldDataList.removeAt(index);
    });
  }

  Widget buildDropdownButton(List<String> items) {
    return DropdownButton<String>(
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (_) {},
    );
  }

  Widget buildTextField(String hint) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hint,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Card(
            elevation: 5,
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Country'),
                        buildDropdownButton(['USA', 'Canada', 'Mexico']),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text('State'),
                        buildDropdownButton(['State 1', 'State 2', 'State 3']),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Mileage'),
                        buildTextField('Enter mileage'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: fieldDataList.isEmpty
                ? Center(child: const Text('No Fuel Receipt Added'))
                : ListView.builder(
                    itemCount: fieldDataList.length,
                    itemBuilder: (context, index) {
                      final fieldData = fieldDataList[index];
                      return FuelReceiptInput(
                        title: fieldData.title,
                        hint: fieldData.hint,
                        onDelete: () => removeFields(index),
                      );
                    },
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: const Text('Add Fuel Receipt Input'),
                onPressed: addFields,
              ),
              ElevatedButton(
                onPressed: widget.onDelete,
                child: const Text('Remove Jurisdiction Input'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}