import 'package:final_app/provider/product_provider.dart';
import 'package:final_app/widgets/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'app/page/auth/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return ProductProvider();
        })
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
      useMaterial3: true,
    ),
        initialRoute: '/', // Đặt route khởi đầu là '/'
        routes: {
          '/': (context) => SplashScreen(), // Định nghĩa route cho SplashScreen
          '/home': (context) => LoginScreen(), // Định nghĩa route cho HomeScreen
        },
      ),
    );
  }
}
