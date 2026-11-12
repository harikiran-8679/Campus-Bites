
import 'package:flutter/material.dart';
import '../state/app_state.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String initialOrderType;

  const OrderConfirmationScreen({
    super.key,
    this.initialOrderType = 'Pickup',
  });

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState
    extends State<OrderConfirmationScreen> {
  String selectedPayment = 'UPI';
  late String selectedOption;

  bool isPlacingOrder = false;

  AppState get appState => AppState.instance;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.initialOrderType;
  }

  int get subtotal => appState.subtotal;

  int get deliveryFee =>
      appState.deliveryFeeFor(selectedOption);

  int get packagingFee => appState.packagingFee;

  int get total =>
      appState.totalAmountFor(selectedOption);

  Future<void> placeOrder() async {
    if (appState.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
        ),
      );
      Navigator.pop(context);
      return;
    }

    setState(() {
      isPlacingOrder = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final order = appState.placeOrder(
      orderType: selectedOption,
      paymentMethod: selectedPayment,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSuccessScreen(
          orderId: order.id,
          totalAmount: order.totalAmount,
          paymentMethod: order.paymentMethod,
          orderOption: order.orderType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) {
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
            title: const Text(
              'Checkout',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      ...appState.cartItems.map(
                            (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _SummaryRow(
                            name: '${item.name} × ${item.quantity}',
                            price: '₹${item.itemTotal}',
                          ),
                        ),
                      ),

                      const Divider(height: 20),

                      _SummaryRow(
                        name: 'Item Total',
                        price: '₹$subtotal',
                      ),
                      const SizedBox(height: 10),

                      _SummaryRow(
                        name: 'Delivery Fee',
                        price: deliveryFee == 0
                            ? 'FREE'
                            : '₹$deliveryFee',
                        valueColor: deliveryFee == 0
                            ? Colors.green
                            : Colors.black,
                      ),
                      const SizedBox(height: 10),

                      _SummaryRow(
                        name: 'Packaging Fee',
                        price: '₹$packagingFee',
                      ),
                      const Divider(height: 28),

                      _SummaryRow(
                        name: 'Total',
                        price: '₹$total',
                        isTotal: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Order Type',
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
                        selected: selectedOption == 'Pickup',
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
                        selected: selectedOption == 'Delivery',
                        onTap: () {
                          setState(() {
                            selectedOption = 'Delivery';
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                _PaymentOption(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'UPI',
                  subtitle: 'Google Pay, PhonePe, Paytm',
                  value: 'UPI',
                  groupValue: selectedPayment,
                  onChanged: (value) {
                    setState(() {
                      selectedPayment = value;
                    });
                  },
                ),
                const SizedBox(height: 10),

                _PaymentOption(
                  icon: Icons.credit_card_outlined,
                  title: 'Card',
                  subtitle: 'Credit or Debit Card',
                  value: 'Card',
                  groupValue: selectedPayment,
                  onChanged: (value) {
                    setState(() {
                      selectedPayment = value;
                    });
                  },
                ),
                const SizedBox(height: 10),

                _PaymentOption(
                  icon: Icons.payments_outlined,
                  title: 'Cash',
                  subtitle: 'Pay at the canteen',
                  value: 'Cash',
                  groupValue: selectedPayment,
                  onChanged: (value) {
                    setState(() {
                      selectedPayment = value;
                    });
                  },
                ),

                const SizedBox(height: 25),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0E1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFFFF6B00),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedOption == 'Pickup'
                                  ? 'Pickup Location'
                                  : 'Delivery Location',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              selectedOption == 'Pickup'
                                  ? 'Main Campus Canteen'
                                  : 'College Campus',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed:
                    isPlacingOrder ? null : placeOrder,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B00),
                      disabledBackgroundColor:
                      Colors.orange.shade200,
                      padding: const EdgeInsets.symmetric(
                        vertical: 17,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: isPlacingOrder
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      'Place Order • ₹$total',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                const Center(
                  child: Text(
                    'Your order is safe and secure',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Summary row.
class _SummaryRow extends StatelessWidget {
  final String name;
  final String price;
  final bool isTotal;
  final Color? valueColor;

  const _SummaryRow({
    required this.name,
    required this.price,
    this.isTotal = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              fontSize: isTotal ? 17 : 14,
              fontWeight: isTotal
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: isTotal ? 19 : 14,
            fontWeight: FontWeight.bold,
            color: valueColor ??
                (isTotal
                    ? const Color(0xFFFF6B00)
                    : Colors.black),
          ),
        ),
      ],
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

// Payment option.
class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? const Color(0xFFFF6B00)
                : Colors.grey.shade200,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: selected
                  ? const Color(0xFFFF6B00)
                  : Colors.grey,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            RadioGroup<String>(
              groupValue: groupValue,
              onChanged: (newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
              child: Radio<String>(
                value: value,
                activeColor: const Color(0xFFFF6B00),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Order success screen.
class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final int totalAmount;
  final String paymentMethod;
  final String orderOption;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.totalAmount,
    required this.paymentMethod,
    required this.orderOption,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const SizedBox(height: 35),
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F7EC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 85,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Order Placed!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your food is being prepared.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Order ID',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        orderId,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6B00),
                        ),
                      ),
                      const Divider(height: 30),
                      _SuccessRow(
                        title: 'Total Amount',
                        value: '₹$totalAmount',
                      ),
                      const SizedBox(height: 12),
                      _SuccessRow(
                        title: 'Payment',
                        value: paymentMethod,
                      ),
                      const SizedBox(height: 12),
                      _SuccessRow(
                        title: 'Order Type',
                        value: orderOption,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0E1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Color(0xFFFF6B00),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Estimated preparation time: 15–20 minutes',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                            (route) => route.isFirst,
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B00),
                      padding: const EdgeInsets.symmetric(
                        vertical: 17,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                OutlinedButton(
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                          (route) => route.isFirst,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFF6B00),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text('Continue Shopping'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessRow extends StatelessWidget {
  final String title;
  final String value;

  const _SuccessRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
