import 'package:firebase_auth/firebase_auth.dart';
<<<<<<< HEAD
import 'package:expense_tracker_app/core/localization/app_localization.dart';
=======
>>>>>>> origin/feature/categories
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t('reset_sent'))));
=======
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã gửi email đặt lại mật khẩu')),
      );
>>>>>>> origin/feature/categories
      Navigator.pop(context);
    } on FirebaseAuthException catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
        SnackBar(
          content: Text(
            context.t('send_failed', {'error': error.message ?? 'unknown'}),
          ),
        ),
=======
        SnackBar(content: Text('Gửi email thất bại: ${error.message}')),
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
      appBar: AppBar(title: Text(context.t('reset_password'))),
=======
      appBar: AppBar(title: const Text('Đặt lại mật khẩu')),
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
                  context.t('recover_account'),
=======
                  'Khôi phục tài khoản',
>>>>>>> origin/feature/categories
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
<<<<<<< HEAD
                  context.t('reset_desc'),
=======
                  'Nhập email đăng ký. Chúng tôi sẽ gửi liên kết đặt lại mật khẩu đến bạn.',
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
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
<<<<<<< HEAD
                            decoration: InputDecoration(
                              labelText: context.t('enter_email'),
                              prefixIcon: const Icon(
=======
                            decoration: const InputDecoration(
                              labelText: 'Nhập email',
                              prefixIcon: Icon(
>>>>>>> origin/feature/categories
                                Icons.mark_email_unread_outlined,
                              ),
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
                                  : Text(context.t('send_request')),
=======
                                  : const Text('Gửi yêu cầu'),
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
