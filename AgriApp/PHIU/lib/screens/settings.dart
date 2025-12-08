import 'package:agriapp/screens/AddFieldTestScreen.dart';
import 'package:flutter/material.dart';
import '../widget/app_scaffold.dart';
import 'login.dart';

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

              // Developer Tools Section
              const Text(
                "Хөгжүүлэгчийн хэрэгсэл",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              // Test Backend Button
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.bug_report,
                    color: Colors.greenAccent,
                  ),
                ),
                title: const Text(
                  "Backend тест",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  "Талбай нэмэх, backend шалгах",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 16,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddFieldTestScreen(),
                    ),
                  );
                },
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
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  onPressed: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xff020617),
                        title: const Text(
                          'Гарах уу?',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: const Text(
                          'Та системээс гарахдаа итгэлтэй байна уу?',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Үгүй',
                              style: TextStyle(color: Colors.white54),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              'Тийм',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // App Info Section
              const Text(
                "Апп-ын мэдээлэл",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Хувилбар",
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
                trailing: const Text(
                  "1.0.0",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Backend холболт",
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
                trailing: const Text(
                  "10.85.29.106",
                  style: TextStyle(color: Colors.greenAccent, fontSize: 11),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
