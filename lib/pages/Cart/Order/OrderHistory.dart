import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  Future<List<Map<String, dynamic>>> fetchOrdersWithItems() async {
    final userId = user?.uid;

    // Lấy danh sách đơn hàng của người dùng
    final ordersSnapshot = await _firestore
        .collection('orders')
        .where('user_id', isEqualTo: userId)
        .get();

    List<Map<String, dynamic>> ordersWithItems = [];

    for (var orderDoc in ordersSnapshot.docs) {
      final orderId = orderDoc.id;
      final orderData = orderDoc.data();

      // Lấy các sản phẩm từ order_items theo order_id
      final orderItemsSnapshot = await _firestore
          .collection('order_items')
          .where('order_id', isEqualTo: orderId)
          .get();

      List<Map<String, dynamic>> items = [];
      for (var itemDoc in orderItemsSnapshot.docs) {
        final itemData = itemDoc.data();
        final productId = itemData['product_id'];

        // Lấy thông tin sản phẩm từ products
        final productDoc = await _firestore.collection('medicines').doc(productId).get();
        if (productDoc.exists) {
          final productData = productDoc.data()!;
          items.add({
            'product': productData,
            'quantity': itemData['quantity'],
          });
        }
      }

      ordersWithItems.add({
        'order': orderData,
        'items': items,
      });
    }

    return ordersWithItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử mua hàng'),
        backgroundColor: Colors.teal[200],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchOrdersWithItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Chưa có đơn hàng nào'));
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index]['order'];
                final items = orders[index]['items'] as List<Map<String, dynamic>>;

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Text('Đơn hàng'),
                    subtitle: Text('Ngày: ${(order['created_at']).toDate()}'),
                    children: items.map((item) {
                      final product = item['product'];
                      final quantity = item['quantity'];
                      return ListTile(
                        title: Text(product['name']),
                        subtitle: Text('Số lượng: $quantity'),
                        trailing: Text('Giá: ${product['price']}'),
                      );
                    }).toList(),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
