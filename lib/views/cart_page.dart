import 'package:flutter/material.dart';
import 'package:groceries_app/modal/modals.dart'; // where Product is defined

class CartPage extends StatefulWidget {
  final List<Product> cartProducts;
  final Map<int, int> quantities; // key: product.id, value: quantity

  CartPage({required this.cartProducts, required this.quantities});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Product> products;
  late Map<int, int> quantities;

  @override
  void initState() {
    super.initState();
    // copy the data so we can mutate safely
    products = List<Product>.from(widget.cartProducts);
    quantities = Map<int, int>.from(widget.quantities);
  }

  void _updateQuantity(Product product, bool increment) {
    setState(() {
      final currentQty = quantities[product.id] ?? 1;
      if (increment) {
        quantities[product.id] = currentQty + 1;
      } else {
        if (currentQty > 1) {
          quantities[product.id] = currentQty - 1;
        }
      }
    });
  }

  void _removeProduct(Product product) {
    setState(() {
      products.removeWhere((p) => p.id == product.id);
      quantities.remove(product.id);
    });
  }

  double getTotalPrice() {
    double total = 0;
    for (var product in products) {
      total += product.price * (quantities[product.id] ?? 1);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Your Cart'), backgroundColor: Colors.green),
        body: Center(
          child: Text(
            'Your cart is empty!',
            style: TextStyle(fontSize: 18, color: Colors.green[700]),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final quantity = quantities[product.id] ?? 1;

          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.img,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.green[50],
                          child: Icon(Icons.image, color: Colors.green[200]),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '₹ ${product.price}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _updateQuantity(product, false),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 16,
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '$quantity',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[900],
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _updateQuantity(product, true),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 16,
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _removeProduct(product),
                      child: Icon(Icons.delete, color: Colors.redAccent),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: ₹${getTotalPrice().toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Checkout functionality not implemented yet!',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Checkout', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
