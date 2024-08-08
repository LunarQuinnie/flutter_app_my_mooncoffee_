import 'package:flutter/material.dart';
import 'package:final_app/app/model/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<ProductModel> _cartItems = [];

  List<ProductModel> get lst => _cartItems;

  double get price => _cartItems.fold(0, (total, item) => total + (item.price! * (item.quantity ?? 1)));

  void add(ProductModel product) {
    final index = _cartItems.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _cartItems[index].quantity = (_cartItems[index].quantity ?? 1) + 1;
    } else {
      product.quantity = 1;
      _cartItems.add(product);
    }
    notifyListeners();
  }

  void del(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void delAll() {
    _cartItems.clear();
    notifyListeners();
  }
}
