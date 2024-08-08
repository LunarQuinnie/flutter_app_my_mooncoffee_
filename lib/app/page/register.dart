import 'package:flutter/material.dart';
import 'package:final_app/app/data/api.dart';
import 'package:final_app/app/model/register.dart';
import 'package:final_app/app/page/auth/login.dart';
import 'package:final_app/colors.dart';
import 'package:final_app/widgets/social_button.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int _gender = 0;
  bool _check = false;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _numberIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _schoolKeyController = TextEditingController();
  final TextEditingController _schoolYearController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _imageURL = TextEditingController();
  String gendername = 'None';
  String temp = '';

  Future<String> register() async {
    return await APIRepository().register(Signup(
        accountID: _accountController.text,
        birthDay: _birthDayController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        fullName: _fullNameController.text,
        phoneNumber: _phoneNumberController.text,
        schoolKey: _schoolKeyController.text,
        schoolYear: _schoolYearController.text,
        gender: getGender(),
        imageUrl: _imageURL.text,
        numberID: _numberIDController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                Container(
                  width: double.maxFinite,
                  height: 120, // Adjust height as needed
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
                  'Đăng ký để nhận được những khuyến mãi và ưu đãi hấp dẫn từ chúng tôi',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey[700],fontFamily: 'RobotoCondensed'),
                ),
                Container( width: 120,
                  child:Row(
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
                  ),
                ),
                signUpWidget(),
                SizedBox(height: 5),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          String respone = await register();
                          if (respone == "ok") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          } else {
                            print(respone);
                          }
                        },
                        child: const Text('Register',style: TextStyle(fontFamily:'RobotoCondensed',fontSize: 15 )),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _check,
                      onChanged: (value){
                        setState(() {
                          _check = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'Tôi đã đọc và đồng ý với ',
                          style:  TextStyle(color: Colors.black,fontFamily: 'RobotoCondensed'),
                          children: [
                            TextSpan(
                              text: 'Điều khoản Dịch vụ',
                              style:TextStyle(
                                fontFamily: 'RobotoCondensed',
                                decoration: TextDecoration.underline,
                                color: AppColors.veriPeri, // Thay AppColors.veriPeri thành màu sắc tương ứng
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' & '),
                            TextSpan(
                              text: 'Chính Sách Bảo Mật',
                              style:TextStyle(
                                fontFamily: 'RobotoCondensed',
                                decoration: TextDecoration.underline,
                                color: AppColors.veriPeri, // Thay AppColors.veriPeri thành màu sắc tương ứng
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ' của MoonCoffee',
                              style: TextStyle(color: Colors.black,fontFamily: 'RobotoCondensed',),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Đã có tài khoản?',style: TextStyle(fontFamily:'RobotoCondensed',fontSize: 20 ),),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text('Đăng nhập',
                        style: TextStyle(fontFamily: 'RobotoCondensed',
                          color: AppColors.veriPeri,
                          fontWeight: FontWeight.bold,fontSize: 20,decoration: TextDecoration.underline,),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getGender() {
    if (_gender == 1) {
      return "Male";
    } else if (_gender == 2) {
      return "Female";
    }
    return "Other";
  }

  //có thể thêm các biến cho phù hợp với từng field
  Widget textField(
      TextEditingController controller, String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: label.contains('word'),
        onChanged: (value) {
          setState(() {
            temp = value;
          });
        },
        decoration: InputDecoration(
            labelText: label,
            icon: Icon(icon),
            border: const OutlineInputBorder(),
            errorText: controller.text.trim().isEmpty ? 'Please enter' : null,
            focusedErrorBorder: controller.text.isEmpty
                ? const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black ))
                : null,
            errorBorder: controller.text.isEmpty
                ? const OutlineInputBorder(
                    borderSide: BorderSide(color:Color.fromARGB(102, 125, 98, 201)))
                : null),
      ),
    );
  }

  Widget signUpWidget() {
    return Column(
      children: [
        textField(_accountController, "Account", Icons.person),
        textField(_passwordController, "Password", Icons.password),
        textField(
          _confirmPasswordController,
          "Confirm password",
          Icons.password,
        ),
        textField(_fullNameController, "Full Name", Icons.text_fields_outlined),
        textField(_numberIDController, "NumberID", Icons.key),
        textField(_phoneNumberController, "PhoneNumber", Icons.phone),
        textField(_birthDayController, "BirthDay", Icons.date_range),
        textField(_schoolYearController, "SchoolYear", Icons.school),
        textField(_schoolKeyController, "SchoolKey", Icons.school),
        const Text("What is your Gender?"),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text("Male"),
                leading: Transform.translate(
                    offset: const Offset(16, 0),
                    child: Radio(
                      value: 1,
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    )),
              ),
            ),
            Expanded(
              child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text("Female"),
                  leading: Transform.translate(
                    offset: const Offset(16, 0),
                    child: Radio(
                      value: 2,
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  )),
            ),
            Expanded(
                child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: const Text("Other"),
              leading: Transform.translate(
                  offset: const Offset(16, 0),
                  child: Radio(
                    value: 3,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  )),
            )),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _imageURL,
          decoration: const InputDecoration(
            labelText: "Image URL",
            icon: Icon(Icons.image),
          ),
        ),
      ],
    );
  }
}
