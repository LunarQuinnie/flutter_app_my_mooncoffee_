import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_app/app/data/api.dart';
import 'package:final_app/app/model/category.dart';
import 'package:final_app/app/page/add_cate_page.dart';
import 'package:final_app/app/page/update_category_page.dart';
import 'package:final_app/utils.dart';

class CategoryManagement extends StatefulWidget {
  const CategoryManagement({super.key});

  @override
  State<CategoryManagement> createState() => _CategoryManagementState();
}

class _CategoryManagementState extends State<CategoryManagement> {
  List<CategoryModel> _listAllCategory = [];

  Future<List<CategoryModel>> getListCategory() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accountID = pref.getString("accountID")!;
    String token = pref.getString("token")!;
    return await APIRepository().getListCategory(accountID, token);
  }

  Future<void> getCategoriesAll() async {
    _listAllCategory = await getListCategory();

    for (var element in _listAllCategory) {
      print(element.name);
    }
  }

  @override
  void initState() {
    super.initState();
    getCategoriesAll();
  }

  Future<String> deleteCate(int categoryID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accountID = pref.getString("accountID")!;
    String token = pref.getString("token")!;
    return await APIRepository().removeCategory(categoryID, accountID, token);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCategoriesAll();
  }

  @override
  void dispose() {
    super.dispose();
    getCategoriesAll();
  }

  showAlertDialog(BuildContext context, CategoryModel cate) async {
    Widget cancelButton = TextButton(
      child: const Text("Hủy"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Đồng ý"),
      onPressed: () async {
        String result = await deleteCate(cate.id!);

        if (result == 'ok') {
          snackAlert("Xóa thành công!", context);
        } else {
          snackAlert("Xóa không thành công", context);
        }

        setState(() {});

        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Bạn có chắc?"),
      content: const Text(
          "Nếu xóa loại sản phẩm bạn sẽ mất nó vĩnh viễn bạn chắc chứ??"),
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
        title: const Text("Quản lý loại sản phẩm",style: TextStyle(fontFamily: 'RobotoCondensed'),),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<CategoryModel>>(
                future: getListCategory(),
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

                  List<CategoryModel> result = snapshot.data!;

                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    physics: const NeverScrollableScrollPhysics(), // Disable scrolling for ListView
                    shrinkWrap: true, // Shrink the ListView to its content
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      CategoryModel cate = result[index];
                      return Card(
                        elevation: 4, // Add shadow for card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Add border radius
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
                                          offset: const Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    width: 50,
                                    height: 50,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        cate.imageURL!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cate.name!,
                                        style: const TextStyle(
                                          fontFamily: 'RobotoCondensed',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Add any other text or widgets if needed
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return UpdateCategoryPage(cateModel: cate);
                                        },
                                      ));
                                      await getCategoriesAll();
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: () {
                                      showAlertDialog(context, cate);
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
                builder: (context) => const AddCatePage(),
              ));
          await getCategoriesAll();
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
