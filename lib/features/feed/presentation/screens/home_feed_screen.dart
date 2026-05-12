import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:bazario/core/services/product_service.dart';
import 'package:bazario/core/services/cart_service.dart';
import 'package:bazario/core/services/chat_service.dart';
import 'package:bazario/shared/models/product_model.dart';
import 'package:bazario/features/feed/presentation/widgets/product_popup_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();
  final ChatService _chatService = ChatService();

  void _showProductPopup(Product product) {
    showDialog(
      context: context,
      builder: (context) => ProductPopupCard(
        product: product,
        onAddToCart: () async {
          await _cartService.addToCart(product);
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to cart!')),
            );
          }
        },
        onChat: () async {
          final roomId = await _chatService.getOrCreateChatRoom(product.sellerId);
          await _chatService.sendMessage(roomId, 'Hi! I am interested in your product: ${product.name}\n${product.mediaUrl}');
          if (mounted) {
            Navigator.pop(context);
            context.push('/chat-detail/$roomId/${product.sellerId}');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Image.asset(
          'assets/images/logo.png',
          height: 28,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.person_crop_circle, color: Colors.white),
            onPressed: () {
              context.push('/profile');
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: _productService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No products in feed yet.\nUpload something to see it here!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final products = snapshot.data!;

          return MasonryGridView.builder(
            padding: const EdgeInsets.all(4),
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return FeedItem(
                product: product,
                onTap: () => _showProductPopup(product),
              );
            },
          );
        },
      ),
    );
  }
}

class FeedItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const FeedItem({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '₹${product.price}',
                  style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black87,
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            product.mediaUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey.shade900,
                child: const Center(child: CupertinoActivityIndicator(color: Colors.white)),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey.shade900,
              child: const Icon(Icons.broken_image, color: Colors.white24, size: 40),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
          if (product.isVideo)
            const Positioned(
              top: 12,
              right: 12,
              child: Icon(
                CupertinoIcons.play_circle_fill,
                color: Colors.white70,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}
