import 'dart:io';

import 'package:coffee_tracker/plugins/success.dart';
import 'package:coffee_tracker/service/service.dart';
import 'package:coffee_tracker/view/choose_scanner.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting
import 'package:image/image.dart' as img;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class EncodePage extends StatefulWidget {
  final ThemeData? theme;

  const EncodePage({Key? key, required this.theme}) : super(key: key);
  @override
  _EncodePageState createState() => _EncodePageState();
}

class _EncodePageState extends State<EncodePage> {
  final TextEditingController _plantFromController = TextEditingController();
  final TextEditingController _plantIDController = TextEditingController();
  final TextEditingController _plantTypeController = TextEditingController();
  final TextEditingController _plantedDateController = TextEditingController();
  final TextEditingController _rfidController = TextEditingController();

  final CoffeeTrackerService coffeeTrackerService = CoffeeTrackerService();

  Future<void> _addPlant() async {
    await coffeeTrackerService.addPlant(
        context: context,
        plantFrom: _plantFromController.text,
        plantType: _plantTypeController.text,
        plantedDate: _plantedDateController.text,
        rfid: _rfidController.text,
        timestamp: Timestamp.now(),
        theme: widget.theme!);
    _clearTextFields();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _plantedDateController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _clearTextFields() {
    _plantFromController.clear();
    _plantIDController.clear();
    _plantTypeController.clear();
    _plantedDateController.clear();
    _rfidController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.theme!,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: widget.theme!.colorScheme.background,
          iconTheme:
              IconThemeData(color: widget.theme!.colorScheme.onBackground),
        ),
        backgroundColor: widget.theme!.colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Encode New Plant',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: widget.theme!.colorScheme.onBackground),
                  ),
                  Text(
                    'Fill the InputBox',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                        color: widget.theme!.colorScheme.onBackground),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Plant From',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: widget.theme!.colorScheme.onBackground),
                  ),
                  TextField(
                    controller: _plantFromController,
                    decoration: InputDecoration(
                      hintText: 'Plant From',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 14,
                        color: widget.theme!.colorScheme
                            .secondary, // Set your hint text color here
                      ),
                      filled: true,
                      fillColor: widget.theme!.colorScheme.onBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      color: widget.theme!.colorScheme
                          .secondary, // Set your text color here
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Plant Type',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: widget.theme!.colorScheme.onBackground),
                  ),
                  TextField(
                    controller: _plantTypeController,
                    decoration: InputDecoration(
                      hintText: 'Plant Type',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 14,
                        color: widget.theme!.colorScheme
                            .secondary, // Set your hint text color hereS
                      ),
                      filled: true,
                      fillColor: widget.theme!.colorScheme.onBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      color: widget.theme!.colorScheme
                          .secondary, // Set your text color here
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Date Planted',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: widget.theme!.colorScheme.onBackground),
                  ),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _plantedDateController,
                        decoration: InputDecoration(
                          hintText: 'Planted Date',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w200,
                            color: widget.theme!.colorScheme
                                .secondary, // Set your hint text color here
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: widget.theme!.colorScheme.onBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                          color: widget.theme!.colorScheme
                              .secondary, // Set your text color here
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Rfid',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: widget.theme!.colorScheme.onBackground),
                  ),
                  TextField(
                    controller: _rfidController,
                    decoration: InputDecoration(
                      hintText: 'RFID',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 14,
                        color: widget.theme!.colorScheme
                            .secondary, // Set your hint text color here
                      ),
                      filled: true,
                      fillColor: widget.theme!.colorScheme.onBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      color: widget.theme!.colorScheme
                          .secondary, // Set your text color here
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.theme!.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust the radius here
                        ),
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(
                            fontSize: 18,
                            color: widget.theme!.colorScheme.background),
                      ),
                      onPressed: _addPlant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
