import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController(text: 'admin@gmail.com');
  final _passController = TextEditingController(text: 'admin123');
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  late AnimationController _animController;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height * 0.35,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset('assets/logo.png', width: 80, height: 80, fit: BoxFit.cover,
                      errorBuilder: (context, error, widget) => Container(
                        width: 80, height: 80, color: Colors.white,
                        child: const Icon(Icons.school, size: 50, color: Colors.green),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('TEFA TOKO', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  const SizedBox(height: 4),
                  Text('SMKN 20 Jakarta', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                ],
              ),
            ),
            SlideTransition(
              position: _slideAnim,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Masuk Akun', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800]), textAlign: TextAlign.center),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                        validator: (val) => val!.isEmpty ? 'Email wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passController,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey),
                            onPressed: () => setState(() => _isObscure = !_isObscure),
                          ),
                        ),
                        validator: (val) => val!.isEmpty ? 'Password wajib diisi' : null,
                      ),
                      Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text('Lupa Password?'))),
                      const SizedBox(height: 16),
                      AppButton(
                        text: 'Masuk', isLoading: auth.isLoading,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final success = await auth.login(_emailController.text, _passController.text);
                            if (success) {
                              Navigator.pushReplacementNamed(context, auth.user!.role == 'admin' ? AppRoutes.adminHome : AppRoutes.cashierHome);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email atau password salah'), backgroundColor: Colors.red));
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}