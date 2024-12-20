import 'package:flutter/material.dart';
import 'package:rentify_flat_management/view/bar_code_view.dart';
import 'package:rentify_flat_management/view/notifcation_view.dart';
import 'package:rentify_flat_management/view/search_view.dart';
import 'package:rentify_flat_management/view/settings_view.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0; // The selected index for BottomNavigationBar
  bool isSearchIconClicked =
      false; // Add this variable to track search icon state

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on the selected index
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FlatListScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BarCodeView()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NotifcationView()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SettingsView()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // Remove the back button
        actions: [
          // Search icon with color change functionality
          IconButton(
            onPressed: () {
              setState(() {
                isSearchIconClicked =
                    !isSearchIconClicked; // Toggle search icon state
                _selectedIndex =
                    1; // Update BottomNavigationBar to select the "Search" tab
              });
            },
            icon: Icon(
              Icons.search,
              color: isSearchIconClicked
                  ? Colors.green
                  : Colors.black, // Change color based on state
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "My Dormitory",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "You haven’t rented yet",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Let’s go, enter the code from the dormitory owner to activate this page! Try a modern way of dormitory with the following benefits.",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      const ListTile(
                        leading: Icon(
                          Icons.receipt_long,
                          size: 32,
                          color: Colors.black,
                        ),
                        title: Text(
                          "Bills and rental contracts are neatly recorded",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      const ListTile(
                        leading: Icon(
                          Icons.security,
                          size: 32,
                          color: Colors.black,
                        ),
                        title: Text(
                          "Rentify keeps transactions safe",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      const ListTile(
                        leading: Icon(
                          Icons.attach_money,
                          size: 32,
                          color: Colors.black,
                        ),
                        title: Text(
                          "Cashless, with various payment methods",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1; // Set index to "Search"
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FlatListScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          "Find Room/Flat",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          "Enter Owner ID",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: "Scan QR",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
