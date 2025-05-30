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
  String selectedLanguage = 'English';

  /// ✅ TextEditingController for input field
  final TextEditingController _searchController = TextEditingController();

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
      updateProductList();
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  void updateProductList() {
    if (productData == null) return;

    List<Product> langProducts;
    switch (selectedLanguage) {
      case 'Hindi':
        langProducts = productData!.hindi;
        break;
      case 'Gujarati':
        langProducts = productData!.gujrati;
        break;
      default:
        langProducts = productData!.english;
        break;
    }

    setState(() {
      products = langProducts;
      quantities = {for (int i = 0; i < products.length; i++) i: 1};
    });
  }

  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speechToText.listen(onResult: (result) {
        setState(() {
          _spokenText = result.recognizedWords;
          _searchController.text = _spokenText;
          _searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: _searchController.text.length),
          );
          if (_spokenText.isNotEmpty) {
            searchProduct(_spokenText);
          }
        });
      });
    } else {
      setState(() => _isListening = false);
    }
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void searchProduct(String query) {
    if (productData == null || query.isEmpty) {
      updateProductList();
      return;
    }

    List<Product> selectedList;
    switch (selectedLanguage) {
      case 'Hindi':
        selectedList = productData!.hindi;
        break;
      case 'Gujarati':
        selectedList = productData!.gujrati;
        break;
      default:
        selectedList = productData!.english;
    }

    final keywords = query.toLowerCase().split(RegExp(r'[,\s]+')).where((word) => word.trim().isNotEmpty).toList();

    setState(() {
      products = selectedList.where((product) {
        final name = product.name.toLowerCase();
        final description = product.description.toLowerCase();
        final tags = product.tags.map((t) => t.toLowerCase());

        return keywords.any((keyword) =>
        name.contains(keyword) ||
            description.contains(keyword) ||
            tags.any((tag) => tag.contains(keyword)));
      }).toList();
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerPage(context: context, products: products, quantities: quantities),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'Grocery App',
          style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.language, color: Colors.white),
            onSelected: (String value) {
              setState(() {
                selectedLanguage = value;
                updateProductList();
              });
            },
            itemBuilder: (BuildContext context) {
              return ['English', 'Hindi', 'Gujarati'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
          IconButton(icon: Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
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
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: Offset(0, 2))],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (query) => searchProduct(query),
              decoration: InputDecoration(
                hintText: 'Search products like "cheeni chawal tel"...',
                prefixIcon: Icon(Icons.search, color: Colors.green),
                suffixIcon: IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none,
                      color: _isListening ? Colors.red : Colors.green),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                  decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                );
              }),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Text(
              'Most Selling Product',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.green[800]),
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? Center(
              child: Text(
                'No products found, try speaking clearly or using another language!',
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
                    boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: Offset(0, 2))],
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
                            Text('${product.name} (${product.description})',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            SizedBox(height: 4),
                            Text('₹ ${product.price}',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54)),
                            SizedBox(height: 2),
                            Text(product.priceTagline, style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.shopping_cart_outlined, color: Colors.green),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartPage(
                                cartProducts: [product],
                                quantities: {0: 1},
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
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
