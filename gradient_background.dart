import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  const GradientBackground({
    super.key,
    required this.child,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}
