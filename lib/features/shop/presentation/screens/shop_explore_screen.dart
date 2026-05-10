import 'package:flutter/material.dart';

class ShopExploreScreen extends StatelessWidget {
  const ShopExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FB),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search, color: Colors.black54),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),

            // Store List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildStoreCard(
                    context,
                    name: 'Style Street',
                    distance: '850 m away',
                    address: 'Brigade Road, Bengaluru',
                    description: 'Trendy fashion for every occasion. Discover your style with us.',
                    tags: ['Men', 'Women', 'Bags & Accessories', '+2 more'],
                    rating: '4.7',
                    reviews: '215 reviews',
                    imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=400&q=80',
                  ),
                  const SizedBox(height: 20),
                  _buildStoreCard(
                    context,
                    name: 'Toy Town',
                    distance: '950 m away',
                    address: '1st Main Road, Indiranagar, Bengaluru',
                    description: 'Fun, safe & educational toys for kids of all ages. Play more, learn more!',
                    tags: ['Soft Toys', 'Educational Toys', 'Action Figures', '+4 more'],
                    rating: '4.8',
                    reviews: '362 reviews',
                    imageUrl: 'https://images.unsplash.com/photo-1558066551-7688219de8c9?auto=format&fit=crop&w=400&q=80',
                  ),
                  const SizedBox(height: 20),
                  _buildStoreCard(
                    context,
                    name: 'Casa Living',
                    distance: '1.2 km away',
                    address: 'MG Road, Bengaluru',
                    description: 'Stylish home decor for every corner of your home.',
                    tags: ['Wall Decor', 'Vases & Planters', 'Cushions', '+3 more'],
                    rating: '4.6',
                    reviews: '128 reviews',
                    imageUrl: 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=400&q=80',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreCard(BuildContext context, {
    required String name,
    required String distance,
    required String address,
    required String description,
    required List<String> tags,
    required String rating,
    required String reviews,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                child: Image.network(
                  imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 15,
                left: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text('Open', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, size: 20, color: Color(0xff6C63FF)),
                ),
              )
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    const Icon(Icons.verified, color: Color(0xff6C63FF), size: 16),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Color(0xff6C63FF)),
                    const SizedBox(width: 4),
                    Text(distance, style: const TextStyle(fontSize: 12, color: Color(0xff6C63FF), fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    const Text('•', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(address, style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 15),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags.map((tag) => _buildTag(tag)).toList(),
                ),
                const SizedBox(height: 15),
                const Divider(height: 1),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(rating, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        Text('($reviews)', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.verified_user_outlined, color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        const Text('Trusted Seller', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.local_shipping_outlined, color: Color(0xff6C63FF), size: 16),
                        const SizedBox(width: 4),
                        const Text('Fast Delivery', style: TextStyle(color: Color(0xff6C63FF), fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xffF2F0FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: Color(0xff6C63FF), fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
