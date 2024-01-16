import 'package:flutter/material.dart';

class FuelReceiptInput extends StatelessWidget {
  final String title;
  final String hint;
  final VoidCallback onDelete;

  FuelReceiptInput(
      {required this.title, required this.hint, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('Fuel Type'),
                    DropdownButton<String>(
                      items: <String>[
                        'Fuel Type 1',
                        'Fuel Type 2',
                        'Fuel Type 3'
                      ].map((String value) {
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
              Expanded(
                child: Column(
                  children: [
                    Text('Volume'),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Volume',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('Unit'),
                    DropdownButton<String>(
                      items: <String>['Unit 1', 'Unit 2', 'Unit 3']
                          .map((String value) {
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
              Expanded(
                child: Column(
                  children: [
                    Text('Currency'),
                    DropdownButton<String>(
                      items: <String>['Currency 1', 'Currency 2', 'Currency 3']
                          .map((String value) {
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
              Expanded(
                child: Column(
                  children: [
                    Text('Amount Paid'),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Amount Paid',
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
