import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Câu hỏi thường gặp'),
        backgroundColor: Colors.teal[300],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ExpansionTile(
            title: Text(
              'Làm thế nào để đặt hàng?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Bạn có thể đặt hàng thông qua ứng dụng hoặc liên hệ trực tiếp với chúng tôi qua số điện thoại.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            title: Text(
              'Phương thức thanh toán là gì?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Chúng tôi hỗ trợ thanh toán qua thẻ tín dụng, chuyển khoản ngân hàng, hoặc thanh toán khi nhận hàng.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            title: Text(
              'Thời gian giao hàng bao lâu?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Thời gian giao hàng thông thường từ 2-5 ngày làm việc, tùy thuộc vào địa điểm của bạn.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            title: Text(
              'Chính sách đổi trả như thế nào?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Nếu sản phẩm có lỗi từ nhà sản xuất, bạn có thể đổi trả trong vòng 7 ngày kể từ ngày nhận hàng.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            title: Text(
              'Làm thế nào để liên hệ với chúng tôi?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Bạn có thể liên hệ với chúng tôi qua email support@nhathuoc.com hoặc gọi hotline: 0123-456-789.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}