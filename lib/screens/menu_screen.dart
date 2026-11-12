import 'package:flutter/material.dart';
import 'food_details_screen.dart';
import 'cart_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedCategory = 'All';

  final List<Map<String, dynamic>> foods = [
    {
      'name': 'Veg Pizza',
      'description': 'Fresh vegetables & cheese',
      'price': 120,
      'category': 'Meals',
      'rating': 4.6,
      'emoji': '🍕',
    },
    {
      'name': 'Veg Burger',
      'description': 'Crispy patty with fresh veggies',
      'price': 60,
      'category': 'Snacks',
      'rating': 4.7,
      'emoji': '🍔',
    },
    {
      'name': 'French Fries',
      'description': 'Crispy golden potato fries',
      'price': 50,
      'category': 'Snacks',
      'rating': 4.5,
      'emoji': '🍟',
    },
    {
      'name': 'Veg Fried Rice',
      'description': 'Rice with fresh vegetables',
      'price': 100,
      'category': 'Meals',
      'rating': 4.6,
      'emoji': '🍚',
    },
    {
      'name': 'Veg Biryani',
      'description': 'Aromatic rice with vegetables',
      'price': 130,
      'category': 'Meals',
      'rating': 4.8,
      'emoji': '🍛',
    },
    {
      'name': 'Cold Coffee',
      'description': 'Chilled creamy coffee',
      'price': 70,
      'category': 'Drinks',
      'rating': 4.5,
      'emoji': '☕',
    },
    {
      'name': 'Fresh Lime Soda',
      'description': 'Refreshing lemon drink',
      'price': 40,
      'category': 'Drinks',
      'rating': 4.4,
      'emoji': '🥤',
    },
    {
      'name': 'Chocolate Cake',
      'description': 'Soft chocolate cake slice',
      'price': 80,
      'category': 'Desserts',
      'rating': 4.7,
      'emoji': '🍰',
    },
  ];

  List<Map<String, dynamic>> get filteredFoods {
    if (selectedCategory == 'All') {
      return foods;
    }

    return foods
        .where((food) => food['category'] == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Menu',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Text(
              'What are you craving?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Category buttons
          SizedBox(
            height: 48,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: [
                _categoryButton('All'),
                _categoryButton('Snacks'),
                _categoryButton('Meals'),
                _categoryButton('Drinks'),
                _categoryButton('Desserts'),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Expanded(
            child: filteredFoods.isEmpty
                ? const Center(
              child: Text(
                'No food items found',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: filteredFoods.length,
              itemBuilder: (context, index) {
                final food = filteredFoods[index];

                return _FoodMenuCard(
                  name: food['name'],
                  description: food['description'],
                  price: food['price'],
                  rating: food['rating'],
                  emoji: food['emoji'],

                  // Open Food Details
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return FoodDetailsScreen(
                            name: food['name'],
                            description: food['description'],
                            price: food['price'],
                            rating: food['rating'],
                            emoji: food['emoji'],
                          );
                        },
                      ),
                    );
                  },

                  // Temporary Add button
                  onAdd: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${food['name']} added to cart',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _categoryButton(String category) {
    final bool isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF6B00)
              : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF6B00)
                : Colors.grey.shade300,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          category,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _FoodMenuCard extends StatelessWidget {
  final String name;
  final String description;
  final int price;
  final double rating;
  final String emoji;
  final VoidCallback onAdd;
  final VoidCallback onTap;

  const _FoodMenuCard({
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.emoji,
    required this.onAdd,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Food image
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E1),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  emoji,
                  style: const TextStyle(
                    fontSize: 48,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Food information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.orange,
                        ),

                        const SizedBox(width: 3),

                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          '₹$price',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B00),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Add button
              IconButton(
                onPressed: onAdd,
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B00),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(
                  Icons.add,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}