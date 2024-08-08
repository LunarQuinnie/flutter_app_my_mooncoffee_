import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_app/app/data/api.dart';
import 'package:final_app/app/model/product.dart';
import 'package:final_app/app/page/add_product_page.dart';
import 'package:final_app/app/page/update_product_page.dart';
import 'package:final_app/utils.dart';

class ProductManagement extends StatefulWidget {
  const ProductManagement({super.key});

  @override
  State<ProductManagement> createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  List<ProductModel> _listAllProduct = [];

  Future<List<ProductModel>> getListProduct() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accountID = pref.getString("accountID")!;
    String token = pref.getString("token")!;
    return await APIRepository().getListProduct(accountID, token);
  }

  void getProductsAll() async {
    _listAllProduct = await getListProduct();

    for (var element in _listAllProduct) {
      print(element.name);
    }
  }

  @override
  void initState() {
    super.initState();
    getProductsAll();
    setState(() {});
  }

  showAlertDialog(BuildContext context, ProductModel product) async {
    Widget cancelButton = TextButton(
      child: Text("Hủy"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Đồng ý"),
      onPressed: () async {
        try {
          SharedPreferences pref = await SharedPreferences.getInstance();

          String? accountID = pref.getString("accountID");
          String? token = pref.getString("token");
          int? productId = product.id;

          if (accountID != null && token != null && productId != null) {
            await APIRepository().deleteProduct(token, accountID, productId);
            snackAlert("Xóa thành công", context);
            setState(() {});
          } else {
            snackAlert("Lỗi: Thiếu thông tin tài khoản hoặc sản phẩm", context);
          }
        } catch (error) {
          print("Bắt lỗi: ${error}");
        }

        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Bạn có chắc?"),
      content:
      Text("Nếu xóa sản phẩm bạn sẽ mất nó vĩnh viễn bạn chắc chứ??"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý sản phẩm"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<ProductModel>>(
                future: getListProduct(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Không có sản phẩm nào'));
                  }

                  List<ProductModel> result = snapshot.data!;

                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      ProductModel product = result[index];
                      return Card(
                        elevation: 4, // Độ nổi cho card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Bo góc card
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    width: 50,
                                    height: 50,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        product.imageURL!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 200,
                                        child: Text(
                                          product.name!,
                                          style: const TextStyle(
                                            fontFamily: 'RobotoCondensed',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(formatMoney(product.price!),style: const TextStyle(fontFamily: 'RobotoCondensed',)),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateProductPage(
                                                    productModel: product),
                                          ));
                                      setState(() {
                                        getProductsAll();
                                      });
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: () {
                                      showAlertDialog(context, product);
                                    },
                                    icon: const Icon(
                                      Icons.delete_forever_outlined,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FilledButton(
        style: const ButtonStyle(),
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddProductPage(),
              ));

          getProductsAll();
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
