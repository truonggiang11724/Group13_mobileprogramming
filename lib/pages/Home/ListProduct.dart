import 'package:flutter/material.dart';
import 'package:group13_mobileprograming/pages/Category/MedicineDetailPage.dart';

class ProductItem extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(

      width: 150, // Chiều rộng của mỗi sản phẩm
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              product['image_url'],
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 7.0),
          Text(
            product['name'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),
          Text('Giá: ${product['price']*(1-product['promote']*0.01)}đ'),
          ElevatedButton(
            onPressed: () {
              // Điều hướng đến trang chi tiết sản phẩm
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product),
                ),
              );
            },
            child: Text('Xem chi tiết'),
          ),
        ],
      ),
    );
  }
}