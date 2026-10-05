/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 15 & 16 - Data Models, OOP & JSON Parsing Logic
/// LOGIC  : Encapsulates Artisan Product data, category taxonomy, pricing,
///          and dynamic 70/15/15 Profit Sharing calculations.
/// VIVA TIP: Why separate business model classes from UI?
///          - Follows Separation of Concerns (SoC) & Clean Architecture.
///          - Makes data serializable (toJson/fromJson) for backend APIs or Local Storage.
/// ============================================================================

enum CraftCategory {
  pottery('Pottery & Terracotta', '🏺'),
  woodwork('Woodwork & Carving', '🪵'),
  weaving('Handloom & Weaving', '🧶'),
  metalwork('Brass & Metal Craft', '🪙'),
  jewelry('Artisan Jewelry', '💍');

  final String displayName;
  final String iconEmoji;
  const CraftCategory(this.displayName, this.iconEmoji);
}

class ProfitShareBreakdown {
  final double totalPrice;
  final double rawMaterialCost;
  final double netProfit;
  final double artisanPayout;     // 70% of Net Profit
  final double welfareFundPayout;  // 15% of Net Profit
  final double materialPoolPayout; // 15% of Net Profit

  ProfitShareBreakdown({
    required this.totalPrice,
    required this.rawMaterialCost,
    required this.netProfit,
    required this.artisanPayout,
    required this.welfareFundPayout,
    required this.materialPoolPayout,
  });

  /// Factory constructor calculating exact profit share logic
  factory ProfitShareBreakdown.calculate({
    required double price,
    required double materialCost,
    double artisanSharePercentage = 0.70,
  }) {
    final netProfit = (price - materialCost).clamp(0.0, double.infinity);
    final artisanCut = netProfit * artisanSharePercentage;
    final remainingCut = netProfit - artisanCut;
    final welfareCut = remainingCut * 0.5;   // 15% overall
    final materialCut = remainingCut * 0.5;  // 15% overall

    return ProfitShareBreakdown(
      totalPrice: price,
      rawMaterialCost: materialCost,
      netProfit: netProfit,
      artisanPayout: artisanCut,
      welfareFundPayout: welfareCut,
      materialPoolPayout: materialCut,
    );
  }
}

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final double materialCost;
  final CraftCategory category;
  final String artisanName;
  final String artisanLocation;
  final String imageUrl;
  final double rating;
  final int salesCount;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.materialCost,
    required this.category,
    required this.artisanName,
    required this.artisanLocation,
    required this.imageUrl,
    this.rating = 4.8,
    this.salesCount = 12,
  });

  /// Get profit sharing breakdown instance for this product
  ProfitShareBreakdown get profitBreakdown {
    return ProfitShareBreakdown.calculate(
      price: price,
      materialCost: materialCost,
    );
  }

  /// Converts JSON Map to Product Object (JSON Deserialization)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      materialCost: (json['materialCost'] as num).toDouble(),
      category: CraftCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => CraftCategory.pottery,
      ),
      artisanName: json['artisanName'] as String,
      artisanLocation: json['artisanLocation'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      salesCount: (json['salesCount'] as int?) ?? 0,
    );
  }

  /// Converts Product Object to JSON Map (JSON Serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'materialCost': materialCost,
      'category': category.name,
      'artisanName': artisanName,
      'artisanLocation': artisanLocation,
      'imageUrl': imageUrl,
      'rating': rating,
      'salesCount': salesCount,
    };
  }
}
