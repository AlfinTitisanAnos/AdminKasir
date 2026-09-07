import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  const AppButton({super.key, required this.text, required this.onPressed, this.isLoading = false});
  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
          onPressed: widget.isLoading ? null : widget.onPressed,
          child: widget.isLoading 
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text(widget.text),
        ),
      ),
    );
  }
}