import 'package:flutter/material.dart';
import '../modal/modals.dart';
import '../views/cart_page.dart';
import '../views/profile_page.dart';
// Ensure this file contains the Product class

class DrawerPage extends StatelessWidget {
  final BuildContext context;
  final List<Product> products;
  final Map<int, int> quantities;

  const DrawerPage({
    super.key,
    required this.context,
    required this.products,
    required this.quantities,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Header with background image
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.greenAccent,
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 38,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Priyam Tripathi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'priyamtripathiii03@gmail.com',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to profile edit
                          },
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Edit Profile'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white24,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            textStyle: const TextStyle(fontSize: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(Icons.home, 'Home', () {
                    Navigator.pop(context);
                  }),
                  _buildDrawerItem(Icons.person, 'Profile', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProfilePage()),
                    );
                  }),
                  _buildDrawerItem(Icons.shopping_bag_outlined, 'My Orders', () {
                    Navigator.pop(context);
                    // Navigate to orders page
                  }),
                  _buildDrawerItem(Icons.favorite_border, 'Wishlist', () {
                    Navigator.pop(context);
                    // Navigate to wishlist page
                  }),
                  ListTile(
                    leading: Stack(
                      children: [
                        const Icon(Icons.shopping_cart_outlined, color: Colors.green),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: const Text(
                              '3',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: const Text('Cart'),
                    onTap: () {
                      List<Product> selectedProducts = [];
                      Map<int, int> selectedQuantities = {};

                      quantities.forEach((index, qty) {
                        if (qty > 0) {
                          selectedProducts.add(products[index]);
                          selectedQuantities[selectedProducts.length - 1] = qty;
                        }
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CartPage(
                            cartProducts: selectedProducts,
                            quantities: selectedQuantities,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(Icons.category_outlined, 'Categories', () {
                    Navigator.pop(context);
                  }),
                  _buildDrawerItem(Icons.local_offer_outlined, 'Offers & Deals', () {
                    Navigator.pop(context);
                  }),
                  _buildDrawerItem(Icons.support_agent_outlined, 'Help & Support', () {
                    Navigator.pop(context);
                  }),
                  const Divider(),
                  _buildDrawerItem(Icons.settings_outlined, 'Settings', () {
                    // Settings
                  }),
                  _buildDrawerItem(Icons.logout, 'Logout', () {
                    // Logout
                  }),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: const Text(
                'Made With ❤️ by Priyam Tripathi',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      onTap: onTap,
    );
  }
}
