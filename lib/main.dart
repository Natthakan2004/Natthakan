import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onlinedb_natthakan/addproduct.dart';
import 'package:onlinedb_natthakan/showfiltertype.dart';
import 'package:onlinedb_natthakan/showproduct.dart';
import 'package:onlinedb_natthakan/showproductgrid.dart';
import 'package:onlinedb_natthakan/showproducttype.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: Main(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Main> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป
//ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // พื้นหลังเป็นภาพ
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg1.png'), // ใส่ชื่อไฟล์ภาพพื้นหลัง
                fit: BoxFit.cover,
              ),
            ),
          ),
          // เนื้อหาหลัก
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 500,
                    height: 300,
                    child: Image.asset('assets/logo.png'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => addproduct()),
                      );
                    },
                    child: Text(
                      'บันทึกสินค้า',
                      style: TextStyle(color: Colors.black), // สีตัวอักษร
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50), // ขนาดปุ่ม
                    ),
                  ),
                  SizedBox(height: 20), // เว้นระยะห่าง
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => showproductgrid()),
                      );
                    },
                    child: Text(
                      'แสดงสินค้า',
                      style: TextStyle(color: Colors.black), // สีตัวอักษร
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50), // ขนาดปุ่ม
                    ),
                  ),
                  SizedBox(height: 20), // เว้นระยะห่าง
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => showproducttype()),
                      );
                    },
                    child: Text(
                      'ประเภทสินค้า',
                      style: TextStyle(color: Colors.black), // สีตัวอักษร
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50), // ขนาดปุ่ม
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

