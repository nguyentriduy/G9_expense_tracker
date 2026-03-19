import 'package:expense_tracker_app/app/app_router.dart';
import 'package:expense_tracker_app/core/firebase/firestore_bootstrap_service.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:expense_tracker_app/core/localization/app_localization.dart';
=======
>>>>>>> origin/feature/categories
=======
import 'package:expense_tracker_app/core/localization/app_localization.dart';
>>>>>>> origin/feature/dashboard
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final user = credential.user;
      if (user != null) {
        await FirestoreBootstrapService().ensureUserStructure(user);
      }

      if (!context.mounted) {
        return;
      }

      Navigator.pushReplacementNamed(context, AppRoutes.home);
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
            context.t('login_failed', {'error': error.message ?? 'unknown'}),
          ),
        ),
<<<<<<< HEAD
=======
        SnackBar(content: Text('Đăng nhập thất bại: ${error.message}')),
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

  Future<void> _loginWithGoogle(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential credential;

      if (kIsWeb) {
        credential = await FirebaseAuth.instance.signInWithPopup(
          GoogleAuthProvider(),
        );
      } else {
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
          return;
        }

        final googleAuth = await googleUser.authentication;
        final googleCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        credential = await FirebaseAuth.instance.signInWithCredential(
          googleCredential,
        );
      }

      final user = credential.user;
      if (user != null) {
        await FirestoreBootstrapService().ensureUserStructure(user);
      }

      if (!context.mounted) {
        return;
      }
      Navigator.pushReplacementNamed(context, AppRoutes.home);
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
            context.t('google_login_failed', {
              'error': error.message ?? 'unknown',
            }),
          ),
        ),
<<<<<<< HEAD
=======
        SnackBar(content: Text('Đăng nhập Google thất bại: ${error.message}')),
>>>>>>> origin/feature/categories
=======
>>>>>>> origin/feature/dashboard
      );
    } catch (error) {
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
            context.t('google_login_failed', {'error': error.toString()}),
          ),
        ),
<<<<<<< HEAD
=======
        SnackBar(content: Text('Đăng nhập Google thất bại: $error')),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF005F6B), Color(0xFF168AAD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.wallet_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
<<<<<<< HEAD
<<<<<<< HEAD
                              context.t('welcome_back'),
=======
                              'Chào mừng trở lại',
>>>>>>> origin/feature/categories
=======
                              context.t('welcome_back'),
>>>>>>> origin/feature/dashboard
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 4),
<<<<<<< HEAD
<<<<<<< HEAD
                            Text(
                              context.t('login_to_continue'),
=======
                            const Text(
                              'Đăng nhập để tiếp tục quản lý chi tiêu.',
>>>>>>> origin/feature/categories
=======
                            Text(
                              context.t('login_to_continue'),
>>>>>>> origin/feature/dashboard
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
<<<<<<< HEAD
<<<<<<< HEAD
                            context.t('login'),
=======
                            'Đăng nhập',
>>>>>>> origin/feature/categories
=======
                            context.t('login'),
>>>>>>> origin/feature/dashboard
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
<<<<<<< HEAD
<<<<<<< HEAD
                            decoration: InputDecoration(
                              labelText: context.t('email'),
                              prefixIcon: const Icon(Icons.alternate_email),
=======
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.alternate_email),
>>>>>>> origin/feature/categories
=======
                            decoration: InputDecoration(
                              labelText: context.t('email'),
                              prefixIcon: const Icon(Icons.alternate_email),
>>>>>>> origin/feature/dashboard
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
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
<<<<<<< HEAD
<<<<<<< HEAD
                            decoration: InputDecoration(
                              labelText: context.t('password'),
                              prefixIcon: const Icon(Icons.lock_outline),
=======
                            decoration: const InputDecoration(
                              labelText: 'Mật khẩu',
                              prefixIcon: Icon(Icons.lock_outline),
>>>>>>> origin/feature/categories
=======
                            decoration: InputDecoration(
                              labelText: context.t('password'),
                              prefixIcon: const Icon(Icons.lock_outline),
>>>>>>> origin/feature/dashboard
                            ),
                            validator: (value) {
                              final text = value?.trim() ?? '';
                              if (text.length < 6) {
<<<<<<< HEAD
<<<<<<< HEAD
                                return context.t('min_password_6');
=======
                                return 'Mật khẩu tối thiểu 6 ký tự';
>>>>>>> origin/feature/categories
=======
                                return context.t('min_password_6');
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
                                  : () => _login(context),
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
                                  : Text(context.t('login')),
=======
                                  : const Text('Đăng nhập'),
>>>>>>> origin/feature/categories
=======
                                  : Text(context.t('login')),
>>>>>>> origin/feature/dashboard
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _isLoading
                                  ? null
                                  : () => _loginWithGoogle(context),
                              icon: Icon(
                                Icons.g_mobiledata_rounded,
                                color: colorScheme.primary,
                              ),
<<<<<<< HEAD
<<<<<<< HEAD
                              label: Text(context.t('login_with_google')),
=======
                              label: const Text('Đăng nhập với Google'),
>>>>>>> origin/feature/categories
=======
                              label: Text(context.t('login_with_google')),
>>>>>>> origin/feature/dashboard
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.forgotPassword,
                                );
                              },
<<<<<<< HEAD
<<<<<<< HEAD
                              child: Text(context.t('forgot_password')),
=======
                              child: const Text('Quên mật khẩu?'),
>>>>>>> origin/feature/categories
=======
                              child: Text(context.t('forgot_password')),
>>>>>>> origin/feature/dashboard
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
<<<<<<< HEAD
<<<<<<< HEAD
                    Text(context.t('no_account')),
=======
                    const Text('Chưa có tài khoản? '),
>>>>>>> origin/feature/categories
=======
                    Text(context.t('no_account')),
>>>>>>> origin/feature/dashboard
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.register);
                      },
<<<<<<< HEAD
<<<<<<< HEAD
                      child: Text(context.t('register_now')),
=======
                      child: const Text('Đăng ký ngay'),
>>>>>>> origin/feature/categories
=======
                      child: Text(context.t('register_now')),
>>>>>>> origin/feature/dashboard
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
