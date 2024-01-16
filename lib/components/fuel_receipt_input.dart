import 'package:flutter/material.dart';

class FuelReceiptInput extends StatelessWidget {
  final VoidCallback onDelete;

  FuelReceiptInput({Key? key, required this.onDelete}) : super(key: key);

  DropdownButton<String> buildDropdownButton(List<String> items) {
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

  TextField buildTextField(String hint) {
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
                    buildDropdownButton(['Fuel Type 1', 'Fuel Type 2', 'Fuel Type 3']),
                  ],
                ),
              ),
              const SizedBox(width: 10), // Add space
              Expanded(
                child: Column(
                  children: [
                    const Text('Volume'),
                    buildTextField('Volume'),
                  ],
                ),
              ),
              const SizedBox(width: 10), // Add space
              Expanded(
                child: Column(
                  children: [
                    const Text('Unit'),
                    buildDropdownButton(['Unit 1', 'Unit 2', 'Unit 3']),
                  ],
                ),
              ),
              const SizedBox(width: 10), // Add space
              Expanded(
                child: Column(
                  children: [
                    const Text('Currency'),
                    buildDropdownButton(['Currency 1', 'Currency 2', 'Currency 3']),
                  ],
                ),
              ),
              const SizedBox(width: 10), // Add space
              Expanded(
                child: Column(
                  children: [
                    const Text('Amount Paid'),
                    buildTextField('Amount Paid'),
                  ],
                ),
              ),
              TextButton(
                child: Text("Remove"),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}