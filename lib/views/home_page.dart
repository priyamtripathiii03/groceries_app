import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceries_app/component/drawer.dart';
import 'package:groceries_app/modal/modals.dart';
import 'package:groceries_app/views/profile_page.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'cart_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];
  ProductData? productData;
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _spokenText = 'Say something...';
  Map<int, int> quantities = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await rootBundle.loadString('assets/path.json');
      final Map<String, dynamic> jsonMap = jsonDecode(data);
      productData = ProductData.fromJson(jsonMap);

      setState(() {
        products = productData!.english;
        for (int i = 0; i < products.length; i++) {
          quantities[i] = 1;
        }
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speechToText.listen(onResult: (result) {
        setState(() {
          _spokenText = result.recognizedWords;
          if (_spokenText.isNotEmpty) {
            searchProduct(_spokenText);
          }
        });
      });
    } else {
      setState(() => _isListening = false);
      // Show an error Snackbar or message
    }
  }


  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void searchProduct(String query) {
    if (productData == null) return;

    setState(() {
      if (query.isEmpty) {
        products = [...productData!.english];
      } else {
        List<Product> filteredProducts = [];

        filteredProducts.addAll(productData!.english.where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase()) ||
            product.tags.any((tag) =>
                tag.toLowerCase().contains(query.toLowerCase()))));

        filteredProducts.addAll(productData!.hindi.where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase()) ||
            product.tags.any((tag) =>
                tag.toLowerCase().contains(query.toLowerCase()))));

        filteredProducts.addAll(productData!.gujrati.where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase()) ||
            product.tags.any((tag) =>
                tag.toLowerCase().contains(query.toLowerCase()))));

        products = filteredProducts;
      }
    });
  }

  void _updateQuantity(int index, bool increment) {
    setState(() {
      if (increment) {
        quantities[index] = (quantities[index] ?? 1) + 1;
      } else {
        if ((quantities[index] ?? 1) > 1) {
          quantities[index] = (quantities[index] ?? 1) - 1;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerPage(context: context, products: products, quantities: quantities),
      // Added Drawer here
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: Builder(
          builder: (context) =>
              IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        title: Text(
          'Grocery App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {}),
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
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
                  builder: (context) => CartPage(
                    cartProducts: selectedProducts,
                    quantities: selectedQuantities,
                  ),
                ),
              );
            },
          ),
          IconButton(icon: Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (query) => searchProduct(query),
              decoration: InputDecoration(
                hintText: 'Search Product Like sugar...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.green),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: _isListening ? Colors.red : Colors.green,
                  ),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 15, horizontal: 20),
              ),
            ),
          ),
          Container(
            height: 80,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Text(
              'Most Selling Product',
              style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[800]),
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? Center(
              child: Text(
                'No products found, try searching!',
                style: TextStyle(fontSize: 16, color: Colors.green[300]),
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
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
                                child: Icon(
                                    Icons.image, color: Colors.green[200]),
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
                              '${product.name} (${product.description})',
                              style: TextStyle(fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '₹ ${product.price}',
                              style: TextStyle(fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                            SizedBox(height: 2),
                            Text(
                              product.priceTagline,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(height: 8),
                        ],
                      ),
                      SizedBox(width: 12),
                      IconButton(
                        icon: Icon(Icons.shopping_cart_outlined, color: Colors.green),
                        onPressed: () {
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
                              builder: (context) => CartPage(
                                cartProducts: selectedProducts,
                                quantities: selectedQuantities,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: _isListening ? _stopListening : _startListening,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: _isListening ? Colors.red[100] : Colors.green[100],
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black26)],
          ),
          child: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            color: _isListening ? Colors.red : Colors.green[800],
            size: 30,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: Icon(Icons.home), onPressed: () {}),
              IconButton(icon: Icon(Icons.person), onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              }),
            ],
          ),
        ),
      ),
    );
  }
  }
