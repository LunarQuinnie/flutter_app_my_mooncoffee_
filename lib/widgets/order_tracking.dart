import 'package:final_app/colors.dart';
import 'package:final_app/mainpage.dart';
import 'package:final_app/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:final_app/app/model/order.dart';
import 'package:final_app/app/model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/data/api.dart'; // Ensure APIRepository is imported
import '../utils.dart';

class OrderTrackingPage extends StatefulWidget {
  final List<Order> orders;
  final List<ProductModel> products;

  const OrderTrackingPage({
    required this.orders,
    required this.products,
    Key? key,
  }) : super(key: key);

  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  void _showAlertDialog(BuildContext context) async {
    Widget cancelButton = TextButton(
      child: const Text("Hủy",style: TextStyle(fontFamily: 'RobotoCondensed')),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Đồng ý",style: TextStyle(fontFamily: 'RobotoCondensed')),
      onPressed: () async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        String token = pref.getString("token")!;
        List<Order> _orders = widget.orders;

        // Call paymentCart from APIRepository
        String result = await APIRepository().paymentCart(_orders, token);

        if (result == "ok") {
          snackAlert("Đơn hàng đã được đánh dấu là đã nhận", context);
        } else {
          snackAlert("Cập nhật trạng thái đơn hàng thất bại", context);
        }

        // Cập nhật lại dữ liệu nếu cần
        setState(() {});

        Navigator.of(context).pop(); // Đóng dialog

        // Chuyển đến trang HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Mainpage()), // Thay HomePage() bằng widget của bạn
        );
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Bạn có chắc?",style: TextStyle(fontFamily: 'RobotoCondensed'),),
      content: const Text("Bạn có chắc muốn đánh dấu đơn hàng đã nhận?",style: TextStyle(fontFamily: 'RobotoCondensed')),
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
    final double shippingFee = 0; // Assuming fixed shipping fee for simplicity
    final double totalPrice = widget.orders.fold(0, (sum, order) {
      final product = widget.products.firstWhere((product) => product.id == order.id);
      return sum + (product.price ?? 0) * (order.count ?? 0);
    }) + shippingFee;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Theo dõi đơn hàng',
              style: TextStyle(color: Colors.black,fontFamily: 'RobotoCondensed'),
            ),
            Spacer(),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Mainpage()),
                  );
                },
                child: Icon(Icons.home)
            ),
          ],
        ),
        backgroundColor: Color(0xFF9294cc),centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần 1: Thời gian nhận hàng
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Thời gian nhận hàng: 16:00 - 18:00', // Ví dụ thời gian nhận hàng
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,fontFamily: 'RobotoCondensed'),
            ),
          ),
          // Phần 2: Thông tin tài xế
          Padding(
            padding: const EdgeInsets.only(top: 10.0,left: 16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage('https://example.com/driver-avatar.jpg'), // Thay URL của avatar tài xế
                  radius: 30,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tên tài xế: Nguyễn Văn A', // Tên tài xế
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,fontFamily: 'RobotoCondensed'),
                      ),
                      Text(
                        'Tuổi: 30', // Tuổi tài xế
                        style: TextStyle(fontSize: 16,fontFamily: 'RobotoCondensed'),
                      ),
                      Text(
                        'Số điện thoại: 0901234567', // Số điện thoại tài xế
                        style: TextStyle(fontSize: 16,fontFamily: 'RobotoCondensed'),
                      ),
                      Text(
                        'Đánh giá: ⭐️ 4.8', // Đánh giá tài xế
                        style: TextStyle(fontSize: 16,fontFamily: 'RobotoCondensed'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          // Phần 3: Thông tin đơn hàng
          Padding(
            padding: const EdgeInsets.only(top:16.0,left: 16),
            child: Text(
              'Thông tin đơn hàng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,fontFamily: 'RobotoCondensed'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.orders.length,
              itemBuilder: (context, index) {
                final order = widget.orders[index];
                final product = widget.products.firstWhere((product) => product.id == order.id);
                return Padding(
                  padding: const EdgeInsets.only(left: 10.0,right: 10), // Added padding here
                  child: Card(
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
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
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
                SizedBox(height: 10),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200, // Chiều rộng nút sẽ chiếm toàn bộ chiều ngang
                  height: 45, // Tăng chiều cao nút
                  child: ElevatedButton(
                    onPressed: () {
                      _showAlertDialog(context);
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

            ],
          ),
          SizedBox(height: 12,),SizedBox(height: 12,),
          SizedBox(height: 12,),
          SizedBox(height: 12,),
        ],
      ),
    );
  }
}
