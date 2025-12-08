import 'package:agriapp/screens/login.dart';
import 'package:flutter/material.dart';
import '../widget/app_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool notifications = true;
    bool emailAlerts = false;

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff020617),
        title: const Text("Тохиргоо"),
      ),
      body: StatefulBuilder(
        builder: (context, setState) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                "Ерөнхий тохиргоо",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                value: notifications,
                title: const Text(
                  "Апп мэдэгдэл",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  "Чийгийн түвшин, цаг агаарын өөрчлөлтийн талаар",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                onChanged: (v) => setState(() => notifications = v),
              ),
              SwitchListTile(
                value: emailAlerts,
                title: const Text(
                  "Имэйл сэрэмжлүүлэг",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  "Чухал анхааруулгыг имэйлээр давхар илгээх",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                onChanged: (v) => setState(() => emailAlerts = v),
              ),
              const SizedBox(height: 24),
              const Text(
                "Хэрэглэгчийн мэдээлэл",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.person, color: Colors.black),
                ),

                title: const Text(
                  "Admin хэрэглэгч",
                  style: TextStyle(color: Colors.white),
                ),

                subtitle: const Text(
                  "B242270045@must.edu.mn",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),

                trailing: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
