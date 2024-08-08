import 'dart:convert';

import 'package:final_app/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:final_app/app/model/order.dart';
import 'package:final_app/app/model/product.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/model/user.dart'; // Đảm bảo import User model
import '../utils.dart';
import 'order_detail.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<Order>> prepareOrders(ProductProvider value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token")!;

    List<ProductModel> productModel = value.lst;
    List<Order> orders = [];

    for (var product in productModel) {
      orders.add(Order(id: product.id!, count: product.quantity!));
    }

    return orders;
  }

  Future<User> getUserInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userJson = pref.getString('user');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    } else {
      return User.userEmpty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giỏ hàng", style: TextStyle(fontFamily: 'RobotoCondensed')),
        actions: [
          Consumer<ProductProvider>(
            builder: (context, value, child) {
              return IconButton(
                onPressed: () {
                  value.delAll();
                  setState(() {});
                },
                icon: const Icon(Icons.delete),
              );
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, value, child) {
          return ListView.separated(
            itemBuilder: (context, index) {
              ProductModel product = value.lst[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 100,
                                height: 100,
                                child: Image.network(product.imageURL!, fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name!,
                                  style: const TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  formatMoney(product.price!.toInt()),
                                  style: const TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        if (product.quantity! > 1) {
                                          setState(() {
                                            product.quantity = product.quantity! - 1;
                                          });
                                        }
                                      },
                                    ),
                                    Text(
                                      '${product.quantity}',
                                      style: const TextStyle(
                                        fontFamily: 'RobotoCondensed',
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          product.quantity = product.quantity! + 1;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            value.del(index);
                            setState(() {});
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: value.lst.length,
          );
        },
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.black12),
        height: 110,
        width: double.infinity,
        child: Consumer<ProductProvider>(
          builder: (context, value, child) {
            final totalPrice = value.price.toDouble();
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tổng tiền",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'RobotoCondensed'),
                    ),
                    Text(
                      formatMoney(totalPrice.toInt()),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'RobotoCondensed'),
                    ),
                  ],
                ),
                Container(
                  width: 130,
                  child: ElevatedButton(
                    onPressed: () async {
                      List<Order> orders = await prepareOrders(value);
                      User user = await getUserInfo();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailPage(
                            orders: orders,
                            products: value.lst,
                            user: user,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Đặt hàng",
                      style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
