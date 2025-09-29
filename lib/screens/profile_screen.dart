import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Профиль пользователя
            _buildUserProfile(),
            const SizedBox(height: 40),
            // Настройки
            _buildSettingsSection(),
            const SizedBox(height: 32),
            // Кнопка выхода
            _buildLogoutButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Column(
      children: [
        // Иконка профиля вместо фото
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey[300]!, width: 2),
          ),
          child: Icon(
            Icons.person,
            size: 50,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        // Имя
        const Text(
          'John Doe',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        // Email
        Text(
          'john.doe@example.com',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account группа
          _buildSectionHeader('Account'),
          const SizedBox(height: 12),
          _buildSettingsCard([
            SettingsItem(
              icon: Icons.person,
              title: 'Personal Data',
              subtitle: 'Name, email, personal information',
              onTap: () => _onSettingsTap('Personal Data'),
            ),
            SettingsItem(
              icon: Icons.key,
              title: 'Security',
              onTap: () => _onSettingsTap('Security'),
            ),
          ]),

          const SizedBox(height: 24),

          // Plan группа
          _buildSectionHeader('Plan'),
          const SizedBox(height: 12),
          _buildSettingsCard([
            SettingsItem(
              icon: Icons.airplanemode_active,
              title: 'Free Plan',
              subtitle: 'Change plan',
              onTap: () => _onSettingsTap('Free Plan'),
            ),
          ]),

          const SizedBox(height: 24),

          // Billing группа
          _buildSectionHeader('Billing'),
          const SizedBox(height: 12),
          _buildSettingsCard([
            SettingsItem(
              icon: Icons.attach_money,
              title: 'Payment Method',
              onTap: () => _onSettingsTap('Payment Method'),
            ),
            SettingsItem(
              icon: Icons.shopping_cart,
              title: 'Order History',
              onTap: () => _onSettingsTap('Order History'),
            ),
          ]),

          const SizedBox(height: 24),

          // Support группа
          _buildSectionHeader('Support'),
          const SizedBox(height: 12),
          _buildSettingsCard([
            SettingsItem(
              icon: Icons.help_outline,
              title: 'Help',
              onTap: () => _onSettingsTap('Help'),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey[600],
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSettingsCard(List<SettingsItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1), // серая рамка вместо тени
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return Column(
            children: [
              _buildSettingsItem(item),
              if (!isLast)
                Divider(
                  height: 1,
                  color: Colors.grey[200],
                  indent: 72, // отступ слева (56px иконка + 16px padding)
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingsItem(SettingsItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Иконка в сером блоке
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.icon,
                  color: Colors.grey[700],
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              // Название и описание
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 2), // уменьшили отступ с 4 до 2
                      Text(
                        item.subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Стрелка
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: Material(
          color: Colors.red[600],
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _onLogoutTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Center(
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSettingsTap(String settingName) {
    // Обработка нажатий на настройки
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped on $settingName'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onLogoutTap() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Закрываем диалог
              Navigator.pop(context); // Возвращаемся на предыдущий экран
              // Здесь можно добавить логику выхода из аккаунта
            },
            child: Text(
              'Sign Out',
              style: TextStyle(color: Colors.red[600]),
            ),
          ),
        ],
      ),
    );
  }
}

// Модель для элемента настроек
class SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
}