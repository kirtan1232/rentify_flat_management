import 'package:flutter/material.dart';

class FlatListScreen extends StatelessWidget {
  const FlatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Go back to the Dashboard
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: "Search",
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Handle favorites action
            },
            icon: const Icon(
              Icons.favorite_border,
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
            const Text(
              "Found 99+ Flats",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildFlatCard(
                    imagePath: 'assets/images/room1.png',
                    location: 'Flat - Chhauni, Dallu, Swayambhu, Kathmandu',
                    price: 'Rs.20000/month',
                    description: 'Exclusive Palace Residence Apartment Type 2BHK Fully Furnished.',
                    bedrooms: 2,
                    bathrooms: 2,
                    floors: 3,
                    furnished: 'Furnished',
                  ),
                  const SizedBox(height: 16),
                  _buildFlatCard(
                    imagePath: 'assets/images/room1.png',
                    location: 'Room - Patan',
                    price: 'Rs.5000/week',
                    description: '1 BHK fully modern furnished apartment with power backup for 24hr.',
                    bedrooms: 1,
                    bathrooms: 2,
                    floors: 6,
                    furnished: 'Modern Furnished',
                  ),
                  const SizedBox(height: 16),
                  _buildFlatCard(
                    imagePath: 'assets/images/room1.png',
                    location: 'Flat - Baneshwor, Kathmandu',
                    price: 'Rs.25000/month',
                    description: 'Luxury 3BHK apartment with elevator access and 24/7 security.',
                    bedrooms: 3,
                    bathrooms: 3,
                    floors: 8,
                    furnished: 'Luxury Furnished',
                  ),
                  const SizedBox(height: 16),
                  _buildFlatCard(
                    imagePath: 'assets/images/room1.png',
                    location: 'Room - Thamel, Kathmandu',
                    price: 'Rs.8000/week',
                    description: 'Modern studio apartment, ideal for single occupancy, fully furnished.',
                    bedrooms: 1,
                    bathrooms: 1,
                    floors: 4,
                    furnished: 'Fully Furnished',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlatCard({
    required String imagePath,
    required String location,
    required String price,
    required String description,
    required int bedrooms,
    required int bathrooms,
    required int floors,
    required String furnished,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.asset(
                  imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () {
                      // Handle favorite action
                    },
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildFeatureIcon(Icons.king_bed, "$bedrooms BR"),
                    const SizedBox(width: 8),
                    _buildFeatureIcon(Icons.bathtub, "$bathrooms"),
                    const SizedBox(width: 8),
                    _buildFeatureIcon(Icons.layers, "$floors"),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        furnished,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
