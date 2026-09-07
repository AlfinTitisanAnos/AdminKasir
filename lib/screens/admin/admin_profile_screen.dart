import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil & Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50, backgroundColor: Colors.green,
                  child: Text(auth.user?.name.substring(0, 1) ?? 'A', style: const TextStyle(fontSize: 40, color: Colors.white)),
                ),
                const SizedBox(height: 16),
                Text(auth.user?.name ?? 'User', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(auth.user?.email ?? '', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text(auth.user?.role.toUpperCase() ?? '', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text('Akun', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline), title: const Text('Edit Profil'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showEditProfileDialog(context, auth),
                ),
                ListTile(
                  leading: const Icon(Icons.lock_outline), title: const Text('Ganti Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showChangePasswordDialog(context, auth),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Pengaturan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode'), secondary: const Icon(Icons.dark_mode),
              value: theme.themeMode == ThemeMode.dark, onChanged: (val) => theme.toggleTheme(),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              auth.logout();
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            icon: const Icon(Icons.logout), label: const Text('Keluar'),
          )
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, AuthProvider auth) {
    final nameCtrl = TextEditingController(text: auth.user?.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profil'),
        content: TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nama Lengkap')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              auth.updateProfile(nameCtrl.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil diperbarui!')));
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, AuthProvider auth) {
    final passCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ganti Password'),
        content: TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Password Baru')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (passCtrl.text.length < 4) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password minimal 4 karakter'), backgroundColor: Colors.red));
                return;
              }
              auth.updatePassword(passCtrl.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password diperbarui!')));
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}