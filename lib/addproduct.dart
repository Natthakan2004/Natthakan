import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'ShowProduct.dart';

//Method หลักทีRun
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAjV8fVy3j-OZBFDu8f-yL0Dzj1S78Wv6Q",
            authDomain: "onlinefirebase-391dc.firebaseapp.com",
            databaseURL:
                "https://onlinefirebase-391dc-default-rtdb.firebaseio.com",
            projectId: "onlinefirebase-391dc",
            storageBucket: "onlinefirebase-391dc.firebasestorage.app",
            messagingSenderId: "1046088414688",
            appId: "1:1046088414688:web:224665b4f0569dc932e785",
            measurementId: "G-F0BEDDT7RZ"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

//Class stateless สั่งแสดงผลหนาจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 205, 169, 240)),
        useMaterial3: true,
      ),
      home: addproduct(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class addproduct extends StatefulWidget {
  @override
  State<addproduct> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<addproduct> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป

//ประกาศตัวแปรทั้งหมด
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController(); //ชื่อ
  final TextEditingController desController =
      TextEditingController(); //คำรายระเอียด
  final TextEditingController priceController = TextEditingController(); //ราคา
  final TextEditingController quantityController =
      TextEditingController(); //จำนวน
  final TextEditingController dateController =
      TextEditingController(); //วันที่ที่เลือก
  final categories = ['Electronics', 'Clothing', 'Food', 'Books'];
  String? selectedCategory;

//ประกาศตัวแปรRadio
  int _selectedRadio = 0; //กำหนดค่าเริ่มต้นการเลือก
  String _selectedOption = ''; //กำหนดค่าเริ่มต้นข้อความที่เลือก
  Map<int, String> radioOptions = {
    1: 'ให้ส่วนลด',
    2: 'ไม่ให้ส่วนลด',
  };

//ประกาศตัวแปรเก็บค่าการเลือกวันที่
  DateTime? productionDate;
//สรางฟังก์ชันให้เลือกวันที่
  Future<void> pickProductionDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: productionDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != productionDate) {
      setState(() {
        productionDate = pickedDate;
        dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> saveProductToDatabase() async {
    try {
// สร้าง reference ไปยัง Firebase Realtime Database
      DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
//ข้อมูลสินค้าที่จะจัดเก็บในรูปแบบ Map
      //ชื่อตัวแปรที่รับค่าที่ผู้ใช้ป้อนจากฟอร์มต้องตรงกับชื่อตัวแปรที่ตั้งตอนสร้างฟอร์มเพื่อรับค่า
      Map<String, dynamic> productData = {
        'name': nameController.text,
        'description': desController.text,
        'category': selectedCategory,
        'productionDate': productionDate?.toIso8601String(),
        'price': double.parse(priceController.text),
        'quantity': int.parse(quantityController.text),
        'discount': _selectedOption,
      };
//ใช้คําสั่ง push() เพื่อสร้าง key อัตโนมัติสําหรับสินค้าใหม่
      await dbRef.push().set(productData);
//แจ้งเตือนเมื่อบันทึกสําเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกข้อมูลสําเร็จ')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShowProduct()),
      );
// รีเซ็ตฟอร์ม
      _formKey.currentState?.reset();
      nameController.clear();
      desController.clear();
      priceController.clear();
      quantityController.clear();
      dateController.clear();
      setState(() {
        selectedCategory = null;
        productionDate = null;
        _selectedOption = '';
      });
    } catch (e) {
//แจ้งเตือนเมื่อเกิดข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

//ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 240, 129, 240),
        title: Text('Add Product'),
      ),
      body: Stack(
        children: [
          // พื้นหลังเป็นภาพ
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg2.png'), // ใส่ชื่อไฟล์ภาพพื้นหลัง
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
//ส่วนการออกแบบหน้าจอ
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: 'ชื่อสินค้า*',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกชื่อสินค้า';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: desController,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          labelText: 'รายละเอียดสินค้า*',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกรายละเอียดสินค้า';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                          labelText: 'ประเภทสินค้า',
                          border: OutlineInputBorder()),
                      items: categories
                          .map((category) => DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาเลือกประเภทสินค้า';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'วันที่ผลิตสินค้า',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => pickProductionDate(context),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาเลือกวันที่ผลิต';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: priceController,
                      decoration: InputDecoration(
                          labelText: 'ราคาสินค้า*',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกราคสินค้า';
                        }
                        if (int.tryParse(value) == null) {
                          return 'กรุณากรอกราคสินค้าเป็นตัวเลข';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: quantityController,
                      decoration: InputDecoration(
                          labelText: 'จำนวนสินค้า*',
                          border: OutlineInputBorder()),

                      ///ใส่ใหม่ตัวเลข
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกจำนวนสินค้า';
                        }
                        if (int.tryParse(value) == null) {
                          return 'กรุณากรอกจำนวนสินค้าเป็นตัวเลข';
                        }
                        return null;
                      },
                    ),
                    Column(
                      children: radioOptions.entries.map((entry) {
                        return RadioListTile<int>(
                          title: Text(entry.value),
                          value: entry.key,
                          groupValue: _selectedRadio,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedRadio = value!;
                              _selectedOption = radioOptions[_selectedRadio]!;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // ดำเนินการเมื่อฟอร์มผ่านการตรวจสอบ
                          saveProductToDatabase();
                        }
                      },
                      child: Text('บันทึกสินค้า'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // เคลียร์ค่าทั้งหมดในฟอร์ม
                        _formKey.currentState?.reset();
                        nameController.clear();
                        desController.clear();
                        priceController.clear();
                        quantityController.clear();
                        dateController.clear();
                        setState(() {
                          selectedCategory = null;
                          productionDate = null;
                          _selectedOption = '';
                          _selectedRadio = 0; // รีเซ็ตค่าการเลือก
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(
                            255, 68, 245, 127), // สีพื้นหลังของปุ่ม
                        foregroundColor: Colors.white, // สีของข้อความบนปุ่ม
                      ),
                      child: Text('เคลียร์ค่า'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
