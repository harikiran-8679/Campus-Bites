
import 'package:flutter/material.dart';
import '../state/app_state.dart';

class FoodDetailsScreen extends StatefulWidget {
  final String name;
  final String description;
  final int price;
  final double rating;
  final String emoji;

  const FoodDetailsScreen({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.emoji,
  });

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  int quantity = 1;

  int get totalPrice => widget.price * quantity;

  @override
  Widget build(BuildContext context) {
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
          'Food Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.black,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Food Image
            Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0E1),
                borderRadius: BorderRadius.circular(28),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.emoji,
                style: const TextStyle(
                  fontSize: 120,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Name
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Rating
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 21,
                ),
                const SizedBox(width: 5),
                Text(
                  widget.rating.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '• 128 reviews',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Price
            Text(
              '₹${widget.price}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B00),
              ),
            ),

            const SizedBox(height: 18),

            // Description
            const Text(
              'About this item',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.description,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 24),

            // Ingredients
            const Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('Fresh Vegetables')),
                Chip(label: Text('Cheese')),
                Chip(label: Text('Sauce')),
                Chip(label: Text('Special Seasoning')),
              ],
            ),

            const SizedBox(height: 25),

            // Quantity
            const Text(
              'Quantity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                IconButton(
                  onPressed: quantity > 1
                      ? () {
                    setState(() {
                      quantity--;
                    });
                  }
                      : null,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.remove),
                ),

                Container(
                  width: 55,
                  alignment: Alignment.center,
                  child: Text(
                    '$quantity',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Add To Cart
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  AppState.instance.addToCart(
                    name: widget.name,
                    description: widget.description,
                    price: widget.price,
                    rating: widget.rating,
                    emoji: widget.emoji,
                    quantity: quantity,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$quantity × ${widget.name} added to cart • ₹$totalPrice',
                      ),
                    ),
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
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                ),
                label: Text(
                  'Add to Cart • ₹$totalPrice',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
