import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  Future<void> addProduct(Product product) async {
    await _firestore.collection(_collection).add(product.toMap());
  }

  Stream<List<Product>> getProducts() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    });
  }
}
