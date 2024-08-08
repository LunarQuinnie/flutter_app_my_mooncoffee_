import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_app/app/data/api.dart';
import 'package:final_app/app/model/payment.dart';
import 'package:final_app/utils.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Payment> _histPay = [];

  Future<List<Payment>> getHistoryPayments() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token")!;
    _histPay = await APIRepository().getHistoryPayment(token);

    return _histPay;
  }

  @override
  void initState() {
    super.initState();

    // getHistoryPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử mua hàng",style: TextStyle(fontFamily: 'RobotoCondensed'),),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Payment>>(
        future: getHistoryPayments(),
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
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 18,
                    ),
                    itemBuilder: (context, index) {
                      final payment = snapshot.data![index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(255, 255, 255, 0.098),
                                blurRadius: 0,
                                spreadRadius: 0,
                                offset: Offset(
                                  0,
                                  1,
                                ),
                              ),
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Container(
                                    width: 320,
                                    child: Text(
                                      "Hóa đơn: ${payment.id}",
                                      style: const TextStyle(
                                          fontFamily: 'RobotoCondensed',
                                          color: Color.fromARGB(
                                              255, 176, 179, 232)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 0,
                                ),
                                Text(
                                  "Tên khách hàng: ${payment.fullName}",
                                  style: const TextStyle(
                                      fontFamily: 'RobotoCondensed',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 0,
                                ),
                                Text("Ngày tạo: ${payment.dateCreated}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'RobotoCondensed',
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 0,
                                ),
                                Text(
                                    "Tổng hóa đơn: ${formatMoney(payment.total!)}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'RobotoCondensed',
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(128, 125, 98, 201)))
                              ],
                            ),
                            IconButton(
                                onPressed: () async {
                                  SharedPreferences pre =
                                      await SharedPreferences.getInstance();
                                  String token = pre.getString("token")!;
                                  String result = await APIRepository()
                                      .deletePayment(payment.id!, token);
                                  if (result == "ok") {
                                    snackAlert(
                                        "Remove success order: ${payment.id}",
                                        context);
                                    setState(() {});
                                  } else {
                                    snackAlert(
                                        "Remove fail order: ${payment.id}",
                                        context);
                                  }
                                },
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: const Text("Chưa có lịch sử mua hàng nào!?"),
                );
        },
      ),
    );
  }
}
