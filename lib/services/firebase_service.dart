import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';
import '../firebase_options.dart';

/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 17 & 18 - Firebase Cloud Firestore DB & Firebase Authentication
/// LOGIC  : Central service managing user authentication (sign in / register)
///          and Firestore NoSQL Database CRUD operations for Products, Jobs & Donations.
/// VIVA TIP: How does Cloud Firestore structure data?
///          - Firestore is a NoSQL document database storing data in Collections & Documents.
///          - Document references support real-time reactive streams via snapshots().
/// ============================================================================

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  bool _isFirebaseInitialized = false;

  bool get isInitialized => _isFirebaseInitialized;

  /// Initializes Firebase safely with books-crud-app-3de59 options
  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isFirebaseInitialized = true;
      print("🔥 Real Firebase initialized successfully for books-crud-app-3de59!");
    } catch (e) {
      _isFirebaseInitialized = false;
      print("ℹ️ Running in Offline/Local Mock Mode (Firebase initialization skipped: $e)");
    }
  }

  // ===========================================================================
  // PRACTICAL 18: FIREBASE AUTHENTICATION METHODS
  // ===========================================================================

  /// Registers a new user/artisan with Email & Password
  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    if (!_isFirebaseInitialized) return null;
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(displayName);
      return credential;
    } catch (e) {
      print("Firebase Auth Sign Up Error: $e");
      rethrow;
    }
  }

  /// Signs in an existing user with Email & Password
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (!_isFirebaseInitialized) return null;
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("Firebase Auth Sign In Error: $e");
      rethrow;
    }
  }

  /// Signs out the current authenticated user
  Future<void> signOut() async {
    if (!_isFirebaseInitialized) return;
    await FirebaseAuth.instance.signOut();
  }

  /// Returns current authenticated Firebase user
  User? get currentUser {
    if (!_isFirebaseInitialized) return null;
    return FirebaseAuth.instance.currentUser;
  }

  // ===========================================================================
  // PRACTICAL 17: CLOUD FIRESTORE DATABASE CRUD OPERATIONS
  // ===========================================================================

  /// Adds a new Product document to 'products' collection
  Future<void> addProductToFirestore(Product product) async {
    if (!_isFirebaseInitialized) return;
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.id)
          .set(product.toJson());
    } catch (e) {
      print("Firestore Add Product Error: $e");
    }
  }

  /// Real-time stream listener for Products collection
  Stream<List<Product>>? getProductsStream() {
    if (!_isFirebaseInitialized) return null;
    return FirebaseFirestore.instance.collection('products').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList(),
    );
  }

  /// Updates sales & profit stats document in Firestore
  Future<void> recordPurchaseInFirestore({
    required String productId,
    required double price,
    required double artisanShare,
    required double welfareShare,
    required double materialShare,
  }) async {
    if (!_isFirebaseInitialized) return;
    try {
      final batch = FirebaseFirestore.instance.batch();
      final statsRef = FirebaseFirestore.instance.collection('analytics').doc('earnings');

      batch.set(
        statsRef,
        {
          'totalSales': FieldValue.increment(price),
          'artisanEarnings': FieldValue.increment(artisanShare),
          'welfareFund': FieldValue.increment(welfareShare),
          'materialPool': FieldValue.increment(materialShare),
          'completedOrders': FieldValue.increment(1),
        },
        SetOptions(merge: true),
      );

      await batch.commit();
    } catch (e) {
      print("Firestore Record Purchase Error: $e");
    }
  }
}
