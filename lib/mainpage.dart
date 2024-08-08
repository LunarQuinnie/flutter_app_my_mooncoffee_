import 'dart:convert';
import 'package:final_app/provider/product_provider.dart';
import 'package:final_app/widgets/cart.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:final_app/colors.dart';
import 'package:final_app/lintinh/message_page.dart';
import 'package:provider/provider.dart';
import 'package:final_app/app/model/user.dart';
import 'package:final_app/app/page/detail.dart';
import 'package:final_app/app/route/page1.dart';
import 'package:final_app/app/route/page2.dart';
import 'package:final_app/app/route/page3.dart';
import 'package:final_app/widgets/cart.dart';
import 'package:final_app/widgets/favorite.dart';
import 'package:final_app/widgets/history.dart';
import 'package:final_app/widgets/home.dart';
import 'package:final_app/widgets/management.dart';
import 'package:final_app/widgets/searchpage.dart';
import 'package:final_app/provider/product_provider.dart';
import 'app/data/sharepre.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/model/user.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  User user = User.userEmpty();
  int _selectedIndex = 0;

  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  bool isSearch = true;
  @override
  void initState() {
    super.initState();
    getDataUser();
    print(user.imageURL);

    isSearch = true;
  }

  List<Widget> _pages = [HomePage(), HistoryPage(),FavoritePage(), CartPage(), Detail()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController search = TextEditingController();

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Color.fromARGB(102, 125, 98, 201)),
          backgroundColor: Colors.white10,
          title:const Column(
            children: [
                          Text(
                            "TP Hồ Chí Minh",
                            style: TextStyle(
                                color: Color(0xFF9294cc), // Mã màu thực tế
                                fontSize: 18.0,
                                fontFamily: 'RobotoCondensed'// Kích thước thực tế
                            ),
                          ),
                          Text(
                            "Quận 10",
                            style: TextStyle(
                              fontFamily: 'RobotoCondensed',
                              color: Colors.black54,
                              fontSize: 14.0, // Kích thước thực tế
                            ),
                          ),
                        ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Searchpage()));
                  });
                },
                icon: const Icon(Icons.search)),
            Consumer<ProductProvider>(
              builder: (context, value, child) {
                return Badge(
                  label: Text(value.lst.length.toString()),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartPage(),
                          ));
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                  ),
                );
              },
            ),
            SizedBox(width: 20,)
          ]),
      drawer: Drawer(
        child: IconTheme(
          data: const IconThemeData(color: Color(0xFF9294cc)),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                curve: Curves.bounceInOut,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 176, 179, 232),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    user.imageURL!.length < 5
                        ? const SizedBox()
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 175, 175, 175)
                                      .withOpacity(0.4),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  user.imageURL!,
                                )),
                          ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(user.fullName!,style: TextStyle(fontFamily: 'RobotoCondensed')),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home',style: TextStyle(fontFamily: 'RobotoCondensed')),
                onTap: () {
                  Navigator.pop(context);
                  _selectedIndex = 0;
                  setState(() {});
                },
              ),
              ListTile(
                leading: const Icon(Icons.contact_mail),
                title: const Text('Lịch sử mua hàng',style: TextStyle(fontFamily: 'RobotoCondensed')),
                onTap: () {
                  Navigator.pop(context);
                  _selectedIndex = 1;
                  setState(() {});
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Giỏ hàng',style: TextStyle(fontFamily: 'RobotoCondensed')),
                onTap: () {
                  Navigator.pop(context);
                  _selectedIndex = 3;
                  setState(() {});
                },
              ),
              ListTile(
                leading: const Icon(Icons.message_outlined),
                title: const Text('Message',style: TextStyle(fontFamily: 'RobotoCondensed'),),
                onTap: () {
                  Navigator.pop(context);
                  _selectedIndex = 0;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MessageScreen()));
                },
              ),
              const Divider(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              user.accountId == ''
                  ? const SizedBox()
                  : ListTile(
                      leading: const Icon(Icons.logout_rounded),
                      title: const Text('Đăng xuất',style: TextStyle(fontFamily: 'RobotoCondensed')),
                      onTap: () {
                        logOut(context);
                      },
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.time_to_leave),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pedal_bike),
            label: 'User',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(102, 125, 98, 201),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      body: _pages[_selectedIndex],
    );
  }
}
