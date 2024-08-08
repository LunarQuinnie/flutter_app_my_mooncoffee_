
import 'package:final_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Chuyển đến trang chính sau 2 giây
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed('/home');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Màu nền cho splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/logo.png'),
            //Icon(Icons.coffee, size: 100, color: AppColors.mainColor),
SizedBox(height: 20),
            Text(
              'Welcome to MoonCoffee',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.mainColor),
            ),

          ],
        ),
      ),
    );
  }
}

