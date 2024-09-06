import 'package:coffee_tracker/service/service.dart';
import 'package:coffee_tracker/view/choose_scanner.dart';
import 'package:coffee_tracker/view/plants.dart';
import 'package:flutter/material.dart';
import 'package:coffee_tracker/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDarkMode = false;
  CoffeeTrackerService coffeeTrackerService = CoffeeTrackerService();
  int totalPlants = 0;
  int totalVariants = 0;
  int plantsPlantedThisYear = 0;
  int plantsPlantedThisMonth = 0;

  @override
  void initState() {
    super.initState();
    _getData();
    _loadDarkModeStatus();
  }

  Future<void> _getData() async {
    totalPlants = await coffeeTrackerService.getTotalPlants();
    totalVariants = await coffeeTrackerService.getTotalVariants();
    plantsPlantedThisYear =
        await coffeeTrackerService.getPlantsPlantedThisYear();
    plantsPlantedThisMonth =
        await coffeeTrackerService.getPlantsPlantedThisMonth();
    setState(() {}); // Update the UI after data is fetched
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      _saveDarkModeStatus(_isDarkMode);
    });
  }

  Future<void> _loadDarkModeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? true;
    });
  }

  Future<void> _saveDarkModeStatus(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = _isDarkMode
        ? MyColorSchemes.darkModeScheme
        : MyColorSchemes.lightModeScheme;

    return AnimatedTheme(
      duration: const Duration(milliseconds: 500),
      data: Theme.of(context).copyWith(colorScheme: colorScheme),
      child: Builder(builder: (BuildContext context) {
        final theme = Theme.of(context);
        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: _toggleDarkMode,
                        icon: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Icon(
                            _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        widthFactor: double.infinity,
                        child: Image.asset(
                          'assets/images/coffee_ts_icon.png',
                          height: 150,
                          width: 150,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          children: [
                            _buildInfoCard(
                                '$totalPlants', 'Total Plant', theme),
                            _buildInfoCard(
                                '$totalVariants', 'Total Variant', theme),
                            _buildInfoCard('$plantsPlantedThisYear',
                                'Planted this Year', theme),
                            _buildInfoCard('$plantsPlantedThisMonth',
                                'Planted this Month', theme),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 60, // Adjust this value as needed
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorScheme.primary,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChooseScanner(
                                          theme: Theme.of(context).copyWith(
                                              colorScheme: colorScheme),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Scan',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: theme.colorScheme.background,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  height:
                                      10), // Increased spacing between buttons
                              SizedBox(
                                width: double.infinity,
                                height: 60, // Adjust this value as needed
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    elevation: 0,
                                    side: BorderSide(
                                        color: theme.colorScheme.primary,
                                        width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PlantsPage(
                                                theme: Theme.of(context)
                                                    .copyWith(
                                                        colorScheme:
                                                            colorScheme),
                                              )),
                                    );
                                  },
                                  child: Text(
                                    'Plants',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(String number, String label, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: theme.colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            'Updated',
            style: TextStyle(
              fontSize: 10,
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
