import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product_model.dart';

class AddProductController extends ChangeNotifier {
  final _formKey = GlobalKey<FormState>();
  File? image;
  bool isLoading = false;

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  String? selectedCategory;

  GlobalKey<FormState> get formKey => _formKey;

  final List<String> categories = [
    'smartphones',
    'laptops',
    'fragrances',
    'skincare',
    'groceries',
    'home-decoration',
    'furniture',
    'tops',
    'mens-shoes',
    'womens-dresses',
    'sunglasses',
  ];

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<bool> uploadProduct(BuildContext context) async {
    if (!_formKey.currentState!.validate() || image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء تعبئة كافة الحقول واختيار صورة')),
      );
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child(
        'products/$fileName',
      );
      await storageRef.putFile(image!);
      String imageUrl = await storageRef.getDownloadURL();

      final docRef = FirebaseFirestore.instance.collection('products').doc();
      final product = Product(
        id: docRef.id,
        name: nameController.text,
        category: selectedCategory ?? 'All',
        price: double.tryParse(priceController.text) ?? 0.0,
        imageUrl: imageUrl,
        description: descriptionController.text,
      );

      await docRef.set(product.toJson());
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
