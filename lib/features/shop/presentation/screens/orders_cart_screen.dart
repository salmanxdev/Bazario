import 'package:flutter/material.dart';
import 'package:bazario/core/services/cart_service.dart';
import 'package:bazario/core/services/order_service.dart';
import 'package:bazario/shared/models/cart_item_model.dart';
import 'package:bazario/shared/models/order_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class OrdersCartScreen extends StatefulWidget {
  const OrdersCartScreen({super.key});

  @override
  State<OrdersCartScreen> createState() => _OrdersCartScreenState();
}

  final CartService _cartService = CartService();
  final OrderService _orderService = OrderService();
  late Razorpay _razorpay;
  List<CartItem>? _currentCartItems;
  double? _currentTotal;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (_currentCartItems != null && _currentTotal != null) {
      await _orderService.placeOrder(_currentCartItems!, _currentTotal!);
      await _cartService.clearCart();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully!')),
        );
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Failed: ${response.message}')),
      );
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('External Wallet: ${response.walletName}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        title: const Text('Orders & Cart', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Your Orders Section
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Your Orders',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: StreamBuilder<List<OrderModel>>(
                      stream: _orderService.getOrders(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No orders yet', style: TextStyle(color: Colors.grey)));
                        }

                        final orders = snapshot.data!;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return Container(
                              width: 200,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.inventory_2_outlined, color: Colors.grey),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'Order #${order.id.length > 5 ? order.id.substring(0, 5).toUpperCase() : order.id}',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text('Status: ${order.status.toUpperCase()}', 
                                        style: const TextStyle(color: Colors.orange, fontSize: 12)),
                                    const SizedBox(height: 5),
                                    Text('Total: ₹${order.totalAmount}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const Divider(height: 1, thickness: 1),
          
          // Your Cart Section
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xffF9F9F9),
              child: StreamBuilder<List<CartItem>>(
                stream: _cartService.getCartItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final cartItems = snapshot.data ?? [];
                  double total = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Your Cart',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: cartItems.isEmpty 
                          ? const Center(child: Text('Your cart is empty'))
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                final item = cartItems[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          item.mediaUrl,
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                          errorBuilder: (c, e, s) => Container(
                                            width: 70, height: 70, color: Colors.grey.shade100,
                                            child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 5),
                                            Text('₹${item.price}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff6C63FF))),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () => _cartService.updateQuantity(item.id, -1), 
                                            icon: const Icon(Icons.remove_circle_outline, size: 20)
                                          ),
                                          Text('${item.quantity}'),
                                          IconButton(
                                            onPressed: () => _cartService.updateQuantity(item.id, 1), 
                                            icon: const Icon(Icons.add_circle_outline, size: 20)
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                      ),
                      if (cartItems.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Total', style: TextStyle(color: Colors.grey)),
                                  Text('₹$total', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _currentCartItems = cartItems;
                                  _currentTotal = total;
                                  
                                  var options = {
                                    'key': 'rzp_test_SeeglKzlUwB5rp',
                                    'amount': (total * 100).toInt(),
                                    'name': 'Bazario',
                                    'description': 'Purchase Items',
                                    'prefill': {
                                      'contact': '9876543210',
                                      'email': 'test@razorpay.com'
                                    }
                                  };

                                  try {
                                    _razorpay.open(options);
                                  } catch (e) {
                                    debugPrint('Error: $e');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff6C63FF),
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                                child: const Text('Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        )
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
