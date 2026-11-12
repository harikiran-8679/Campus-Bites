
import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'order_confirmation_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  AppState get appState => AppState.instance;

  String selectedOption = 'Pickup';

  void increaseQuantity(int index) {
    appState.updateQuantity(
      index,
      appState.cartItems[index].quantity + 1,
    );
  }

  void decreaseQuantity(int index) {
    appState.updateQuantity(
      index,
      appState.cartItems[index].quantity - 1,
    );
  }

  void removeItem(int index) {
    final itemName = appState.cartItems[index].name;
    appState.removeFromCart(index);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$itemName removed from cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void clearCart() {
    if (appState.cartItems.isEmpty) return;

    appState.clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cart cleared'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void openCheckout() {
    if (appState.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderConfirmationScreen(
          initialOrderType: selectedOption,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) {
        final cartItems = appState.cartItems;
        final subtotal = appState.subtotal;
        final deliveryFee =
        appState.deliveryFeeFor(selectedOption);
        final packagingFee = appState.packagingFee;
        final total =
        appState.totalAmountFor(selectedOption);

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            title: Text(
              'My Cart (${cartItems.length})',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              if (cartItems.isNotEmpty)
                IconButton(
                  onPressed: clearCart,
                  tooltip: 'Clear cart',
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.black,
                  ),
                ),
            ],
          ),
          body: cartItems.isEmpty
              ? _buildEmptyCart()
              : Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      'Choose Order Type',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _OptionCard(
                            icon: Icons.storefront_outlined,
                            title: 'Pickup',
                            subtitle: 'Collect from canteen',
                            selected:
                            selectedOption == 'Pickup',
                            onTap: () {
                              setState(() {
                                selectedOption = 'Pickup';
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _OptionCard(
                            icon: Icons.delivery_dining,
                            title: 'Delivery',
                            subtitle: 'Deliver to campus',
                            selected:
                            selectedOption == 'Delivery',
                            onTap: () {
                              setState(() {
                                selectedOption = 'Delivery';
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0E1),
                        borderRadius:
                        BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.local_shipping_outlined,
                            color: Color(0xFFFF6B00),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              selectedOption == 'Pickup'
                                  ? 'No delivery fee for Pickup!'
                                  : subtotal >= 300
                                  ? 'You get FREE delivery! 🎉'
                                  : 'Add ₹${300 - subtotal} more for FREE delivery',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Your Items',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ...List.generate(
                      cartItems.length,
                          (index) {
                        final item = cartItems[index];

                        return _CartItemCard(
                          name: item.name,
                          description: item.description,
                          price: item.price,
                          quantity: item.quantity,
                          emoji: item.emoji,
                          onIncrease: () =>
                              increaseQuantity(index),
                          onDecrease: () =>
                              decreaseQuantity(index),
                          onRemove: () =>
                              removeItem(index),
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: _showCouponDialog,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.local_offer_outlined,
                              color: Color(0xFFFF6B00),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Apply Coupon',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(18),
                      ),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Bill Details',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          _BillRow(
                            title: 'Item Total',
                            amount: '₹$subtotal',
                          ),
                          const SizedBox(height: 10),

                          _BillRow(
                            title: 'Delivery Fee',
                            amount: deliveryFee == 0
                                ? 'FREE'
                                : '₹$deliveryFee',
                            amountColor: deliveryFee == 0
                                ? Colors.green
                                : Colors.black,
                          ),
                          const SizedBox(height: 10),

                          _BillRow(
                            title: 'Packaging Fee',
                            amount: '₹$packagingFee',
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            child: Divider(),
                          ),

                          _BillRow(
                            title: 'Total',
                            amount: '₹$total',
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(
                  20, 12, 20, 20,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: openCheckout,
                      style: FilledButton.styleFrom(
                        backgroundColor:
                        const Color(0xFFFF6B00),
                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 17,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        'Proceed to Checkout • ₹$total',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0E1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 65,
                color: Color(0xFFFF6B00),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Looks like you haven\'t added anything to your cart yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 25),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Browse Menu',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCouponDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Apply Coupon'),
          content: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              hintText: 'Enter coupon code',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final code =
                controller.text.trim().toUpperCase();

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      code == 'CAMPUS20'
                          ? 'Coupon accepted! Discount calculation is not enabled yet.'
                          : 'Invalid coupon code',
                    ),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
              ),
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}

// Pickup / Delivery option card.
class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFFF0E1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? const Color(0xFFFF6B00)
                : Colors.grey.shade200,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 30,
              color: selected
                  ? const Color(0xFFFF6B00)
                  : Colors.grey,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Cart item card.
class _CartItemCard extends StatelessWidget {
  final String name;
  final String description;
  final int price;
  final int quantity;
  final String emoji;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.emoji,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0E1),
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 40),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '₹$price',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B00),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onPressed: onDecrease,
                    ),
                    SizedBox(
                      width: 38,
                      child: Center(
                        child: Text(
                          '$quantity',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add,
                      onPressed: onIncrease,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0E1),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 17,
          color: const Color(0xFFFF6B00),
        ),
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  final String title;
  final String amount;
  final bool isTotal;
  final Color? amountColor;

  const _BillRow({
    required this.title,
    required this.amount,
    this.isTotal = false,
    this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 17 : 14,
            fontWeight:
            isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal
                ? Colors.black
                : Colors.grey.shade700,
          ),
        ),
        const Spacer(),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 19 : 14,
            fontWeight:
            isTotal ? FontWeight.bold : FontWeight.w600,
            color: amountColor ??
                (isTotal
                    ? const Color(0xFFFF6B00)
                    : Colors.black),
          ),
        ),
      ],
    );
  }
}
