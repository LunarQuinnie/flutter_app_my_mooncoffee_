import 'package:flutter/material.dart';
import 'package:final_app/app/model/order.dart';
import 'package:final_app/app/model/product.dart';
import '../app/model/user.dart';
import '../utils.dart';
import 'order_tracking.dart';

class OrderDetailPage extends StatefulWidget {
  final List<Order> orders;
  final List<ProductModel> products;
  final User user;

  const OrderDetailPage({
    required this.orders,
    required this.products,
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late User _user;
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _nameController = TextEditingController(text: _user.fullName);
    _addressController = TextEditingController(text: "34 Sư Vạn Hạnh, Quận 10, HCM");
    _phoneController = TextEditingController(text: _user.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showEditAddressDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chỉnh sửa địa chỉ nhận hàng'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Tên người nhận'),
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Địa chỉ'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _user = User(
                    idNumber: _user.idNumber,
                    accountId: _user.accountId,
                    fullName: _nameController.text,
                    phoneNumber: _phoneController.text,
                    imageURL: _user.imageURL,
                    birthDay: _user.birthDay,
                    gender: _user.gender,
                    schoolYear: _user.schoolYear,
                    schoolKey: _user.schoolKey,
                    dateCreated: _user.dateCreated,
                    status: _user.status,
                  );
                });
                Navigator.of(context).pop();
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double shippingFee = 0; // Assuming fixed shipping fee for simplicity
    final double totalPrice = widget.orders.fold(0, (sum, order) {
      final product = widget.products.firstWhere((product) => product.id == order.id);
      return sum + (product.price ?? 0) * (order.count ?? 0);
    }) + shippingFee;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thanh toán',
          style: TextStyle(color: Colors.black, fontFamily: 'RobotoCondensed'),
        ),
        backgroundColor: Color(0xFFEBEAF3),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thông tin đơn hàng', style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: 18,fontWeight: FontWeight.bold),),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: widget.orders.length,
                itemBuilder: (context, index) {
                  final order = widget.orders[index];
                  final product = widget.products.firstWhere((product) => product.id == order.id);
                  return Card(
                    color: Color(0xFFEDEAFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                product.imageURL ?? '',
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name ?? '',
                                    style: TextStyle(
                                      fontFamily: 'RobotoCondensed',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    formatMoney(product.price!.toInt()),
                                    style: const TextStyle(
                                      fontFamily: 'RobotoCondensed',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF7B61FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Số lượng ${order.count}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFFEBEAF3),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Địa chỉ nhận hàng',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tên người nhận: ${_user.fullName}',
                    style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Địa chỉ: ${_addressController.text}',
                    style: TextStyle(fontFamily: 'RobotoCondensed',
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Số điện thoại: ${_user.phoneNumber}',
                    style: TextStyle(fontFamily: 'RobotoCondensed',
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _showEditAddressDialog,
                        icon: Icon(Icons.edit, color: Colors.black),
                        label: Text(
                          'Chỉnh sửa',
                          style: TextStyle(fontFamily: 'RobotoCondensed',color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFDAD7E3),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Add note logic
                        },
                        icon: Icon(Icons.note_add, color: Colors.black),
                        label: Text(
                          'Ghi chú',
                          style: TextStyle(color: Colors.black,fontFamily: 'RobotoCondensed',),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFDAD7E3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Chi tiết thanh toán',
              style: TextStyle(fontSize: 18,fontFamily: 'RobotoCondensed', fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Giá thành:',style: TextStyle(fontFamily: 'RobotoCondensed',),),
                Text(formatMoney(widget.orders.fold(0, (sum, order,) {
                  final product = widget.products.firstWhere((product) => product.id == order.id);
                  return sum + (product.price ?? 0) * (order.count ?? 0);
                })),style: TextStyle(fontFamily: 'RobotoCondensed',),
                )
                ,
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Phí giao hàng:',style: TextStyle(fontFamily: 'RobotoCondensed',),),
                Text(formatMoney(shippingFee.toInt()),
                style: TextStyle(fontFamily: 'RobotoCondensed',),),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng thành tiền:',
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'RobotoCondensed',),
                ),
                Text(
                  formatMoney(totalPrice.toInt()),
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'RobotoCondensed',),
                ),
              ],
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: SizedBox(

                width: double.infinity, // Chiều rộng nút sẽ chiếm toàn bộ chiều ngang
                height: 50, // Tăng chiều cao nút
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderTrackingPage(
                          orders: widget.orders,
                          products: widget.products,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Xác nhận',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'RobotoCondensed',
                      fontSize: 18, // Tăng kích thước chữ
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6667AB),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12,)
          ],
        ),
      ),
    );
  }
}
