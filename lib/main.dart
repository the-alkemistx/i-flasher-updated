
import 'package:consumer/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:consumer/pages/login.dart';
import 'package:consumer/pages/register.dart';
import 'package:consumer/pages/device.dart';
import 'package:consumer/pages/forgot_pass.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: true,
    home: const MyLogin(),
    initialRoute: '/splash',
    routes: {
      '/splash': (context) => const SplashScreen(),
      '/register': (context) => const MyRegister(),
      '/login': (context) => const MyLogin(),
      '/device':(context) => const BluetoothScanner(),
      '/forgot':(context) => const ForgotPasswordPage(),
    },
  ));
}