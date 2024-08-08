import 'package:lottie/lottie.dart';
import 'package:final_app/app/page/forgetpassword.dart';
import 'package:final_app/colors.dart';
import 'package:final_app/widgets/custom_text_field.dart';
import 'package:final_app/widgets/social_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_app/app/data/api.dart';
import 'package:final_app/mainpage.dart';
import '../../../widgets/management.dart';
import '../product/detail_admin.dart';
import '../register.dart';
import 'package:flutter/material.dart';
import '../../data/sharepre.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  login() async {
    try {
      // Lấy token (lưu vào SharedPreferences)
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("accountID", accountController.text);
      String token = await APIRepository().login(accountController.text, passwordController.text);

      if (token == "login fail") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập không thành công')),
        );
        return;
      }

      var user = await APIRepository().current(token);
      bool saved = await saveUser(user, token);
      if (!saved) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lưu thông tin người dùng thất bại')),
        );
        return;
      }

      // Điều hướng dựa trên tên người dùng
      if (user.idNumber == "21DH111569") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DetailAdmin()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Mainpage()),
        );
      }
    } catch (e) {
      print('Lỗi: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi. Vui lòng thử lại sau.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Container(
                width: double.maxFinite,
                height: 80, // Adjust height as needed
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    image: AssetImage("assets/images/logo.png"),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Đăng nhập để nhận được những khuyến mãi và ưu đãi hấp dẫn từ chúng tôi',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey[700],fontFamily: 'RobotoCondensed'),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: 300,
                child: SocialButton(
                  icon: Icons.facebook,
                  text: 'Đăng nhập bằng Facebook',
                  color: Color.fromRGBO(60, 90, 153, 1),
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: 300,
                child: SocialButton(
                  icon: Icons.email,
                  text: 'Đăng nhập bằng Google',
                  color: Colors.red,
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ), // Button background color
                  ),
                  onPressed: () {
                    // Handle Microsoft login logic here
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/microsoft_logo.png', // Path to custom Microsoft icon
                        height: 24, // Icon height
                        width: 24, // Icon width
                      ),
                      SizedBox(width: 8), // Space between icon and text
                      Flexible(
                        child: Text(
                          'Đăng nhập bằng Microsoft',
                          style: TextStyle(fontSize: 18,fontFamily: 'RobotoCondensed'), // Adjust font size if needed
                          overflow: TextOverflow.ellipsis, // Ellipsis for long text
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 5),
              Container( width: 300
                ,child:const Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Divider(thickness: 1.0, color: Colors.grey,),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'hoặc',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Divider(thickness: 1.0, color: Colors.grey),
                    ),
                  ],
                ),),

              Container(
                width: 300,
                child: Column(

                  children: [
                    CustomTextField(
                      controller: accountController,
                      hintText: 'Tên đăng nhập',
                      obscureText: false,
                    ),
                    Divider(thickness: 1.0, color: Colors.grey),
                    CustomTextField(
                      controller: passwordController,
                      hintText: 'Mật khẩu',
                      obscureText: true,
                    ),
                    Divider(thickness: 1.0, color: Colors.grey),
                  ],
                ),
              ),
              //Divider(thickness: 1.0, color: Colors.grey),
              //SizedBox(height: Dimensions.height10),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Forgetpassword()),
                  );
                },
                child: Text('Quên mật khẩu?',
                  style: TextStyle(fontFamily: 'RobotoCondensed',
                    color: AppColors.veriPeri,
                    fontWeight: FontWeight.bold,fontSize: 15,decoration: TextDecoration.underline,),),
              ),
              SizedBox(
                width:  300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.veriPeri,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: Size(double.infinity, 26),
                    ),
                    onPressed: login,
                    child: Text(
                      'Đăng Nhập',
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.white,fontFamily: 'RobotoCondensed'),
                    ),
                ),
              ),
              //SizedBox(height: Dimensions.height5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Chưa có tài khoản?',style: TextStyle(fontFamily:'RobotoCondensed',fontSize: 15 ),),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    child: Text('Đăng Ký',
                      style: TextStyle(fontFamily: 'RobotoCondensed',
                        color: AppColors.veriPeri,
                        fontWeight: FontWeight.bold,fontSize: 15,decoration: TextDecoration.underline,),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
