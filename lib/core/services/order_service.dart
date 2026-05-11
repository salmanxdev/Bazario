import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../shared/models/order_model.dart';
import '../../shared/models/cart_item_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  Future<void> placeOrder(List<CartItem> items, double total) async {
    if (_userId.isEmpty) return;

    final order = OrderModel(
      id: '', // Firestore will generate
      userId: _userId,
      items: items,
      totalAmount: total,
      createdAt: DateTime.now(),
      status: 'pending',
    );

    await _firestore.collection('orders').add(order.toMap());
  }

  Stream<List<OrderModel>> getOrders() {
    if (_userId.isEmpty) return Stream.value([]);
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: _userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    });
  }
}
