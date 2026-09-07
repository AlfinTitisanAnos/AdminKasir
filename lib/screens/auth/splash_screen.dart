import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
    _navigate();
  }

  _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.isLoggedIn) {
      Navigator.pushReplacementNamed(context, auth.user!.role == 'admin' ? AppRoutes.adminHome : AppRoutes.cashierHome);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/logo.png', width: 120, height: 120, fit: BoxFit.cover,
                    errorBuilder: (context, error, widget) => Container(
                      width: 120, height: 120, color: Colors.white,
                      child: const Icon(Icons.school, size: 80, color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('TEFA TOKO', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2)),
                const SizedBox(height: 8),
                Text('SMKN 20 Jakarta', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16, letterSpacing: 1)),
                const SizedBox(height: 32),
                const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}