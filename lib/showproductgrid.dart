import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

//Method หลักทีRun
void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: showproductgrid(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class showproductgrid extends StatefulWidget {
  @override
  State<showproductgrid> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<showproductgrid> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป
// สราง referenceชื่อ dbRef ไปยังตารางชื่อ products
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];
  Future<void> fetchProducts() async {
    try {
      final query = dbRef.orderByChild('price').startAt(0).endAt(100000);

// ดึงข้อมูลจาก Realtime Database
      final snapshot = await query.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
// วนลูปเพื่อแปลงข้อมูลเป็ น Map
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] =
              child.key; // เก็บ key สําหรับการอ้างอิง (เช่นการแก้ไข/ลบ)
          loadedProducts.add(product);
        });
        // **เรียงลําดับข้อมูลตามราคา จากน้อยไปมาก**
        loadedProducts.sort((a, b) => a['price'].compareTo(b['price']));
// อัปเดต state เพื่อแสดงข้อมูล
        setState(() {
          products = loadedProducts;
        });
        print(
            "จํานวนรายการสินค้าทั้งหมด: ${products.length} รายการ"); // Debugging
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล"); // กรณีไม่มีข้อมูล
      }
    } catch (e) {
      print("Error loading products: $e"); // แสดงข้อผิดพลาดทาง Console
// แสดง Snackbar เพื่อแจ้งเตือนผู้ใช้
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // เรียกใช้เมื่อ Widget ถูกสร้าง
  }

//ฟังก์ชันที่ใช้ลบ
  void deleteProduct(String key, BuildContext context) {
//คําสั่งลบโดยอ้างถึงตัวแปร dbRef ที่เชือมต่อตาราง product ไว้
    dbRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบสินค้าเรียบร้อย')),
      );
      fetchProducts();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

//ฟังก์ชันถามยืนยันก่อนลบ
  void showDeleteConfirmationDialog(String key, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิ ด Dialog โดยการแตะนอกพื้นที่
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจว่าต้องการลบสินค้านี้ใช่หรือไม่?'),
          actions: [
// ปุ่ มยกเลิก
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('ไม่ลบ'),
            ),
// ปุ่ มยืนยันการลบ
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
                deleteProduct(key, context); // เรียกฟังก์ชันลบข้อมูล
//ข้อความแจ้งว่าลบเรียบร้อย
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('ลบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

//ฟังก์ชันแสดง AlertDialog หน้าจอเพื่อแก้ไขข้อมูล
  void showEditProductDialog(Map<String, dynamic> product) {
    //ตัวอย่างประกาศตัวแปรเพื่อเก็บค่าข้อมูลเดิมที่เก็บไว้ในฐานข้อมูล ดึงมาเก็บไว้ตัวแปรที่กําหนด
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    TextEditingController selectedCategory =
        TextEditingController(text: product['category']);
    TextEditingController productionDate =
        TextEditingController(text: product['productionDate']);
    TextEditingController quantityController =
        TextEditingController(text: product['quantity']?.toString());
    TextEditingController _selectedOption =
        TextEditingController(text: product['discount']?.toString());
    //สร้าง dialog เพื่อแสดงข้อมูลเก่าและให้กรอกข้อมูลใหม่เพื่อแก้ไข
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลสินค้า'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController, //ดึงข้อมูลชื่อเก่ามาแสดงผลจาก
                  decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                ),
                TextField(
                  controller:
                      descriptionController, //ดึงข้อมูลรายละเอียดเก่ามาแสดงผล
                  decoration: InputDecoration(labelText: 'รายละเอียด'),
                ),
                TextField(
                  controller: priceController, //ดึงข้อมูลราคาเก่ามาแสดงผล
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ราคา'),
                ),
                TextField(
                  controller: selectedCategory, //ดึงข้อมูลชื่อเก่ามาแสดงผลจาก
                  decoration: InputDecoration(labelText: 'ประเภท'),
                ),
                TextField(
                  controller: productionDate, //ดึงข้อมูลรายละเอียดเก่ามาแสดงผล
                  decoration: InputDecoration(labelText: 'วันที่ผลิตสินค้า'),
                ),
                TextField(
                  controller: quantityController, //ดึงข้อมูลราคาเก่ามาแสดงผล
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'จำนวนสินค้า'),
                ),
                TextField(
                  controller: _selectedOption, //ดึงข้อมูลราคาเก่ามาแสดงผล
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ส่วนลด (%)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
// เตรียมข้อมูลที่แก้ไขแล้ว
                Map<String, dynamic> updatedData = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'price': int.parse(priceController.text),
                };
                dbRef.child(product['key']).update(updatedData).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อย')),
                  );
                  fetchProducts(); // เรียกใช้ฟังก์ชันเพื่อโหลดข้อมูลใหม่เพื่อแสดงผลหลังการแก้ไขเช่น fetchProducts
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                });
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

//ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แสดงข้อมูลสินค้า'),
        backgroundColor: const Color.fromARGB(255, 240, 129, 240),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
          products.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: EdgeInsets.all(8),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        color: Color.fromARGB(255, 71, 223, 215),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product['name'] ?? 'Unknown Product',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'รายละเอียดสินค้า: ${product['description']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'ราคา : ${product['price']} บาท',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 0, 4, 255),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .end, // จัดตำแหน่งไปด้านขวา
                                children: [
                                  // ปุ่มลบ
                                  SizedBox(
                                    width: 80,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red[50], // พื้นหลังสีแดงอ่อน
                                        shape: BoxShape.circle, // รูปทรงวงกลม
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          // กดปุ่มลบแล้วจะให้เกิดอะไรขึ้น
                                          showDeleteConfirmationDialog(
                                              product['key'], context);
                                        },
                                        icon: Icon(Icons.delete),
                                        color: Colors.red, // สีของไอคอน
                                        iconSize: 30,
                                        tooltip: 'ลบสินค้า',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      width: 10), // เว้นระยะห่างระหว่างปุ่ม
                                  // ปุ่มแก้ไข
                                  SizedBox(
                                    width: 80,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.red[50], // พื้นหลังสีแดงอ่อน
                                        shape: BoxShape.circle, // รูปทรงวงกลม
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          // เปิด Dialog แก้ไขสินค้า
                                          showEditProductDialog(product);
                                        },
                                        icon: Icon(Icons.edit),
                                        color: Colors.red, // สีของไอคอน
                                        iconSize: 30,
                                        tooltip: 'แก้ไขสินค้า',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
