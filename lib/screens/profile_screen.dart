
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Kiran';
  String userEmail = 'kiran@example.com';
  String phoneNumber = '+91 98765 43210';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Load saved profile details
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      userName = prefs.getString('profile_name') ?? 'Kiran';
      userEmail =
          prefs.getString('profile_email') ?? 'kiran@example.com';
      phoneNumber =
          prefs.getString('profile_phone') ?? '+91 98765 43210';

      isLoading = false;
    });
  }

  // Save profile details
  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('profile_name', userName);
    await prefs.setString('profile_email', userEmail);
    await prefs.setString('profile_phone', phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFFF6B00),
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 52,
                        backgroundColor: Color(0xFFFFF0E1),
                        child: Icon(
                          Icons.person,
                          size: 62,
                          color: Color(0xFFFF6B00),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: _editProfile,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF6B00),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    userEmail,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    phoneNumber,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 15),

                  OutlinedButton.icon(
                    onPressed: _editProfile,
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                    ),
                    label: const Text('Edit Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF6B00),
                      side: const BorderSide(
                        color: Color(0xFFFF6B00),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // My Account Section
            _sectionTitle('My Account'),

            _ProfileTile(
              icon: Icons.shopping_bag_outlined,
              title: 'My Orders',
              subtitle: 'View your order history',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const OrderHistoryScreen(),
                  ),
                );
              },
            ),

            _ProfileTile(
              icon: Icons.favorite_border,
              title: 'Favorites',
              subtitle: 'Your favorite food items',
              onTap: () {
                _showMessage('Favorites coming soon');
              },
            ),

            _ProfileTile(
              icon: Icons.local_offer_outlined,
              title: 'My Coupons',
              subtitle: 'View available offers',
              onTap: _showCoupons,
            ),

            const SizedBox(height: 10),

            // Preferences Section
            _sectionTitle('Preferences'),

            _ProfileTile(
              icon: Icons.notifications_none,
              title: 'Notifications',
              subtitle: 'Manage your notifications',
              trailing: Switch(
                value: true,
                  activeThumbColor: const Color(0xFFFF6B00),
                onChanged: (value) {
                  _showMessage(
                    value
                        ? 'Notifications enabled'
                        : 'Notifications disabled',
                  );
                },
              ),
              onTap: () {},
            ),

            _ProfileTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'App preferences and settings',
              onTap: _showSettings,
            ),

            const SizedBox(height: 10),

            // Support Section
            _sectionTitle('Support'),

            _ProfileTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help with your order',
              onTap: _showSupport,
            ),

            _ProfileTile(
              icon: Icons.info_outline,
              title: 'About CampusBites',
              subtitle: 'Version 1.0.0',
              onTap: _showAbout,
            ),

            const SizedBox(height: 15),

            // Logout Button
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.red.shade200,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Section Title
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Edit Profile
  void _editProfile() {
    final nameController = TextEditingController(text: userName);
    final emailController = TextEditingController(text: userEmail);
    final phoneController = TextEditingController(text: phoneNumber);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: Icon(Icons.phone_outlined),
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
              child: const Text('Cancel'),
            ),

            FilledButton(
              onPressed: () async {
                final newName = nameController.text.trim();
                final newEmail = emailController.text.trim();
                final newPhone = phoneController.text.trim();

                if (newName.isEmpty ||
                    newEmail.isEmpty ||
                    newPhone.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                    ),
                  );
                  return;
                }

                setState(() {
                  userName = newName;
                  userEmail = newEmail;
                  phoneNumber = newPhone;
                });

                try {
                  await _saveProfile();

                  if (!mounted || !dialogContext.mounted) return;

                  Navigator.pop(dialogContext);

                  _showMessage('Profile updated successfully');
                } catch (e) {
                  if (!mounted) return;

                  _showMessage('Could not save profile details');
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    ).then((_) {
      // Dispose controllers after the dialog closing animation.
      Future.delayed(const Duration(milliseconds: 500), () {
        nameController.dispose();
        emailController.dispose();
        phoneController.dispose();
      });
    });
  }

  // Coupons
  void _showCoupons() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Available Coupons'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CouponCard(
                code: 'CAMPUS20',
                description: '20% OFF on your first order',
              ),

              const SizedBox(height: 10),

              _CouponCard(
                code: 'FOOD50',
                description: '₹50 OFF on orders above ₹300',
              ),
            ],
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
  }

  // Settings
  void _showSettings() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              ListTile(
                leading: const Icon(
                  Icons.language,
                  color: Color(0xFFFF6B00),
                ),
                title: const Text('Language'),
                subtitle: const Text('English'),
                onTap: () {},
              ),

              ListTile(
                leading: const Icon(
                  Icons.dark_mode_outlined,
                  color: Color(0xFFFF6B00),
                ),
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: false,
                  activeThumbColor: const Color(0xFFFF6B00),
                  onChanged: (value) {},
                ),
              ),

              ListTile(
                leading: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFFFF6B00),
                ),
                title: const Text('Privacy'),
                onTap: () {},
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Help & Support
  void _showSupport() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Help & Support'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.chat_outlined,
                  color: Color(0xFFFF6B00),
                ),
                title: Text('Live Chat'),
                subtitle: Text(
                  'Chat with our support team',
                ),
              ),

              ListTile(
                leading: Icon(
                  Icons.email_outlined,
                  color: Color(0xFFFF6B00),
                ),
                title: Text('Email'),
                subtitle: Text(
                  'support@campusbites.com',
                ),
              ),

              ListTile(
                leading: Icon(
                  Icons.phone_outlined,
                  color: Color(0xFFFF6B00),
                ),
                title: Text('Phone'),
                subtitle: Text(
                  '+91 1800 123 4567',
                ),
              ),
            ],
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
  }

  // About CampusBites
  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'CampusBites',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.restaurant,
        color: Color(0xFFFF6B00),
        size: 40,
      ),
      children: const [
        Text(
          'CampusBites is a campus food ordering '
              'application designed to make ordering '
              'food from your college canteen simple '
              'and convenient.',
        ),
      ],
    );
  }

  // Logout
  void _logout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                _showMessage('Logged out successfully');
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // Show Message
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

// Reusable Profile Tile
class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 3,
          ),
          leading: Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0E1),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: const Color(0xFFFF6B00),
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          trailing: trailing ??
              const Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Colors.grey,
              ),
        ),
      ),
    );
  }
}

// Coupon Card
class _CouponCard extends StatelessWidget {
  final String code;
  final String description;

  const _CouponCard({
    required this.code,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0E1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_offer,
            color: Color(0xFFFF6B00),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  code,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B00),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
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
