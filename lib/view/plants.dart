import 'package:coffee_tracker/service/service.dart';
import 'package:coffee_tracker/view/encode_plants.dart';
import 'package:coffee_tracker/view/homepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PlantsPage extends StatefulWidget {
  final ThemeData? theme;

  const PlantsPage({Key? key, required this.theme}) : super(key: key);
  @override
  _PlantsPageState createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _plantFromController = TextEditingController();
  final TextEditingController _plantIDController = TextEditingController();
  final TextEditingController _plantTypeController = TextEditingController();
  final TextEditingController _plantedDateController = TextEditingController();
  final TextEditingController _rfidController = TextEditingController();

  final CoffeeTrackerService coffeeTrackerService = CoffeeTrackerService();

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

  Future<void> _updatePlant(DocumentSnapshot documentSnapshot) async {
    _plantFromController.text = documentSnapshot['Plant_From'];
    _plantTypeController.text = documentSnapshot['Plant_Type'];
    _plantedDateController.text = documentSnapshot['Planted_Date'];
    _rfidController.text = documentSnapshot['RFID'];

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.theme!.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        title: Text(
          'Update Plant',
          style: TextStyle(color: widget.theme!.colorScheme.onBackground),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 3,
            ),
            Text(
              'Plant Type',
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
                color: widget
                    .theme!.colorScheme.secondary, // Set your text color here
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              'Plant From',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: widget.theme!.colorScheme.onBackground),
            ),
            TextField(
              controller: _plantTypeController,
              decoration: InputDecoration(
                hintText: 'Plant From',
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
                color: widget
                    .theme!.colorScheme.secondary, // Set your text color here
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              'Planted Date',
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
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              'RFID',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: widget.theme!.colorScheme.onBackground),
            ),
            TextField(
              controller: _rfidController,
              decoration: InputDecoration(
                hintText: 'Rfid',
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
                color: widget
                    .theme!.colorScheme.secondary, // Set your text color here
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await coffeeTrackerService.updatePlant(
                      documentSnapshot.id,
                      plantFrom: _plantFromController.text,
                      plantType: _plantTypeController.text,
                      plantedDate: _plantedDateController.text,
                      rfid: _rfidController.text,
                      timestamp: documentSnapshot['Time_Stamp'],
                    );
                    _clearTextFields();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xFFEFF0FA),
                    backgroundColor: widget.theme!.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10), // Add spacing between the buttons
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xFFEFF0FA),
                    backgroundColor: widget.theme!.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _deletePlant(String plantId) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.theme!.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        title: Text(
          'Delete Plant',
          style: TextStyle(
              color: widget.theme!.colorScheme.onBackground,
              fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete this plant?',
          style: TextStyle(
              color: widget.theme!.colorScheme.onBackground, fontSize: 15),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(true); // Confirm deletion
              await coffeeTrackerService.deletePlant(plantId);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Color(0xFFEFF0FA),
              backgroundColor: widget.theme!.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Delete',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel deletion
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: widget.theme!.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed) {
      await coffeeTrackerService.deletePlant(plantId);
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return false; // Prevent default behavior
      },
      child: Theme(
        data: widget.theme!,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: widget.theme!.colorScheme.background,
            iconTheme:
                IconThemeData(color: widget.theme!.colorScheme.onBackground),
          ),
          backgroundColor: widget.theme!.colorScheme.background,
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plant List',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: widget.theme!.colorScheme.onBackground),
                        ),
                        Text(
                          'Search here!',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w200,
                              color: widget.theme!.colorScheme.onBackground),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.theme!.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              5), // Adjust the radius here
                        ),
                      ),
                      onPressed: () {
                        // Handle plants action
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EncodePage(
                                  theme: Theme.of(context).copyWith(
                                      colorScheme: widget.theme!.colorScheme))),
                        );
                      },
                      child: Icon(
                        Icons.add,
                        color: widget.theme!.colorScheme.onBackground,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Here!',
                      hintStyle: TextStyle(
                        color: widget.theme!.colorScheme
                            .secondary, // Set your hint text color here
                      ),
                      filled: true,
                      fillColor: widget.theme!.colorScheme.onBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search,
                          color: widget.theme!.colorScheme.primary),
                    ),
                    style: TextStyle(
                      color: widget.theme!.colorScheme
                          .secondary, // Set your text color here
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: coffeeTrackerService.getPlants(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            width: 50,
                            height: 50,
                            child: const CircularProgressIndicator());
                      }
                      final data = snapshot.requireData;
                      return ListView.builder(
                        itemCount: data.size,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.theme!.colorScheme
                                    .secondary, // Background color
                                borderRadius:
                                    BorderRadius.circular(10), // Border radius
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.2), // Shadow color
                                    blurRadius: 5, // Shadow blur
                                    offset: Offset(0, 3), // Shadow position
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: Icon(
                                  Icons.qr_code_rounded,
                                  size: 40,
                                  color: widget.theme!.colorScheme.primary,
                                ),
                                title: Text(
                                  data.docs[index]['Plant_ID'],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: widget
                                          .theme!.colorScheme.onBackground),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.type_specimen,
                                          color: widget
                                              .theme!.colorScheme.tertiary,
                                          size: 12,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          data.docs[index]['Plant_Type'],
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: widget.theme!.colorScheme
                                                  .onBackground),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.date_range_outlined,
                                          color: widget
                                              .theme!.colorScheme.tertiary,
                                          size: 12,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          data.docs[index]['Planted_Date'],
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: widget.theme!.colorScheme
                                                  .onBackground),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.gps_fixed,
                                          color: widget
                                              .theme!.colorScheme.tertiary,
                                          size: 12,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          data.docs[index]['Plant_From'],
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: widget.theme!.colorScheme
                                                  .onBackground),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: widget
                                            .theme!.colorScheme.onSecondary,
                                      ),
                                      onPressed: () =>
                                          _updatePlant(data.docs[index]),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: widget.theme!.colorScheme.error,
                                      ),
                                      onPressed: () =>
                                          _deletePlant(data.docs[index].id),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
