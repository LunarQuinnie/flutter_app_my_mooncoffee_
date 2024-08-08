import 'package:final_app/widgets/cart.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:final_app/app/model/product.dart';
import 'package:final_app/helper/db_helper.dart';
import 'package:final_app/utils.dart';

import '../provider/product_provider.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key, required this.productModel});
  final ProductModel productModel;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool checkfavorite = false;
  List<ProductModel> _list = [];
  DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<ProductModel>> _getProduct() async {
    return await _databaseHelper.products();
  }

  Future<void> _initializeProducts() async {
    _list = await _getProduct();
    for (var element in _list) {
      if (element.id == widget.productModel.id) {
        setState(() {
          checkfavorite = element.id == widget.productModel.id;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getProduct();
    _initializeProducts();
  }

  Future<void> _onSaveFavorite() async {
    ProductModel productModel = widget.productModel;
    await _databaseHelper.insertProduct(productModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết sản phẩm',
          style: TextStyle(fontFamily: 'RobotoCondensed'),
        ),
        actions: [
         /* IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
            icon: Icon(Icons.shopping_cart),
          ),*/
          IconButton(
            onPressed: () {
              setState(() {
                checkfavorite = !checkfavorite;
              });
              _onSaveFavorite();
            },
            icon: checkfavorite
                ? const Icon(
              Icons.favorite,
              color: Colors.pinkAccent,
            )
                : const Icon(
              Icons.favorite_border_outlined,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: widget.productModel.id!,
                child: Image.network(widget.productModel.imageURL!),
              ),
              const SizedBox(height: 16),
              Text(
                widget.productModel.name!,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoCondensed'),
              ),
              const SizedBox(height: 8),
              Text(
                'Mô tả',
                style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'RobotoCondensed'),
              ),
              const SizedBox(height: 8),
              Text(
                widget.productModel.description ?? '',
                style: const TextStyle(
                    fontSize: 18, color: Colors.grey, fontFamily: 'RobotoCondensed'),
              ),
              const SizedBox(height: 16),
              Text(
                'Giá tiền',
                style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'RobotoCondensed'),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatMoney(widget.productModel.price!),
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoCondensed'),
                  ),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: Consumer<ProductProvider>(
                      builder: (context, value, child) {
                        return FilledButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            backgroundColor:
                            MaterialStateProperty.all<Color>(
                              Color(0xFF6667AB),
                            ),
                          ),
                          onPressed: () {
                            value.add(widget.productModel);
                            snackAlert("Thêm vào giỏ hàng thành công", context);
                          },
                          child: const Text("Thêm vào giỏ",style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: 18),),
                        );
                      },
                    ),
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
