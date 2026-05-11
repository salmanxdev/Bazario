import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/product_service.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/services/chat_service.dart';
import '../../../shared/models/product_model.dart';
import '../widgets/product_popup_card.dart';

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
        title: const Text(
          'BAZARIO',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.black,
            letterSpacing: 4,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
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

          return GridView.builder(
            padding: const EdgeInsets.all(1),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
            ),
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
        // Show price and name on long press as requested
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
          // Media (Image or Video Thumbnail)
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
          
          // Gradient Overlay at bottom for better visibility (optional but looks good)
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

          // Video Icon overlay if it's a video
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
