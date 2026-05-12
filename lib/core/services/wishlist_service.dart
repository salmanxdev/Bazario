import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../shared/models/product_model.dart';

class WishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  CollectionReference get _wishlistCollection => 
      _firestore.collection('users').doc(_userId).collection('wishlist');

  Future<void> toggleWishlist(Product product) async {
    if (_userId.isEmpty) return;

    final doc = await _wishlistCollection.doc(product.id).get();
    
    if (doc.exists) {
      await _wishlistCollection.doc(product.id).delete();
    } else {
      await _wishlistCollection.doc(product.id).set(product.toMap());
    }
  }

  Stream<QuerySnapshot> getWishlistItems() {
    if (_userId.isEmpty) return const Stream.empty();
    return _wishlistCollection.snapshots();
  }
}
