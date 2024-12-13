import 'package:flutter/material.dart';
import 'package:rentify_flat_management/view/search_view.dart'; // Make sure to import your FlatListScreen

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: null,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Add your logo here
                Image.asset(
                  'assets/images/logo.png', // Replace with your logo path
                  height: 30, // Adjust the size of the logo
                  width: 30,
                ),
                const SizedBox(width: 8), // Add some space between logo and text
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
                // Navigate to Find Room/Flat screen
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
              onPressed: () {
                // Navigate to Enter Owner ID screen
              },
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
