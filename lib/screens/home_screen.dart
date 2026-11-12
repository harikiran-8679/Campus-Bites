import 'package:flutter/material.dart';

import 'menu_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'food_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = 'Kiran';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      userName = prefs.getString('profile_name') ?? 'Kiran';
    });
  }

  void _openMenu(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const MenuScreen(),
      ),
    );
  }

  void _openCart(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CartScreen(),
      ),
    );
  }

  void _openProfile(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ProfileScreen(),
      ),
    );

    await _loadUserName();
  }

  void _openFoodDetails(
      BuildContext context, {
        required String name,
        required String description,
        required int price,
        required double rating,
        required String emoji,
      }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FoodDetailsScreen(
          name: name,
          description: description,
          price: price,
          rating: rating,
          emoji: emoji,
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            15,
            20,
            25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Mark all read',
                      style: TextStyle(
                        color: Color(0xFFFF6B00),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _NotificationItem(
                icon: Icons.local_offer_outlined,
                title: '20% OFF on your first order!',
                message: 'Use code CAMPUS20',
              ),
              const _NotificationItem(
                icon: Icons.restaurant_outlined,
                title: 'New food items available',
                message:
                'Check out today\'s special menu.',
              ),
              const _NotificationItem(
                icon: Icons.access_time,
                title: 'Fast pickup available',
                message:
                'Get your order ready in 15–20 minutes.',
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSearch(BuildContext context) {
    final controller = TextEditingController();

    final List<Map<String, dynamic>> foods = [
      {
        'name': 'Veg Pizza',
        'description': 'Fresh vegetables & cheese',
        'price': 120,
        'rating': 4.6,
        'emoji': '🍕',
      },
      {
        'name': 'Veg Burger',
        'description':
        'Crispy patty with fresh veggies',
        'price': 60,
        'rating': 4.7,
        'emoji': '🍔',
      },
      {
        'name': 'Cold Coffee',
        'description': 'Chilled creamy coffee',
        'price': 70,
        'rating': 4.5,
        'emoji': '☕',
      },
      {
        'name': 'French Fries',
        'description':
        'Crispy golden potato fries',
        'price': 50,
        'rating': 4.5,
        'emoji': '🍟',
      },
      {
        'name': 'Veg Biryani',
        'description':
        'Aromatic rice with vegetables',
        'price': 130,
        'rating': 4.8,
        'emoji': '🍛',
      },
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final query =
            controller.text.trim().toLowerCase();

            final results = query.isEmpty
                ? foods
                : foods.where((food) {
              return food['name']
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
                  food['description']
                      .toString()
                      .toLowerCase()
                      .contains(query);
            }).toList();

            return AlertDialog(
              title: const Text(
                'Search Food',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller,
                      autofocus: true,
                      onChanged: (_) {
                        setDialogState(() {});
                      },
                      decoration: InputDecoration(
                        hintText:
                        'Search pizza, burger...',
                        prefixIcon:
                        const Icon(Icons.search),
                        suffixIcon:
                        controller.text.isNotEmpty
                            ? IconButton(
                          onPressed: () {
                            controller.clear();
                            setDialogState(
                                  () {},
                            );
                          },
                          icon: const Icon(
                            Icons.clear,
                          ),
                        )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (results.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'No food found',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 280,
                        child: ListView.builder(
                          itemCount: results.length,
                          itemBuilder:
                              (context, index) {
                            final food =
                            results[index];

                            return ListTile(
                              contentPadding:
                              const EdgeInsets
                                  .symmetric(
                                vertical: 4,
                              ),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration:
                                BoxDecoration(
                                  color: const Color(
                                    0xFFFFF0E1,
                                  ),
                                  borderRadius:
                                  BorderRadius
                                      .circular(12),
                                ),
                                alignment:
                                Alignment.center,
                                child: Text(
                                  food['emoji'],
                                  style:
                                  const TextStyle(
                                    fontSize: 27,
                                  ),
                                ),
                              ),
                              title: Text(
                                food['name'],
                                style:
                                const TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '₹${food['price']} • ⭐ ${food['rating']}',
                              ),
                              onTap: () {
                                Navigator.pop(
                                  dialogContext,
                                );

                                _openFoodDetails(
                                  context,
                                  name: food['name'],
                                  description:
                                  food['description'],
                                  price: food['price'],
                                  rating: food['rating'],
                                  emoji: food['emoji'],
                                );
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Food',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _FilterChipButton(
                    title: 'All',
                    onTap: () {
                      Navigator.pop(context);
                      _openMenu(context);
                    },
                  ),
                  _FilterChipButton(
                    title: 'Snacks',
                    onTap: () {
                      Navigator.pop(context);
                      _openMenu(context);
                    },
                  ),
                  _FilterChipButton(
                    title: 'Meals',
                    onTap: () {
                      Navigator.pop(context);
                      _openMenu(context);
                    },
                  ),
                  _FilterChipButton(
                    title: 'Drinks',
                    onTap: () {
                      Navigator.pop(context);
                      _openMenu(context);
                    },
                  ),
                  _FilterChipButton(
                    title: 'Desserts',
                    onTap: () {
                      Navigator.pop(context);
                      _openMenu(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Quick Filters',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _QuickFilterTile(
                icon: Icons.star,
                title: 'Top Rated',
                onTap: () {
                  Navigator.pop(context);
                  _openMenu(context);
                },
              ),
              _QuickFilterTile(
                icon: Icons.currency_rupee,
                title: 'Budget Friendly',
                onTap: () {
                  Navigator.pop(context);
                  _openMenu(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'CampusBites',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'College Canteen',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showNotifications(context);
            },
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () {
              _openProfile(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 19,
                backgroundColor:
                Color(0xFFFFE4CC),
                child: Icon(
                  Icons.person,
                  color: Color(0xFFFF6B00),
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning, $userName 👋',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'What would you like to eat today?',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 22),

            // Search + Filter
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showSearch(context);
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Search for food...',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                  IconButton(
                    onPressed: () {
                      _showFilters(context);
                    },
                    icon: const Icon(
                      Icons.tune,
                      color: Color(0xFFFF6B00),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Offer banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF7A00),
                    Color(0xFFFF9E42),
                  ],
                ),
                borderRadius:
                BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hungry?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Get 20% OFF on your first order!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Use code: CAMPUS20',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '🍔',
                    style: TextStyle(fontSize: 65),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Categories
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _openMenu(context);
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: Color(0xFFFF6B00),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 105,
              child: ListView(
                scrollDirection:
                Axis.horizontal,
                children: [
                  _CategoryCard(
                    emoji: '🍔',
                    title: 'Snacks',
                    onTap: () {
                      _openMenu(context);
                    },
                  ),
                  _CategoryCard(
                    emoji: '🍚',
                    title: 'Meals',
                    onTap: () {
                      _openMenu(context);
                    },
                  ),
                  _CategoryCard(
                    emoji: '🥤',
                    title: 'Drinks',
                    onTap: () {
                      _openMenu(context);
                    },
                  ),
                  _CategoryCard(
                    emoji: '🍰',
                    title: 'Desserts',
                    onTap: () {
                      _openMenu(context);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Popular
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Today',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _openMenu(context);
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: Color(0xFFFF6B00),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            _FoodCard(
              emoji: '🍕',
              name: 'Veg Pizza',
              description:
              'Fresh vegetables & cheese',
              price: '₹120',
              rating: '4.6',
              onTap: () {
                _openFoodDetails(
                  context,
                  name: 'Veg Pizza',
                  description:
                  'Fresh vegetables & cheese',
                  price: 120,
                  rating: 4.6,
                  emoji: '🍕',
                );
              },
            ),

            _FoodCard(
              emoji: '🍔',
              name: 'Veg Burger',
              description:
              'Crispy patty with fresh veggies',
              price: '₹60',
              rating: '4.7',
              onTap: () {
                _openFoodDetails(
                  context,
                  name: 'Veg Burger',
                  description:
                  'Crispy patty with fresh veggies',
                  price: 60,
                  rating: 4.7,
                  emoji: '🍔',
                );
              },
            ),

            _FoodCard(
              emoji: '☕',
              name: 'Cold Coffee',
              description:
              'Chilled creamy coffee',
              price: '₹70',
              rating: '4.5',
              onTap: () {
                _openFoodDetails(
                  context,
                  name: 'Cold Coffee',
                  description:
                  'Chilled creamy coffee',
                  price: 70,
                  rating: 4.5,
                  emoji: '☕',
                );
              },
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              break;

            case 1:
              _openMenu(context);
              break;

            case 2:
              _openCart(context);
              break;

            case 3:
              _openProfile(context);
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.restaurant_menu_outlined,
            ),
            selectedIcon: Icon(
              Icons.restaurant_menu,
            ),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.shopping_cart_outlined,
            ),
            selectedIcon: Icon(
              Icons.shopping_cart,
            ),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
            ),
            selectedIcon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Category Card

class _CategoryCard extends StatelessWidget {
  final String emoji;
  final String title;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.emoji,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 95,
        margin: const EdgeInsets.only(
          right: 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0E1),
          borderRadius:
          BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(
                fontSize: 35,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Food Card

class _FoodCard extends StatelessWidget {
  final String emoji;
  final String name;
  final String description;
  final String price;
  final String rating;
  final VoidCallback onTap;

  const _FoodCard({
    required this.emoji,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(
          bottom: 14,
        ),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E1),
                  borderRadius:
                  BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Text(
                  emoji,
                  style: const TextStyle(
                    fontSize: 45,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 17,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 3),
                        Text(rating),
                        const Spacer(),
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight:
                            FontWeight.bold,
                            color:
                            Color(0xFFFF6B00),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Notification Item

class _NotificationItem
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F2),
        borderRadius:
        BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE5CF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFFFF6B00),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Filter Chip

class _FilterChipButton
    extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0E1),
          borderRadius:
          BorderRadius.circular(25),
          border: Border.all(
            color: const Color(0xFFFF6B00),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFFF6B00),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// Quick Filter

class _QuickFilterTile
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickFilterTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      leading: Icon(
        icon,
        color: const Color(0xFFFF6B00),
      ),
      title: Text(title),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15,
      ),
    );
  }
}