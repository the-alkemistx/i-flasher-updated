import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the stored hashed credentials from local storage
    String? storedUsername = prefs.getString('username');
    String? storedPassword = prefs.getString('password');
    bool? isLoggedIn = null;
    if(storedUsername != null && storedPassword != null) {
       isLoggedIn = true;
    }
    else{
      isLoggedIn= false;
    }
    return isLoggedIn;
  }


  void _navigateToHome() async {
    // Simulate a delay for demonstration purposes
    await Future.delayed(const Duration(seconds: 3));
    if(await checkLoginStatus()){
      Navigator.pushReplacementNamed(context, '/device');
    }
    else {
      Navigator.pushReplacementNamed(context, '/login');
    }

    // Navigate to the home screen or any other screen

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset('assets/bluetooth.json'),
      ),
    );
  }
}
