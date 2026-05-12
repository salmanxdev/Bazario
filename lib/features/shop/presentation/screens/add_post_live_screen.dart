import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:bazario/core/services/product_service.dart';
import 'package:bazario/shared/models/product_model.dart';

class AddPostLiveScreen extends StatefulWidget {
  const AddPostLiveScreen({super.key});

  @override
  State<AddPostLiveScreen> createState() => _AddPostLiveScreenState();
}

class _AddPostLiveScreenState extends State<AddPostLiveScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _mediaUrlController = TextEditingController();
  bool _isVideo = false;
  bool _isLoading = false;

  final ProductService _productService = ProductService();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      final product = Product(
        id: const Uuid().v4(),
        sellerId: user.uid,
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        mediaUrl: _mediaUrlController.text.isNotEmpty 
            ? _mediaUrlController.text 
            : 'https://picsum.photos/500/800', // Placeholder
        isVideo: _isVideo,
        createdAt: DateTime.now(),
      );

      await _productService.addProduct(product);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product posted successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Product')),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Product Name'),
                      validator: (val) => val!.isEmpty ? 'Enter name' : null,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      validator: (val) => val!.isEmpty ? 'Enter description' : null,
                    ),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      validator: (val) => val!.isEmpty ? 'Enter price' : null,
                    ),
                    TextFormField(
                      controller: _mediaUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Media URL (Image/Video)',
                        hintText: 'Leave empty for random placeholder',
                      ),
                    ),
                    SwitchListTile(
                      title: const Text('Is this a video?'),
                      value: _isVideo,
                      onChanged: (val) => setState(() => _isVideo = val),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Post Product'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
