import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bazario/shared/models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  Future<void> addProduct(Product product) async {
    // Using set() with the product.id we generated in the UI
    await _firestore.collection(_collection).doc(product.id).set(product.toMap());
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
