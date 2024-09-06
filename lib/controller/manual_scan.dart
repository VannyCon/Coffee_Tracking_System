import 'package:coffee_tracker/plugins/plant_info.dart';
import 'package:flutter/material.dart';

class PlantManual extends StatefulWidget {
  final ThemeData? theme;

  const PlantManual({Key? key, required this.theme}) : super(key: key);

  @override
  State<PlantManual> createState() => _PlantManualState();
}

class _PlantManualState extends State<PlantManual> {
  final TextEditingController _plantIdController = TextEditingController();

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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manual Search',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: widget.theme!.colorScheme.onBackground),
                      ),
                      Text(
                        'Input here!',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w200,
                            color: widget.theme!.colorScheme.onBackground),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _plantIdController,
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
                  color: widget
                      .theme!.colorScheme.secondary, // Set your text color here
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    PlantInfo.showInputDialog(
                      context,
                      _plantIdController.text.trim(),
                      'plantID',
                      widget.theme!,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.theme!.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Adjust the radius here
                    ),
                  ),
                  child: Text(
                    'Search',
                    style: TextStyle(
                        fontSize: 18,
                        color: widget.theme!.colorScheme.background),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
