import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group13_mobileprograming/pages/Home/admin/medicines/EditMedicineScreen.dart';
import 'package:group13_mobileprograming/pages/Home/admin/medicines/addmedicine.dart';

class MedicineListScreen extends StatelessWidget {
  Future<void> _deleteMedicine(BuildContext scaffoldContext, String docId) async {
    try {
      await FirebaseFirestore.instance.collection('medicines').doc(docId).delete();
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(content: Text('Thuốc đã được xóa.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  void _editMedicine(BuildContext context, String docId, Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMedicineScreen(docId: docId, medicineData: data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách thuốc')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('medicines').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Không có thuốc nào trong kho.'));
          }
          final medicines = snapshot.data!.docs;
          return ListView.builder(
            itemCount: medicines.length,
            itemBuilder: (context, index) {
              final medicine = medicines[index];
              return ListTile(
                leading: medicine['image_url'] != null
                    ? Image.network(medicine['image_url'], width: 50)
                    : null,
                title: Text(medicine['name']),
                subtitle: Text(
                  'Giá: ${medicine['price']} - Số lượng: ${medicine['quantity']}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editMedicine(context, medicine.id, medicine.data()),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteMedicine(context, medicine.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Điều hướng đến trang thêm sản phẩm
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMedicineScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Thêm sản phẩm',
      ),
    );
  }
}
