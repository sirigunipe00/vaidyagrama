import 'package:flutter/material.dart';
import 'package:app/core/core.dart';

class AppSplashScreen extends StatelessWidget {
  const AppSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(child: Image.asset(context.appFlavor.logo)),
    );
  }
}