import 'package:firebase_auth/firebase_auth.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:expense_tracker_app/core/localization/app_localization.dart';
=======
>>>>>>> origin/feature/categories
=======
import 'package:expense_tracker_app/core/localization/app_localization.dart';
>>>>>>> origin/feature/dashboard
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      if (!context.mounted) {
        return;
      }
<<<<<<< HEAD
<<<<<<< HEAD
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t('reset_sent'))));
=======
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã gửi email đặt lại mật khẩu')),
      );
>>>>>>> origin/feature/categories
=======
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t('reset_sent'))));
>>>>>>> origin/feature/dashboard
      Navigator.pop(context);
    } on FirebaseAuthException catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> origin/feature/dashboard
        SnackBar(
          content: Text(
            context.t('send_failed', {'error': error.message ?? 'unknown'}),
          ),
        ),
<<<<<<< HEAD
=======
        SnackBar(content: Text('Gửi email thất bại: ${error.message}')),
>>>>>>> origin/feature/categories
=======
>>>>>>> origin/feature/dashboard
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
<<<<<<< HEAD
      appBar: AppBar(title: Text(context.t('reset_password'))),
=======
      appBar: AppBar(title: const Text('Đặt lại mật khẩu')),
>>>>>>> origin/feature/categories
=======
      appBar: AppBar(title: Text(context.t('reset_password'))),
>>>>>>> origin/feature/dashboard
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
<<<<<<< HEAD
<<<<<<< HEAD
                  context.t('recover_account'),
=======
                  'Khôi phục tài khoản',
>>>>>>> origin/feature/categories
=======
                  context.t('recover_account'),
>>>>>>> origin/feature/dashboard
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
<<<<<<< HEAD
<<<<<<< HEAD
                  context.t('reset_desc'),
=======
                  'Nhập email đăng ký. Chúng tôi sẽ gửi liên kết đặt lại mật khẩu đến bạn.',
>>>>>>> origin/feature/categories
=======
                  context.t('reset_desc'),
>>>>>>> origin/feature/dashboard
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
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
<<<<<<< HEAD
<<<<<<< HEAD
                            decoration: InputDecoration(
                              labelText: context.t('enter_email'),
                              prefixIcon: const Icon(
=======
                            decoration: const InputDecoration(
                              labelText: 'Nhập email',
                              prefixIcon: Icon(
>>>>>>> origin/feature/categories
=======
                            decoration: InputDecoration(
                              labelText: context.t('enter_email'),
                              prefixIcon: const Icon(
>>>>>>> origin/feature/dashboard
                                Icons.mark_email_unread_outlined,
                              ),
                            ),
                            validator: (value) {
                              final text = value?.trim() ?? '';
                              if (text.isEmpty || !text.contains('@')) {
<<<<<<< HEAD
<<<<<<< HEAD
                                return context.t('enter_valid_email');
=======
                                return 'Vui lòng nhập email hợp lệ';
>>>>>>> origin/feature/categories
=======
                                return context.t('enter_valid_email');
>>>>>>> origin/feature/dashboard
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
                                  : () => _sendResetEmail(context),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
<<<<<<< HEAD
<<<<<<< HEAD
                                  : Text(context.t('send_request')),
=======
                                  : const Text('Gửi yêu cầu'),
>>>>>>> origin/feature/categories
=======
                                  : Text(context.t('send_request')),
>>>>>>> origin/feature/dashboard
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
