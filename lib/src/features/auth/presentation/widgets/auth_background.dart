import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  final String backgroundImage;

  const AuthBackground({
    super.key,
    required this.child,
    required this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Запрещаем изменение размера при открытии клавиатуры, 
      // чтобы фоновое изображение не "прыгало" и не сжималось.
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            backgroundImage,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          // Content
          SafeArea(
            child: child,
          ),
        ],
      ),
    );
  }
}
