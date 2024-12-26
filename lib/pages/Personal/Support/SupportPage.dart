import 'package:flutter/material.dart';
import 'package:group13_mobileprograming/pages/Advise/AdviseHome.dart';
import 'package:group13_mobileprograming/pages/Personal/Support/AboutUsPage.dart';
import 'package:group13_mobileprograming/pages/Personal/Support/FAQPage.dart';

class SupportPage extends StatelessWidget {
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
            title: Text('Tư vấn'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Advisehome()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info_outline, color: Colors.teal),
            title: Text('Về chúng tôi'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help_outline, color: Colors.teal),
            title: Text('Câu hỏi thường gặp'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FAQPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}