import 'package:flutter/material.dart';
import 'package:final_app/app/model/product.dart';
import 'package:final_app/helper/db_helper.dart';
import 'package:final_app/utils.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<ProductModel> _list = [];
  Future<List<ProductModel>> _getProduct() async {
    return await _databaseHelper.products();
  }

  Future<void> removeProductFavorite(int id) async {
    await _databaseHelper.deleteProductFavorite(id);
    setState(() {});
  }

  @override
  void initState() {
    _getProduct();
    // _list = _getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Favorite",style: TextStyle(fontFamily: 'RobotoCondensed',),),
        ),
        body: FutureBuilder<List<ProductModel>>(
          future: _getProduct(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return snapshot.hasData
                ? Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView.separated(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final product = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            margin: EdgeInsets.only(left:5,right:5),
                            //padding: EdgeInsets.all(20),
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 12,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0), // Thêm padding top và bottom
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10), // Bo góc cho hình ảnh
                                        child: Container(
                                          width: 120, // Tăng chiều rộng hình ảnh
                                          height: 140, // Tăng chiều cao hình ảnh
                                          child: Image.network(product.imageURL!, fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12), // Tăng khoảng cách giữa hình và văn bản
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name!,
                                          style: TextStyle(
                                            fontFamily: 'RobotoCondensed',
                                            fontSize: 18, // Tăng kích thước chữ cho tên sản phẩm
                                          ),
                                        ),
                                        const SizedBox(height: 8), // Tăng khoảng cách giữa tên sản phẩm và giá
                                        Text(
                                          formatMoney(product.price!),
                                          style: TextStyle(
                                            fontFamily: 'RobotoCondensed',
                                            fontSize: 16, // Tăng kích thước chữ cho giá sản phẩm
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {

                                      },
                                      icon: const Icon(Icons.add_shopping_cart_sharp),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        removeProductFavorite(product.id!);
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ],
                            ),

                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    ),
                  )
                : const Center(
                    child: Text("Không có sản phẩm được yêu thích nào",style: TextStyle(fontFamily: 'RobotoCondensed',),),
                  );
          },
        ));
  }
}
