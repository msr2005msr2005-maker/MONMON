import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

const primary = Color(0xFF365CF5);
const ink = Color(0xFF122044);
const bg = Color(0xFFF4F7FD);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'مستخدم MONMON';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: primary,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              email,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ink),
            ),
            const SizedBox(height: 10),
            const Text(
              'عضو نشط في مجتمع MONMON الاجتماعي',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('تسجيل الخروج', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
