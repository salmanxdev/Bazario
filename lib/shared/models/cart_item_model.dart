import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final String mediaUrl;
  final int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.mediaUrl,
    required this.quantity,
  });

  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data();
    final map = data != null ? Map<String, dynamic>.from(data as Map) : <String, dynamic>{};
    return CartItem.fromMap(map, id: doc.id);
  }

  factory CartItem.fromMap(Map<String, dynamic> data, {String id = ''}) {
    return CartItem(
      id: id,
      productId: data['productId'] as String? ?? '',
      productName: data['productName'] as String? ?? '',
      price: (data['price'] ?? 0).toDouble(),
      mediaUrl: data['mediaUrl'] as String? ?? '',
      quantity: (data['quantity'] as num? ?? 1).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'mediaUrl': mediaUrl,
      'quantity': quantity,
    };
  }
}
