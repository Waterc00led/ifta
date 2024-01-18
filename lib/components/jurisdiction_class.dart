import 'package:flutter/material.dart';
import 'package:ifta/components/fuel_receipt_class.dart';

class JurisdictionClass {

  Key uniqueId;
  String country = '';
  String state = '';
  int mileage = 0;
  List<FuelReceiptClass> fuelReceiptClasses = [];

  JurisdictionClass(this.uniqueId);

  // setter and getter for uniqueId
  Key get getUniqueId => uniqueId;
  set setUniqueId(Key uniqueId) => this.uniqueId = uniqueId;

  // setter and getter for country
  String get getCountry => country;
  set setCountry(String country) => this.country = country;

  // setter and getter for state
  String get getState => state;
  set setState(String state) => this.state = state;

  // setter and getter for fuelReceiptInputs
  List<FuelReceiptClass> get getFuelReceiptInputs => fuelReceiptClasses;
  set setFuelReceiptClasses(List<FuelReceiptClass> fuelReceiptClasses) => this.fuelReceiptClasses = fuelReceiptClasses;


  // setter and getter for mileage
  int get getMileage => mileage;

  set setMileage(int mileage) {
    this.mileage = mileage;
  }

  // To JSON
  Map<String, dynamic> toJson() => {
    'mileage': mileage,
    'country': country,
    'state': state,
    'fuelReceiptInputs': fuelReceiptClasses,
  };

  void addFuelReceiptClass(FuelReceiptClass fuelReceiptClass) {

    // Check if the fuelReceiptClass already exists in the list then update it, otherwise add it
    if (fuelReceiptClasses.contains(fuelReceiptClass)) {
      int index = fuelReceiptClasses.indexOf(fuelReceiptClass);
      fuelReceiptClasses[index] = fuelReceiptClass;
    } else {
      fuelReceiptClasses.add(fuelReceiptClass);
    }
  }

  void removeFuelReceiptClass(Key uniqueId) {
    fuelReceiptClasses.removeWhere((element) => element.getUniqueId == uniqueId);
  }



}