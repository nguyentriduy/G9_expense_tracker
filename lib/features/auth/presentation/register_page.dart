import 'package:expense_tracker_app/app/app_router.dart';
import 'package:expense_tracker_app/core/firebase/firestore_bootstrap_service.dart';
<<<<<<< HEAD
import 'package:expense_tracker_app/core/localization/app_localization.dart';
=======
>>>>>>> origin/feature/categories
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(_nameController.text.trim());
        await FirestoreBootstrapService().ensureUserStructure(user);
      }

      if (!context.mounted) {
        return;
      }
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (r) => false);
    } on FirebaseAuthException catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
        SnackBar(
          content: Text(
            context.t('register_failed', {'error': error.message ?? 'unknown'}),
          ),
        ),
=======
        SnackBar(content: Text('Đăng ký thất bại: ${error.message}')),
>>>>>>> origin/feature/categories
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(title: Text(context.t('create_account'))),
=======
      appBar: AppBar(title: const Text('Tạo tài khoản')),
>>>>>>> origin/feature/categories
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
<<<<<<< HEAD
                  context.t('start_finance_journey'),
=======
                  'Bắt đầu hành trình tài chính',
>>>>>>> origin/feature/categories
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
<<<<<<< HEAD
                  context.t('register_sync_desc'),
=======
                  'Tạo tài khoản để đồng bộ dữ liệu thu chi trên Firebase.',
>>>>>>> origin/feature/categories
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
<<<<<<< HEAD
                            decoration: InputDecoration(
                              labelText: context.t('full_name'),
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                            validator: (value) {
                              if ((value?.trim().isEmpty ?? true)) {
                                return context.t('enter_full_name');
=======
                            decoration: const InputDecoration(
                              labelText: 'Họ tên',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (value) {
                              if ((value?.trim().isEmpty ?? true)) {
                                return 'Vui lòng nhập họ tên';
>>>>>>> origin/feature/categories
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
<<<<<<< HEAD
                            decoration: InputDecoration(
                              labelText: context.t('email'),
                              prefixIcon: const Icon(Icons.alternate_email),
=======
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.alternate_email),
>>>>>>> origin/feature/categories
                            ),
                            validator: (value) {
                              final text = value?.trim() ?? '';
                              if (text.isEmpty || !text.contains('@')) {
<<<<<<< HEAD
                                return context.t('enter_valid_email');
=======
                                return 'Vui lòng nhập email hợp lệ';
>>>>>>> origin/feature/categories
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
<<<<<<< HEAD
                            decoration: InputDecoration(
                              labelText: context.t('password'),
                              prefixIcon: const Icon(Icons.lock_outline),
=======
                            decoration: const InputDecoration(
                              labelText: 'Mật khẩu',
                              prefixIcon: Icon(Icons.lock_outline),
>>>>>>> origin/feature/categories
                            ),
                            validator: (value) {
                              final text = value?.trim() ?? '';
                              if (text.length < 6) {
<<<<<<< HEAD
                                return context.t('min_password_6');
=======
                                return 'Mật khẩu tối thiểu 6 ký tự';
>>>>>>> origin/feature/categories
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => _register(context),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
<<<<<<< HEAD
                                  : Text(context.t('create_account')),
=======
                                  : const Text('Tạo tài khoản'),
>>>>>>> origin/feature/categories
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
