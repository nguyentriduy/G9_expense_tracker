import 'package:expense_tracker_app/core/theme/app_theme_controller.dart';
import 'package:expense_tracker_app/providers/transaction_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.themeController,
    this.onSignedOut,
  });

  final AppThemeController themeController;
  final Future<void> Function(BuildContext context)? onSignedOut;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = (user?.displayName?.trim().isNotEmpty ?? false)
        ? user!.displayName!.trim()
        : 'Người dùng';
    final email = (user?.email?.trim().isNotEmpty ?? false)
        ? user!.email!.trim()
        : 'Chưa có email';

    return AnimatedBuilder(
      animation: themeController,
      builder: (context, child) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          children: [
            Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                title: Text(
                  displayName,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(email),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tùy chỉnh cá nhân',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    title: Text('Tiền tệ mặc định'),
                    subtitle: Text('VND (Việt Nam Đồng)'),
                    leading: Icon(Icons.currency_exchange),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    title: Text('Ngôn ngữ giao diện'),
                    subtitle: Text('Tiếng Việt'),
                    leading: Icon(Icons.language),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.dark_mode_outlined),
                    title: const Text('Chế độ giao diện'),
                    subtitle: const Text('Chọn sáng, tối hoặc theo hệ thống'),
                    trailing: DropdownButton<ThemeMode>(
                      value: themeController.themeMode,
                      underline: const SizedBox.shrink(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        themeController.setThemeMode(value);
                      },
                      items: const [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text('Hệ thống'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text('Sáng'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text('Tối'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ListTile(
              tileColor: Theme.of(context).colorScheme.errorContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                'Đăng xuất',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () async {
                try {
                    // Clear local transaction state before signing out so
                    // data from one account doesn't appear in another.
                    try {
                      await context.read<TransactionProvider>().clearAll();
                    } catch (_) {
                      // Ignore provider errors during sign out.
                    }
                  try {
                    await GoogleSignIn().signOut();
                  } catch (_) {
                    // Bỏ qua lỗi Google Sign In
                  }
                  await FirebaseAuth.instance.signOut();
                  if (!context.mounted) {
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã đăng xuất thành công')),
                  );
                  if (onSignedOut != null) {
                    await onSignedOut!(context);
                  }
                } catch (e) {
                  if (!context.mounted) {
                    return;
                  }
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Lỗi đăng xuất: $e')));
                }
              },
            ),
          ],
        );
      },
    );
  }
}
