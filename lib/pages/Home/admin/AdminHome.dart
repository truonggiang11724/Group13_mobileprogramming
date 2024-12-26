import 'package:flutter/material.dart';
import 'package:group13_mobileprograming/pages/Advise/AdviseHome.dart';
import 'package:group13_mobileprograming/pages/Home/admin/categories/CategoryManagementScreen.dart';
import 'package:group13_mobileprograming/pages/Home/admin/medicines/medicinelist.dart';
import 'package:group13_mobileprograming/pages/Personal/Support/AboutUsPage.dart';
import 'package:group13_mobileprograming/pages/Personal/Support/FAQPage.dart';

class Adminhome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hỗ trợ'),
        backgroundColor: Colors.teal[300],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.chat_bubble_outline, color: Colors.teal),
            title: Text('Quản lý sản phẩm'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MedicineListScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info_outline, color: Colors.teal),
            title: Text('Quản lý loại sản phẩm'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryManagementScreen()),
              );
            },
          ),

        ],
      ),
    );
  }
}