import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/job_model.dart';
import '../models/donation_model.dart';

/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 14 - Data Structures & State Management (ChangeNotifier)
/// LOGIC  : Central state container holding products, jobs, donations, and role state.
///          Invokes notifyListeners() on state mutations so listening UI widgets automatically rebuild.
/// VIVA TIP: What is ChangeNotifier & Provider pattern?
///          - ChangeNotifier is a class in Flutter foundation that provides change notifications.
///          - When notifyListeners() is invoked, any AnimatedBuilder or ListenableBuilder listening to it triggers a rebuild of dependent widgets.
/// ============================================================================

enum UserRole { buyer, artisan }

class CraftStoreProvider extends ChangeNotifier {
  UserRole _currentRole = UserRole.buyer;
  String _searchQuery = '';
  CraftCategory? _selectedCategory;

  // Artisan Earning State
  double _totalSalesRevenue = 1450.00;
  double _totalArtisanEarnings = 820.00;
  double _totalWelfareFundContributed = 175.50;
  double _totalMaterialPoolContributed = 175.50;
  int _completedOrdersCount = 18;

  // Initial Mock Data
  final List<Product> _products = [
    Product(
      id: 'prod_1',
      title: 'Handcrafted Terracotta Water Pitcher',
      description: 'Traditional earthenware pot made from natural river clay. Eco-friendly, natural cooling properties crafted by master potter Ramesh K.',
      price: 45.0,
      materialCost: 12.0,
      category: CraftCategory.pottery,
      artisanName: 'Ramesh Kumhar',
      artisanLocation: 'Jaipur, Rajasthan',
      imageUrl: 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=500',
      rating: 4.9,
      salesCount: 24,
    ),
    Product(
      id: 'prod_2',
      title: 'Handwoven Pashmina Shawl (Floral)',
      description: 'Authentic pure wool handloom shawl crafted over 30 days with traditional Sozni embroidery detail.',
      price: 180.0,
      materialCost: 55.0,
      category: CraftCategory.weaving,
      artisanName: 'Farooq Ahmed',
      artisanLocation: 'Srinagar, Kashmir',
      imageUrl: 'https://images.unsplash.com/photo-1606760227091-3dd858d9721b?w=500',
      rating: 5.0,
      salesCount: 14,
    ),
    Product(
      id: 'prod_3',
      title: 'Carved Teakwood Elephant Figurine',
      description: 'Hand-carved solid teakwood sculpture with natural oil finish. Supporting sustainable forestry and woodcarvers.',
      price: 85.0,
      materialCost: 25.0,
      category: CraftCategory.woodwork,
      artisanName: 'Lakshmi Narayan',
      artisanLocation: 'Mysore, Karnataka',
      imageUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=500',
      rating: 4.7,
      salesCount: 31,
    ),
    Product(
      id: 'prod_4',
      title: 'Antique Brass Dhokra Metal Art Bell',
      description: 'Ancient lost-wax metal casting technique preserved by tribal artisans of Chhattisgarh.',
      price: 65.0,
      materialCost: 20.0,
      category: CraftCategory.metalwork,
      artisanName: 'Sunita Gond',
      artisanLocation: 'Bastar, Chhattisgarh',
      imageUrl: 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=500',
      rating: 4.8,
      salesCount: 19,
    ),
  ];

  final List<CraftJob> _jobs = [
    CraftJob(
      id: 'job_1',
      title: 'Master Terracotta Potter for Festival Order',
      organizationOrBuyer: 'Heritage Crafts Co-op',
      location: 'Jaipur / Remote',
      requiredCraft: CraftCategory.pottery,
      stipendOrBudget: 1200.0,
      duration: '3 Weeks',
      description: 'Seeking experienced potter to create 500 handcrafted clay diyas and decorative pots for export festival order.',
      applicantNames: ['Ramesh Kumhar'],
    ),
    CraftJob(
      id: 'job_2',
      title: 'Handloom Weaver Contract (Silk Sarees)',
      organizationOrBuyer: 'Weavers Guild India',
      location: 'Varanasi, UP',
      requiredCraft: CraftCategory.weaving,
      stipendOrBudget: 2500.0,
      duration: '2 Months',
      description: 'Looking for 3 skilled weavers proficient in Jacquard handloom silk weaving.',
    ),
    CraftJob(
      id: 'job_3',
      title: 'Woodcarving Restoration Craftsman',
      organizationOrBuyer: 'Palace Heritage Trust',
      location: 'Mysore, KA',
      requiredCraft: CraftCategory.woodwork,
      stipendOrBudget: 1800.0,
      duration: '1 Month',
      description: 'Restoration of vintage teak doors and traditional pillars in historical museum building.',
    ),
  ];

