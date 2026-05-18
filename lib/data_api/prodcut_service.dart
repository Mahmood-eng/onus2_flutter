import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<List<Product>> getProductsStream(String category) {
    Query query = _firestore.collection('products');

    if (category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) =>
                Product.fromJson(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();
    });
  }

  static Future<Product?> getProductById(String id) async {
    final doc = await _firestore.collection('products').doc(id).get();
    return doc.exists ? Product.fromJson(doc.data()!, doc.id) : null;
  }

  static Future<List<Product>> loadProductsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    final snapshot = await _firestore
        .collection('products')
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    return snapshot.docs
        .map((doc) => Product.fromJson(doc.data()!, doc.id))
        .toList();
  }
}
