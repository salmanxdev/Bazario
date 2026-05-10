import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(currentUserProvider);
    final user = userState.value;
    
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8F9FB),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black54),
            onPressed: () {
              // Settings logic
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user?.firstName ?? 'Rohan'} ${user?.lastName ?? 'Verma'}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff2A2A3A)),
                        ),
                        Text(
                          user?.email ?? 'rohan.verma@email.com',
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xffEFEAFA),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified, size: 14, color: Color(0xff6C63FF)),
                              const SizedBox(width: 4),
                              Text(
                                'Verified ${user?.role == 'seller' ? 'Seller' : 'Buyer'}',
                                style: const TextStyle(color: Color(0xff6C63FF), fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              
              const SizedBox(height: 25),
              
              // Stats Cards
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(Icons.shopping_bag_outlined, const Color(0xff8772FE), '12', 'Orders'),
                    _buildDivider(),
                    _buildStatItem(CupertinoIcons.heart, const Color(0xffFF7096), '8', 'Wishlist'),
                    _buildDivider(),
                    _buildStatItem(CupertinoIcons.tag, const Color(0xffFFB703), '5', 'Coupons'),
                    _buildDivider(),
                    _buildStatItem(Icons.account_balance_wallet_outlined, const Color(0xff2DDA93), '₹1,250', 'Wallet Balance'),
                  ],
                ),
              ),
              
              const SizedBox(height: 25),
              
              const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 10),
              
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F0FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(CupertinoIcons.cube_box, color: Color(0xff6C63FF)),
                  ),
                  title: const Text('Your Orders', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  subtitle: const Text('Track, return or reorder items', style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildListOption(CupertinoIcons.heart, const Color(0xffFF7096), 'Wishlist', 'View items you have saved'),
                    const Divider(height: 1, thickness: 1, indent: 65),
                    _buildListOption(CupertinoIcons.location, const Color(0xff2DDA93), 'Addresses', 'Manage your delivery addresses'),
                    const Divider(height: 1, thickness: 1, indent: 65),
                    _buildListOption(Icons.credit_card, const Color(0xff3B82F6), 'Payments', 'View saved cards and payment methods'),
                    const Divider(height: 1, thickness: 1, indent: 65),
                    _buildListOption(CupertinoIcons.ticket, const Color(0xffFFB703), 'Coupons & Offers', 'View available coupons and offers'),
                    const Divider(height: 1, thickness: 1, indent: 65),
                    _buildListOption(Icons.replay_circle_filled_outlined, const Color(0xff8772FE), 'Returns & Refunds', 'Track return and refund status'),
                    const Divider(height: 1, thickness: 1, indent: 65),
                    _buildListOption(CupertinoIcons.chat_bubble_text, const Color(0xff3B82F6), 'Messages', 'View your conversations'),
                    const Divider(height: 1, thickness: 1, indent: 65),
                    _buildListOption(Icons.headset_mic_outlined, const Color(0xff2DDA93), 'Help & Support', 'Get help and contact support'),
                    const Divider(height: 1, thickness: 1, indent: 65),
                    _buildListOption(CupertinoIcons.settings, const Color(0xff8772FE), 'Settings', 'Manage app preferences'),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    ref.read(currentUserProvider.notifier).logout();
                  },
                  child: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, Color color, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildListOption(IconData icon, Color iconColor, String title, String subtitle) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
    );
  }
}
