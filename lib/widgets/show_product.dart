import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_app/app/data/api.dart';
import 'package:final_app/app/model/category.dart';
import 'package:final_app/app/model/product.dart';
import 'package:final_app/widgets/product_detail.dart';
import 'package:final_app/utils.dart';

class ShowProductPage extends StatefulWidget {
  const ShowProductPage({super.key, required this.cate});
  final CategoryModel cate;

  @override
  State<ShowProductPage> createState() => _ShowProductPageState();
}

class _ShowProductPageState extends State<ShowProductPage> {
  List<ProductModel> _listProductModel = [];
  List<ProductModel> _listShow = [];

  Future<List<ProductModel>> getMyListProduct() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accountID = pref.getString("accountID")!;
    String token = pref.getString("token")!;
    return await APIRepository().getListProduct(accountID, token);
  }

  void getAllListProduct() async {
    _listProductModel = await getMyListProduct();
    _listShow = _listProductModel.where((e) => e.categoryID == widget.cate.id).toList();

    for (var element in _listShow) {
      print(element.name);
    }
  }

  Future<List<ProductModel>> getListShow() async {
    _listProductModel = await getMyListProduct();
    _listShow = _listProductModel.where((e) => e.categoryID == widget.cate.id).toList();
    return _listShow;
  }

  @override
  void initState() {
    super.initState();
    getAllListProduct();
  }

  @override
  Widget build(BuildContext context) {
    CategoryModel category = widget.cate;
    return Scaffold(
      appBar: AppBar(
        title: Text("Loại: ${category.name}", style: TextStyle(fontFamily: 'RobotoCondensed')),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: getListShow(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Không có sản phẩm nào', style: TextStyle(fontFamily: 'RobotoCondensed')),
            );
          }

          List<ProductModel> _listProduct = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.only(bottom: 40, top: 8),
            child: MasonryGridView.builder(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetail(
                          productModel: _listProduct[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8.0), // Khoảng cách giữa các khung
                    padding: const EdgeInsets.all(8.0), // Padding bên trong khung
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16), // Bo góc
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 4), // Đổ bóng
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(_listProduct[index].imageURL!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _listProduct[index].name!,
                                style: TextStyle(fontFamily: 'RobotoCondensed'),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatMoney(_listProduct[index].price!),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'RobotoCondensed',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: _listProduct.length,
            ),
          );
        },
      ),
    );
  }
}
