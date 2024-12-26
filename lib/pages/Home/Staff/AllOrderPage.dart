import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    List<Map<String, dynamic>> ordersList = [];
    QuerySnapshot ordersSnapshot = await _firestore.collection('orders').get();

    for (var orderDoc in ordersSnapshot.docs) {
      var orderData = orderDoc.data() as Map<String, dynamic>;
      String orderId = orderDoc.id;

      // Fetch associated user
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('user_id', isEqualTo: orderData['user_id'])
          .get();

      // Nếu userSnapshot không có dữ liệu, tiếp tục vòng lặp
      if (userSnapshot.docs.isEmpty) {
        continue;
      }
      var userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

      // Fetch order items and products
      QuerySnapshot itemsSnapshot = await _firestore
          .collection('order_items')
          .where('order_id', isEqualTo: orderId)
          .get();
      var itemData = itemsSnapshot.docs.first.data() as Map<String, dynamic>;


      List<Map<String, dynamic>> productsList = [];
      for (var itemDoc in itemsSnapshot.docs) {
        var itemData = itemDoc.data() as Map<String, dynamic>;
        DocumentSnapshot productSnapshot = await _firestore
            .collection('medicines')
            .doc(itemData['product_id'])
            .get();
        var productData = productSnapshot.data() as Map<String, dynamic>;
        productsList.add(productData);
      }

      ordersList.add({
        'order_id': orderId,
        'status': orderData['status'],
        'user': userData,
        'products': productsList,
        'item': itemData,
      });
    }

    return ordersList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orders')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders available'));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order ID: ${order['order_id']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Status: ${order['status']}'),
                      Text('Customer: ${order['user']['Name']}'),
                      Text('Phone: ${order['user']['phone']}'),
                      SizedBox(height: 8.0),
                      Text('Products:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ...order['products'].map<Widget>((product) {
                        return Text(
                            '- ${product['name']} (${product['price']}đ)-SL: ${order['item']['quantity']}');
                      }).toList(),
                      SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () async {
                          String newStatus =
                          order['status'] == 'pending' ? 'completed' : 'pending';

                          await _firestore
                              .collection('orders')
                              .doc(order['order_id'])
                              .update({'status': newStatus});

                          setState(() {}); // Refresh the UI
                        },
                        child: Text(order['status'] == 'pending'
                            ? 'Mark as Completed'
                            : 'Mark as Pending'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
