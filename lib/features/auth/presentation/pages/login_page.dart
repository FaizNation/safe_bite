import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_bite/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:safe_bite/features/auth/presentation/cubit/auth_state.dart';
import 'package:safe_bite/features/main/presentation/pages/main_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/auth_bottom.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainPage(),
                          ),
                          (route) => false,
                        );
                      } else if (state is AuthFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Masuk',
                                style: GoogleFonts.poppins(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2D5016),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Masuk ke akun Anda',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0xFF8D8D8D),
                                ),
                              ),
                              const SizedBox(height: 32),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: GoogleFonts.poppins(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email tidak boleh kosong';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Email tidak valid';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Kata sandi',
                                  labelStyle: GoogleFonts.poppins(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                obscureText: !_isPasswordVisible,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Kata sandi tidak boleh kosong';
                                  }
                                  if (value.length < 6) {
                                    return 'Kata sandi minimal 6 karakter';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Lupa kata sandi?',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF6B9F5E),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6B9F5E),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Masuk',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // const SizedBox(height: 24),
                              // Row(
                              //   children: [
                              //     const Expanded(child: Divider()),
                              //     Padding(
                              //       padding: const EdgeInsets.symmetric(
                              //         horizontal: 16,
                              //       ),
                              //       child: Text(
                              //         'Atau masuk dengan',
                              //         style: GoogleFonts.poppins(
                              //           color: const Color(0xFF8D8D8D),
                              //         ),
                              //       ),
                              //     ),
                              //     const Expanded(child: Divider()),
                              //   ],
                              // ),
                              // const SizedBox(height: 24),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     SocialButton(
                              //       icon: Icons.g_mobiledata,
                              //       size: 32,
                              //       onPressed: () {},
                              //     ),
                              //     const SizedBox(width: 16),
                              //     SocialButton(
                              //       icon: Icons.facebook,
                              //       size: 32,
                              //       iconColor: Colors.blue,
                              //       onPressed: () {},
                              //     ),
                              //     const SizedBox(width: 16),
                              //     SocialButton(
                              //       icon: Icons.apple,
                              //       size: 32,
                              //       onPressed: () {},
                              //     ),
                              //   ],
                              // ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Tidak punya akun? ',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF8D8D8D),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Daftar',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF6B9F5E),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20), 
                            ],
                          ),
                        ),
                      );
                    },
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