  final List<DonationItem> _donations = [
    DonationItem(
      id: 'don_1',
      title: 'Natural Clay & Potter Wheels Support Pool',
      targetArtisanOrCluster: 'Jaipur Clay Artisans Collective',
      type: DonationType.rawMaterial,
      unit: 'kg Clay & Wheels',
      targetAmount: 500.0,
      raisedAmount: 320.0,
      description: 'Provide high-grade terracotta clay and electric foot-wheels to 15 women potters.',
      imageUrl: 'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=500',
    ),
    DonationItem(
      id: 'don_2',
      title: 'Artisan Healthcare & Welfare Emergency Fund',
      targetArtisanOrCluster: 'National Craftspeople Welfare Trust',
      type: DonationType.money,
      unit: 'USD',
      targetAmount: 3000.0,
      raisedAmount: 1850.0,
      description: 'Emergency medical assistance and insurance coverage for aging traditional weavers and woodworkers.',
      imageUrl: 'https://images.unsplash.com/photo-1532629345422-7515f3d16bb0?w=500',
    ),
    DonationItem(
      id: 'don_3',
      title: 'Organic Silk Yarn & Loom Machinery Subsidies',
      targetArtisanOrCluster: 'Kashmir Handloom Guild',
      type: DonationType.rawMaterial,
      unit: 'Spools',
      targetAmount: 200.0,
      raisedAmount: 140.0,
      description: 'Distribute chemical-free natural dyed organic yarn to rural handloom weavers.',
      imageUrl: 'https://images.unsplash.com/photo-1584992236310-6edddc08acff?w=500',
    ),
  ];

  // Getters
  UserRole get currentRole => _currentRole;
  String get searchQuery => _searchQuery;
  CraftCategory? get selectedCategory => _selectedCategory;

  double get totalSalesRevenue => _totalSalesRevenue;
  double get totalArtisanEarnings => _totalArtisanEarnings;
  double get totalWelfareFundContributed => _totalWelfareFundContributed;
  double get totalMaterialPoolContributed => _totalMaterialPoolContributed;
  int get completedOrdersCount => _completedOrdersCount;

  List<Product> get products {
    return _products.where((p) {
      final matchesQuery = p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.artisanName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null || p.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  List<CraftJob> get jobs => List.unmodifiable(_jobs);
  List<DonationItem> get donations => List.unmodifiable(_donations);

  // Actions & State Mutators

  /// Toggles between Artisan and Buyer active role
  void toggleUserRole(UserRole newRole) {
    _currentRole = newRole;
    notifyListeners();
  }

  /// Sets search query for live marketplace filtering
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Filters product catalog by Craft Category
  void setCategoryFilter(CraftCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Adds a new product listed by an artisan (Practical 4 & 14)
  void addProduct(Product product) {
    _products.insert(0, product);
    notifyListeners();
  }

  /// Processes product purchase & executes 70/15/15 profit distribution
  void purchaseProduct(Product product) {
    final breakdown = product.profitBreakdown;
    _totalSalesRevenue += product.price;
    _totalArtisanEarnings += breakdown.artisanPayout;
    _totalWelfareFundContributed += breakdown.welfareFundPayout;
    _totalMaterialPoolContributed += breakdown.materialPoolPayout;
    _completedOrdersCount++;

    notifyListeners();
  }

  /// Applies for a job posting as an artisan
  void applyForJob(String jobId, String artisanName) {
    final index = _jobs.indexWhere((j) => j.id == jobId);
    if (index != -1) {
      final job = _jobs[index];
      if (!job.applicantNames.contains(artisanName)) {
        final updatedApplicants = List<String>.from(job.applicantNames)..add(artisanName);
        _jobs[index] = job.copyWith(applicantNames: updatedApplicants);
        notifyListeners();
      }
    }
  }

  /// Posts a new job opportunity
  void addJob(CraftJob job) {
    _jobs.insert(0, job);
    notifyListeners();
  }

  /// Contributes to a money/material donation item
  void contributeDonation(String donationId, double amount) {
    final index = _donations.indexWhere((d) => d.id == donationId);
    if (index != -1) {
      final item = _donations[index];
      _donations[index] = item.copyWith(additionalRaised: amount);
      notifyListeners();
    }
  }
}

/// ============================================================================
/// InheritedNotifier for efficient sub-tree widget access without 3rd party packages
/// ============================================================================
class CraftStoreScope extends InheritedNotifier<CraftStoreProvider> {
  const CraftStoreScope({
    Key? key,
    required CraftStoreProvider notifier,
    required Widget child,
  }) : super(key: key, notifier: notifier, child: child);

  static CraftStoreProvider of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CraftStoreScope>();
    assert(scope != null, 'No CraftStoreScope found in BuildContext');
    return scope!.notifier!;
  }
}
