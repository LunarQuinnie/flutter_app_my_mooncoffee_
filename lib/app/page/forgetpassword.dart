import 'package:flutter/material.dart';
import 'package:final_app/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_app/app/data/api.dart';
import 'package:final_app/utils.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  TextEditingController accountID = TextEditingController();
  TextEditingController numberID = TextEditingController();
  TextEditingController newPass = TextEditingController();

  Future<String> changePassword() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token")!;
    print("token: ${token}");

    return await APIRepository()
        .forgetPassword(accountID.text, numberID.text, newPass.text, token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("AccountID",style: TextStyle(fontFamily: 'RobotoCondensed'),),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: accountID,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "AccountID",
                icon: Icon(Icons.account_balance),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text("Number ID",style: TextStyle(fontFamily: 'RobotoCondensed')),
             const SizedBox(
              height: 8,
            ),
            TextField(
              controller: numberID,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Number ID",
                icon: Icon(Icons.numbers_outlined),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text("Mật khẩu mới",style: TextStyle(fontFamily: 'RobotoCondensed')),
              const SizedBox(
              height: 8,
            ),
            TextField(
              controller: newPass,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mật khẩu mới",
                icon: Icon(Icons.abc),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: removeDefaulBorderRadius(),
                  onPressed: () async {
                    String respone = await changePassword();
                    if (respone == "ok") {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Đổi mật khẩu thành công!")));

                      print("change Success");
                    } else {
                      print(respone);
                    }
                  },
                  child: Text("Lấy lại mật khẩu",style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: 18,color: AppColors.veriPeri),)),
            )
          ],
        ),
      ),
    );
  }
}
