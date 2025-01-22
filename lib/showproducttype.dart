import 'package:flutter/material.dart';
import 'showfiltertype.dart'; // Import หน้าที่เกี่ยวข้อง

class showproducttype extends StatelessWidget {
  // กำหนดรายการประเภทสินค้า
  final List<String> categories = ['Electronics', 'Clothing', 'Food', 'Books'];

  // กำหนดไอคอนที่ตรงกับประเภทสินค้าแต่ละประเภท
  final List<IconData> categoryIcons = [
    Icons.electrical_services, // Electronics
    Icons.shopping_bag, // Clothing
    Icons.fastfood, // Food
    Icons.book, // Books
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประเภทสินค้า'),
        backgroundColor: const Color.fromARGB(255, 240, 129, 240),
        foregroundColor: Colors.black,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 รายการต่อแถว
                crossAxisSpacing: 10.0, // ระยะห่างระหว่างคอลัมน์
                mainAxisSpacing: 10.0, // ระยะห่างระหว่างแถว
                childAspectRatio: 1 / 1.5, // กำหนดอัตราส่วน กว้าง : สูง
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // นำทางไปยังหน้า showfiltertype พร้อมส่งข้อมูล category
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            showfiltertype(category: categories[index]),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 6,
                    color: Color.fromARGB(255, 71, 223, 215), // สีพื้นหลังของ Card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // ขอบมน
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          categoryIcons[index], // ใช้ไอคอนจากรายการที่กำหนด
                          size: 40,
                          color: Color.fromARGB(255, 0, 0, 0), // สีไอคอน
                        ),
                        const SizedBox(height: 10),
                        Text(
                          categories[index], // ชื่อประเภทสินค้า
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color.fromARGB(255, 0, 0, 0), // สีข้อความ
                          ),
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
