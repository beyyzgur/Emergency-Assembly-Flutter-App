import 'package:flutter/material.dart';

class SplashOverlay extends StatelessWidget {
  const SplashOverlay({super.key, required this.showIndicator});

  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF243553),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/branding/splash.png', fit: BoxFit.cover),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 36),
              child: AnimatedOpacity(
                opacity: showIndicator ? 1 : 0,
                duration: const Duration(milliseconds: 400),
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
