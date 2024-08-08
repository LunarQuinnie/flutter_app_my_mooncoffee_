import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:final_app/colors.dart';
import 'package:final_app/widgets/big_text.dart';
import 'package:final_app/widgets/icon_and_text_widget.dart';
import 'package:final_app/widgets/small_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_app/app/data/api.dart';
import 'package:final_app/app/model/category.dart';
import 'package:final_app/app/model/product.dart';
import 'package:final_app/widgets/product_detail.dart';
import 'package:final_app/widgets/show_product.dart';
import 'package:final_app/lintinh/footer.dart';
import 'package:final_app/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _imagesSlider = [
   'assets/images/banner/1.jpg',
    'assets/images/banner/2.jpg',
    'assets/images/banner/3.jpg',
    'assets/images/banner/4.jpg',
    'assets/images/banner/5.jpg'
  ];

  List<CategoryModel> _listCateModel = [];
  List<ProductModel> _listProductModel = [];

  Future<List<CategoryModel>> getListCategory() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accountID = pref.getString("accountID")!;
    String token = pref.getString("token")!;
    return await APIRepository().getListCategory(accountID, token);
  }

  Future<List<ProductModel>> getMyListProduct() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accountID = pref.getString("accountID")!;
    String token = pref.getString("token")!;
    return await APIRepository().getListProduct(accountID, token);
  }

  void getAllListProduct() async {
    _listProductModel = await getMyListProduct();
    for (var element in _listProductModel) {
      print(element.name);
    }
  }

  void getAllListCate() async {
    _listCateModel = await getListCategory();
  }

  bool checkfavorite = false;

  @override
  void initState() {
    super.initState();
    getAllListCate();
    getAllListProduct();
    checkfavorite = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: CarouselSlider(
                items: _imagesSlider.map((item) => Container(
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0), // Set your desired border radius here
                      child: Image.asset(item,
                        fit: BoxFit.cover, // Adjust the image fit property as needed
                        width: 1000.0,
                      ),
                    ),
                  ),
                ))
                    .toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2,
                  onPageChanged: (index, reason) {
                    // Handle page change if needed
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 16,
              ),
            ),
            const SliverToBoxAdapter(
              child: Text(
                'Danh mục các sản phẩm',
                style: TextStyle(fontSize: 23,
                    fontFamily: 'RobotoCondensed',
                    color: Color(0xFF6667AB),
                    fontWeight: FontWeight.bold),
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder<List<CategoryModel>>(
                future: getListCategory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}',style: TextStyle(fontFamily: 'RobotoCondensed'),),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('không có loại sản phẩn nào',style: TextStyle(fontFamily: 'RobotoCondensed'),),
                    );
                  }

                  List<CategoryModel> _listCateModel = snapshot.data!;
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                        itemCount: _listCateModel.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShowProductPage(
                                        cate: _listCateModel[index]),
                                  ))
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 24),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                            width: 2,
                                            color: const Color.fromARGB(
                                                255, 214, 214, 214))),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          _listCateModel[index].imageURL!),
                                      radius: 35, // Set a fixed radius for the avatar
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    _listCateModel[index].name,
                                    style: TextStyle(fontSize: 12,fontFamily: 'RobotoCondensed'),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
/*            const SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),*/
            const SliverToBoxAdapter(
              child: Text(
                'Danh sách các sản phẩm',
                style: TextStyle(fontSize: 23,
                fontFamily: 'RobotoCondensed',
                color: Color(0xFF6667AB),
                fontWeight: FontWeight.bold),
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder<List<ProductModel>>(
                future: getMyListProduct(),
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
                    return Center(
                      child: Text('Không có sản phẩm nào',style: TextStyle(fontFamily: 'RobotoCondensed'),),
                    );
                  }
                  List<ProductModel> _listProduct = snapshot.data!;
                  return Padding(
                    padding: EdgeInsets.only( top: 8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height, // Điều chỉnh chiều cao nếu cần
                            child: MasonryGridView.builder(
                              physics: NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn của MasonryGridView
                              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: _listProduct.length,
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
                                    margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                    height: 265,
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(_listProduct[index].imageURL!),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              BigText(text: _listProduct[index].name!),
                                              Text(_listProduct[index].description!,overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: 12,color: AppColors.paraColor),),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  IconAndTextWidget(
                                                    text: 'Gần đây',
                                                    icon: Icons.circle_sharp,
                                                    iconColor: AppColors.iconColor1,
                                                  ),
                                                  IconAndTextWidget(
                                                    text: '2km',
                                                    icon: Icons.location_on,
                                                    iconColor: AppColors.mainColor,
                                                  ),
                                                  IconAndTextWidget(
                                                    text: '10phút',
                                                    icon: Icons.access_time_rounded,
                                                    iconColor: AppColors.iconColor2,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                formatMoney(_listProduct[index].price!),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.veriPeri,
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
