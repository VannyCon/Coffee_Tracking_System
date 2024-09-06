import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_tracker/service/service.dart';
import 'package:flutter/material.dart';

class PlantInfo {
  // Change return type to Future<DocumentSnapshot<Object?>>?
  static Future<DocumentSnapshot<Object?>?> _fetchPlantData(
      String plantId, String type) async {
    CoffeeTrackerService service = CoffeeTrackerService();

    if (type == 'plantID') {
      return await service.getPlantById(plantId);
    } else if (type == 'rfid') {
      return await service.getPlantByRFID(plantId);
    } else {
      throw ArgumentError('Invalid type: $type');
    }
  }

  static void showInputDialog(
      BuildContext context, String plantId, String type, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<DocumentSnapshot<Object?>?>(
          future: _fetchPlantData(plantId, type),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AlertDialog(
                backgroundColor: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                title: Text(
                  'Plant Details',
                  style: TextStyle(color: theme.colorScheme.onBackground),
                ),
                content: Center(
                  child: CircularProgressIndicator(),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color(0xFFEFF0FA),
                            backgroundColor: Color(0xFFEE3A57),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                backgroundColor: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                title: Text(
                  'Error',
                  style: TextStyle(color: theme.colorScheme.onBackground),
                ),
                content: Text(
                  'An error occurred: ${snapshot.error}',
                  style: TextStyle(color: theme.colorScheme.onBackground),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color(0xFFEFF0FA),
                            backgroundColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              DocumentSnapshot<Object?> plantDoc = snapshot.data!;
              if (plantDoc.exists) {
                Map<String, dynamic> plantData =
                    plantDoc.data() as Map<String, dynamic>;
                String plantDetails = 'No plant found with ID: $plantId';
                if (plantData.isNotEmpty) {
                  plantDetails = 'Plant ID: ${plantData['Plant_ID']}\n'
                      'Plant Type: ${plantData['Plant_Type']}\n'
                      'Planted Date: ${plantData['Planted_Date']}\n'
                      'RFID: ${plantData['RFID']}\n'
                      'Plant From: ${plantData['Plant_From']}';
                }
                return AlertDialog(
                  backgroundColor: theme.colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  title: Text(
                    'Plant Details',
                    style: TextStyle(
                        color: theme.colorScheme.onBackground,
                        fontWeight: FontWeight.w800),
                  ),
                  content: Text(
                    plantDetails,
                    style: TextStyle(color: theme.colorScheme.onBackground),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Color(0xFFEFF0FA),
                              backgroundColor: theme.colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return AlertDialog(
                  backgroundColor: theme.colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  title: Text(
                    'No Data',
                    style: TextStyle(
                        color: theme.colorScheme.onBackground,
                        fontWeight: FontWeight.w800),
                  ),
                  content: Text(
                    'No plant data found.',
                    style: TextStyle(color: theme.colorScheme.onBackground),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Color(0xFFEFF0FA),
                              backgroundColor: Color(0xFFEE3A57),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            } else {
              return AlertDialog(
                backgroundColor: theme.colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                title: Text(
                  'No Data',
                  style: TextStyle(
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.w800),
                ),
                content: Text(
                  'No plant data found.',
                  style: TextStyle(color: theme.colorScheme.onBackground),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color(0xFFEFF0FA),
                            backgroundColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }
}
