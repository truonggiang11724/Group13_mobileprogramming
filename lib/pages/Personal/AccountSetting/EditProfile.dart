import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group13_mobileprograming/pages/Personal/AccountSetting/ChangePasswordPage.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;

  // Controller cho các trường dữ liệu
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();

  // Biến để lưu trữ ngày sinh đã chọn
  DateTime? _selectedBirthdate;

  // ID tài liệu (docID) lấy được sau khi truy vấn
  String? _docId;

  @override
  void initState() {
    super.initState();
    // Lấy thông tin người dùng từ Firestore khi trang được tạo
    _fetchUserData();
  }

  // Hàm lấy dữ liệu người dùng từ Firestore
  Future<void> _fetchUserData() async {
    try {
      // Truy vấn tài liệu dựa trên trường user_id
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('user_id', isEqualTo: user?.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Lấy tài liệu đầu tiên
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        _docId = userDoc.id; // Lưu lại docID để sử dụng khi cập nhật

        // Gán giá trị từ document vào các controller
        _fullNameController.text = userDoc['full_name'] ?? '';
        _phoneController.text = userDoc['phone'] ?? '';
        if (userDoc['birthdate'] != null) {
          _selectedBirthdate = userDoc['birthdate'].toDate();
          _birthdateController.text =
              _selectedBirthdate.toString().split(' ')[0];
        }
      } else {
        // Nếu không tìm thấy tài liệu, thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No user found with the provided user_id'),
        ));
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Hàm lưu thông tin người dùng vào Firestore
  Future<void> _saveUserData() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_docId != null) {
        try {
          // Cập nhật thông tin vào Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_docId)
              .update({
            'full_name': _fullNameController.text,
            'phone': _phoneController.text,
            'birthdate': _selectedBirthdate,
          });

          // Sau khi cập nhật thành công, quay lại trang trước
          Navigator.pop(context);
        } catch (e) {
          print('Error saving user data: $e');
        }
      } else {
        print('Error: No docId found');
      }
    }
  }

  // Hàm chọn ngày sinh từ picker
  Future<void> _selectBirthdate(BuildContext context) async {
    DateTime initialDate = _selectedBirthdate ?? DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedBirthdate) {
      setState(() {
        _selectedBirthdate = picked;
        _birthdateController.text =
            picked.toString().split(' ')[0]; // Chỉ lấy phần ngày (yyyy-MM-dd)
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chỉnh sửa thông tin cá nhân',
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.teal[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trường nhập họ tên
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a full name';
                  }
                  return null;
                },
              ),
              // Trường nhập số điện thoại
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  } else if (!RegExp(r"^[0-9]{10}$").hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              // Trường nhập ngày sinh
              TextFormField(
                controller: _birthdateController,
                decoration: InputDecoration(labelText: 'Birthdate'),
                readOnly: true,
                onTap: () => _selectBirthdate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a birthdate';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Nút lưu thông tin
              ElevatedButton(
                onPressed: _saveUserData,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
