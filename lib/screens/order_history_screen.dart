
import 'package:flutter/material.dart';
import '../state/app_state.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() =>
      _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final Color orange = const Color(0xFFFF6B00);
  final Color background = const Color(0xFFFAFAFA);
  final Color lightOrange = const Color(0xFFFFF0E1);

  String selectedFilter = 'All';

  AppState get appState => AppState.instance;

  List<CampusOrder> get filteredOrders {
    if (selectedFilter == 'All') {
      return appState.orders;
    }

    return appState.orders
        .where((order) => order.status == selectedFilter)
        .toList();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'Preparing':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr',
      'May', 'Jun', 'Jul', 'Aug',
      'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String getItemNames(CampusOrder order) {
    return order.items.map((item) => item.name).join(', ');
  }

  int getTotalQuantity(CampusOrder order) {
    return order.items.fold(
      0,
          (sum, item) => sum + item.quantity,
    );
  }

  String getFirstEmoji(CampusOrder order) {
    if (order.items.isEmpty) return '🍽️';
    return order.items.first.emoji;
  }

  void showOrderDetails(CampusOrder order) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Order Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order ID: ${order.id}'),
                const SizedBox(height: 12),
                Text('Date: ${formatDate(order.placedAt)}'),
                const SizedBox(height: 12),
                Text('Items: ${getItemNames(order)}'),
                const SizedBox(height: 12),
                Text('Quantity: ${getTotalQuantity(order)}'),
                const SizedBox(height: 12),
                Text('Total: ₹${order.totalAmount}'),
                const SizedBox(height: 12),
                Text('Order Type: ${order.orderType}'),
                const SizedBox(height: 12),
                Text('Payment: ${order.paymentMethod}'),
                const SizedBox(height: 12),
                Text('Status: ${order.status}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Close',
                style: TextStyle(color: orange),
              ),
            ),
          ],
        );
      },
    );
  }

  void reorder(CampusOrder order) {
    for (final item in order.items) {
      appState.addToCart(
        name: item.name,
        description: item.description,
        price: item.price,
        rating: item.rating,
        emoji: item.emoji,
        quantity: item.quantity,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Items added to your cart!'),
        backgroundColor: Color(0xFFFF6B00),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filters = [
      'All',
      'Preparing',
      'Delivered',
      'Cancelled',
    ];

    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) {
        final currentOrders = filteredOrders;

        return Scaffold(
          backgroundColor: background,

          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'My Orders',
              style: TextStyle(
                color: Colors.black,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20, 22, 20, 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Orders 🛍️',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF29211D),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Track and manage your food orders',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 48,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  separatorBuilder: (_, _) =>
                  const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    final isSelected =
                        selectedFilter == filter;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? orange
                              : Colors.white,
                          borderRadius:
                          BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected
                                ? orange
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: currentOrders.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '📦',
                        style: TextStyle(fontSize: 55),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No orders found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your orders will appear here.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    16, 8, 16, 24,
                  ),
                  itemCount: currentOrders.length,
                  itemBuilder: (context, index) {
                    final order = currentOrders[index];
                    final status = order.status;
                    final statusColor =
                    getStatusColor(status);

                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                order.id,
                                style: const TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Container(
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal: 11,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.1),
                                  borderRadius:
                                  BorderRadius
                                      .circular(20),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight:
                                    FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Text(
                            formatDate(order.placedAt),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Container(
                                height: 62,
                                width: 62,
                                decoration: BoxDecoration(
                                  color: lightOrange,
                                  borderRadius:
                                  BorderRadius
                                      .circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    getFirstEmoji(order),
                                    style:
                                    const TextStyle(
                                      fontSize: 32,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text(
                                      getItemNames(order),
                                      style:
                                      const TextStyle(
                                        fontWeight:
                                        FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      '${getTotalQuantity(order)} items',
                                      style: TextStyle(
                                        color: Colors
                                            .grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Text(
                                '₹${order.totalAmount}',
                                style: TextStyle(
                                  color: orange,
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            child: Divider(height: 1),
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () =>
                                      showOrderDetails(
                                          order),
                                  style:
                                  OutlinedButton.styleFrom(
                                    foregroundColor: orange,
                                    side: BorderSide(
                                      color: orange,
                                    ),
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius
                                          .circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'View Details',
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: ElevatedButton(
                                  onPressed:
                                  status == 'Cancelled'
                                      ? null
                                      : () => reorder(
                                      order),
                                  style:
                                  ElevatedButton.styleFrom(
                                    backgroundColor: orange,
                                    foregroundColor:
                                    Colors.white,
                                    disabledBackgroundColor:
                                    Colors.grey.shade300,
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius
                                          .circular(10),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Reorder',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
