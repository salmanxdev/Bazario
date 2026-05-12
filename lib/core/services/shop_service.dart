import 'package:cloud_firestore/cloud_firestore.dart';

class ShopService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getShops() {
    return _firestore.collection('shops').orderBy('createdAt', descending: true).snapshots();
  }
}
