import 'package:flutter/material.dart';
import 'lab_guard_home.dart';

void main() {
  runApp(const LabGuardApp());
}

class LabGuardApp extends StatelessWidget {
  const LabGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LabGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF176B87),
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F6FA),
      ),
      home: const LabGuardHome(),
    );
  }
}