import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../shared/models/cart_item_model.dart';
import '../../shared/models/product_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  CollectionReference get _cartCollection => 
      _firestore.collection('users').doc(_userId).collection('cart');

  Future<void> addToCart(Product product) async {
    if (_userId.isEmpty) return;

    final doc = await _cartCollection.doc(product.id).get();
    
    if (doc.exists) {
      await _cartCollection.doc(product.id).update({
        'quantity': FieldValue.increment(1),
      });
    } else {
      final cartItem = CartItem(
        id: product.id,
        productId: product.id,
        productName: product.name,
        price: product.price,
        mediaUrl: product.mediaUrl,
        quantity: 1,
      );
      await _cartCollection.doc(product.id).set(cartItem.toMap());
    }
  }

  Stream<List<CartItem>> getCartItems() {
    if (_userId.isEmpty) return Stream.value([]);
    return _cartCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CartItem.fromFirestore(doc)).toList();
    });
  }

  Future<void> removeFromCart(String itemId) async {
    await _cartCollection.doc(itemId).delete();
  }

  Future<void> updateQuantity(String itemId, int delta) async {
    final doc = await _cartCollection.doc(itemId).get();
    if (doc.exists) {
      int newQty = (doc.data() as Map)['quantity'] + delta;
      if (newQty <= 0) {
        await removeFromCart(itemId);
      } else {
        await _cartCollection.doc(itemId).update({'quantity': newQty});
      }
    }
  }

  Future<void> clearCart() async {
    final snapshots = await _cartCollection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }
}
