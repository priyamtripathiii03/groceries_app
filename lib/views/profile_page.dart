import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String name = "Priyam Tripathi";
  final String phoneNumber = "9106909125";
  final String username = "priyamtripathi262khodiyarnagar";
  final String email = "priyamtripathiii03@gmail.com";
  final String location = "Surat, Gujarat";
  final String bio = "Flutter Developer | Passionate Coder | Tech Enthusiast 💻✨";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.8,
        title: Text(
          "My Profile",
          style: TextStyle(
            color: Colors.green.shade800,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.green.shade800),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => print("Settings Clicked"),
            tooltip: 'Settings',
            color: Colors.green.shade800,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture & Info
            CircleAvatar(
              radius: 65,
              backgroundColor: Colors.green.shade100,
              backgroundImage: NetworkImage("https://www.w3schools.com/w3images/avatar2.png"),
            ),
            SizedBox(height: 15),
            Text(
              name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade900,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '@$username',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            // Membership Badge or Status
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade700.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.green.shade700, size: 18),
                  SizedBox(width: 6),
                  Text(
                    "Gold Member",
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                bio,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                  height: 1.4,
                ),
              ),
            ),

            SizedBox(height: 30),

            // Orders Summary Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn("Orders", "125", Icons.shopping_bag),
                    _buildStatColumn("Wishlist", "35", Icons.favorite),
                    _buildStatColumn("Reviews", "48", Icons.rate_review),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // Recent Orders Section
            _sectionTitle("Recent Orders"),
            SizedBox(height: 10),
            _recentOrderCard("Order #5432", "Delivered", "Apr 25, 2025"),
            _recentOrderCard("Order #5399", "Processing", "Apr 20, 2025"),
            _recentOrderCard("Order #5356", "Cancelled", "Apr 18, 2025"),

            SizedBox(height: 30),

            // Contact Info Card
            _sectionTitle("Contact Information"),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                child: Column(
                  children: [
                    _infoTile(Icons.phone, "Phone", phoneNumber),
                    Divider(height: 30, thickness: 1),
                    _infoTile(Icons.email, "Email", email),
                    Divider(height: 30, thickness: 1),
                    _infoTile(Icons.location_on, "Location", location),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // Shipping Addresses Card
            _sectionTitle("Shipping Addresses"),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    _addressTile(
                      Icons.home,
                      "Home",
                      "Surat, Gujarat",
                      "123, Main Street, Khodiyarnagar",
                    ),
                    Divider(height: 25, thickness: 1),
                    _addressTile(
                      Icons.work,
                      "Work",
                      "Surat",
                      "456, Business Park",
                    ),
                    SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () => print("Add Address"),
                      icon: Icon(Icons.add_location_alt_outlined, color: Colors.green.shade700),
                      label: Text("Add Address", style: TextStyle(color: Colors.green.shade700)),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 40),

            // Action Buttons Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => print("Edit Profile Clicked"),
                    icon: Icon(Icons.edit, size: 20),
                    label: Text("Edit Profile", style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => print("View Orders Clicked"),
                    icon: Icon(Icons.shopping_bag, size: 20, color: Colors.green.shade700),
                    label: Text("View Orders", style: TextStyle(fontSize: 16, color: Colors.green.shade700)),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      side: BorderSide(color: Colors.green.shade700),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          color: Colors.green.shade900,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStatColumn(String title, String count, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.green.shade100,
          child: Icon(icon, color: Colors.green.shade800, size: 28),
        ),
        SizedBox(height: 6),
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade800,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(icon, color: Colors.green.shade800),
          radius: 22,
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentMethodTile(String type, String lastDigits) {
    return ListTile(
      leading: Icon(Icons.credit_card, color: Colors.green.shade700),
      title: Text("$type $lastDigits", style: TextStyle(fontWeight: FontWeight.w600)),
      trailing: Icon(Icons.edit, color: Colors.grey.shade600),
      onTap: () => print("Edit Payment Method"),
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  Widget _addressTile(IconData icon, String title, String city, String address) {
    return ListTile(
      leading: Icon(icon, color: Colors.green.shade700),
      title: Text("$title - $city", style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(address),
      trailing: Icon(Icons.edit, color: Colors.grey.shade600),
      onTap: () => print("Edit Address"),
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  Widget _recentOrderCard(String orderNumber, String status, String date) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'delivered':
        statusColor = Colors.green.shade700;
        break;
      case 'processing':
        statusColor = Colors.orange.shade700;
        break;
      case 'cancelled':
        statusColor = Colors.red.shade700;
        break;
      default:
        statusColor = Colors.grey.shade700;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        leading: Icon(Icons.shopping_bag, color: Colors.green.shade700, size: 30),
        title: Text(orderNumber, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
