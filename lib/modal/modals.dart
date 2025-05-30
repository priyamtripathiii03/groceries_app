class Product {
  final int id;
  final String name;
  final String description;
  final String img;
  final double price;
  final String priceTagline;
  final List<String> tags;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.img,
    required this.price,
    required this.priceTagline,
    required this.tags,
  });

  // Factory method to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      img: json['img'],
      price: json['price'].toDouble(),
      priceTagline: json['price-tagline'],
      tags: List<String>.from(json['tags']),
    );
  }
}

class ProductData {
  final List<Product> english;
  final List<Product> hindi;
  final List<Product> gujrati;

  ProductData({
    required this.english,
    required this.hindi,
    required this.gujrati,
  });

  // Factory method to create ProductData from JSON
  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      english: (json['english'] as List?)?.map((item) => Product.fromJson(item)).toList() ?? [],
      hindi: (json['hindi'] as List?)?.map((item) => Product.fromJson(item)).toList() ?? [],
      gujrati: (json['gujarati'] as List?)?.map((item) => Product.fromJson(item)).toList() ?? [],
    );
  }

  // Convert ProductData to Map with language as key
  Map<String, List<Product>> toMap() {
    return {
      'english': english,
      'hindi': hindi,
      'gujrati': gujrati,
    };
  }
}

