import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_tracker/plugins/success.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class CoffeeTrackerService {
  late final int yearNOW;
  late final String monthNOW;
  late final CollectionReference coffeeCollection;
  late final CollectionReference totalPlants;
  DateTime now = DateTime.now();

  CoffeeTrackerService() {
    yearNOW = now.year;
    monthNOW = getCurrentMonth();
    coffeeCollection = FirebaseFirestore.instance
        .collection('coffeetracker-database')
        .doc(yearNOW.toString())
        .collection(monthNOW);
  }

  // Function to get the total number of plants
  Future<int> getTotalPlants() async {
    QuerySnapshot snapshot = await coffeeCollection.get();
    return snapshot.docs.length;
  }

  // Function to get the total number of different plant variants
  Future<int> getTotalVariants() async {
    QuerySnapshot snapshot = await coffeeCollection.get();
    Set<String> uniqueVariants = {};
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      uniqueVariants.add(doc.get('Plant_Type'));
    }
    return uniqueVariants.length;
  }

  Future<int> getPlantsPlantedThisYear() async {
    QuerySnapshot snapshot = await coffeeCollection.get();
    int count = 0;
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      String dateString = doc.get('Planted_Date');
      DateTime plantedDate = DateFormat('yyyy-MM-dd').parse(dateString);
      if (plantedDate.year == now.year) {
        count++;
      }
    }
    return count;
  }

  Future<int> getPlantsPlantedThisMonth() async {
    QuerySnapshot snapshot = await coffeeCollection.get();
    int count = 0;
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      String dateString = doc.get('Planted_Date');
      DateTime plantedDate = DateFormat('yyyy-MM-dd').parse(dateString);
      if (plantedDate.year == now.year && plantedDate.month == now.month) {
        count++;
      }
    }
    return count;
  }

  // Function to get the current month in words
  String getCurrentMonth() {
    return _getMonthInWords(now.month);
  }

// Helper function to convert month number to month name
  String _getMonthInWords(int month) {
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1]; // Month is 1-based index
  }

  String generateCustomId() {
    // Assuming `now` is a DateTime object
    String formattedDate = DateFormat('MMddyyyyhhmmss').format(now);
    String amPm = now.hour >= 12 ? 'P' : 'A';
    return '$formattedDate$amPm';
  }

  // Function to add a plant with a newly generated ID
  Future<DocumentReference<Object?>> addPlant(
      {required BuildContext context,
      required String plantFrom,
      required String plantType,
      required String plantedDate,
      required String rfid,
      required Timestamp timestamp,
      required ThemeData theme}) async {
    String plantID = generateCustomId();

    PlantEncoded.showSuccesDialog(context, plantID, theme);

    return await coffeeCollection.add({
      'Plant_From': plantFrom,
      'Plant_ID': plantID,
      'Plant_Type': plantType,
      'Planted_Date': plantedDate,
      'RFID': rfid,
      'Time_Stamp': timestamp,
    });
  }

  Future<void> updatePlant(
    String id, {
    required String plantFrom,
    required String plantType,
    required String plantedDate,
    required String rfid,
    required Timestamp timestamp,
  }) async {
    return await coffeeCollection.doc(id).update({
      'Plant_From': plantFrom,
      'Plant_Type': plantType,
      'Planted_Date': plantedDate,
      'RFID': rfid,
      'Time_Stamp': timestamp,
    });
  }

  Future<void> deletePlant(String id) async {
    return await coffeeCollection.doc(id).delete();
  }

  Stream<QuerySnapshot> getPlants() {
    return coffeeCollection.snapshots();
  }

  Future<DocumentSnapshot?> getPlantById(String plantId) async {
    try {
      // Query the collection where the 'Plant_ID' field matches the given ID
      QuerySnapshot querySnapshot =
          await coffeeCollection.where('Plant_ID', isEqualTo: plantId).get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first; // Return the first matching document
      } else {
        return null; // No document found with the given ID
      }
    } catch (e) {
      print('Error getting plant by ID: $e');
      return null; // Return null in case of error
    }
  }

  Future<DocumentSnapshot?> getPlantByRFID(String rfid) async {
    try {
      // Query the collection where the 'Plant_ID' field matches the given ID
      QuerySnapshot querySnapshot =
          await coffeeCollection.where('Rfid', isEqualTo: rfid).get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first; // Return the first matching document
      } else {
        return null; // No document found with the given ID
      }
    } catch (e) {
      print('Error getting plant by ID: $e');
      return null; // Return null in case of error
    }
  }
}
