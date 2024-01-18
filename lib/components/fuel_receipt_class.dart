import 'package:flutter/material.dart';

class FuelReceiptClass {

  Key uniqueId;
  String fuelType = '';
  int volume = 0;
  String fuelUnit = '';
  String currency = '';
  double totalAmount = 0.0;

  FuelReceiptClass(this.uniqueId);

  // setter and getter for uniqueId
  Key get getUniqueId => uniqueId;
  set setUniqueId(Key uniqueId) => this.uniqueId = uniqueId;

  // setter and getter for fuelType
  String get getFuelType => fuelType;
  set setFuelType(String fuelType) => this.fuelType = fuelType;

  // setter and getter for volume
  int get getVolume => volume;
  set setVolume(int volume) => this.volume = volume;

  // setter and getter for fuelUnit
  String get getFuelUnit => fuelUnit;
  set setFuelUnit(String fuelUnit) => this.fuelUnit = fuelUnit;

  // setter and getter for currency
  String get getCurrency => currency;
  set setCurrency(String currency) => this.currency = currency;

  // setter and getter for totalAmount
  double get getTotalAmount => totalAmount;
  set setTotalAmount(double totalAmount) => this.totalAmount = totalAmount;

  // To JSON

  Map<String, dynamic> toJson() => {
    'fuelType': fuelType,
    'volume': volume,
    'fuelUnit': fuelUnit,
    'currency': currency,
    'totalAmount': totalAmount,
  };
}