import 'package:flutter/material.dart';
import '../widget/app_scaffold.dart';
import 'dashboard.dart';
import 'register.dart';
import '../controllers/AuthController.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authController = Authcontroller();

  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final String emailOrPhone = _emailOrPhoneController.text.trim();
    final String password = _passwordController.text;

    if (emailOrPhone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Бүх талбарыг бөглөнө үү"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final bool success = await authController.login(
      emailOrPhone: emailOrPhone,
      password: password,
    );

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Нэвтрэх нэр эсвэл нууц үг буруу"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Хөрсний чийгийн мэдрэгч",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Цаг агаар, хөрсний чийгэд суурилсан\nусалгааны зөвлөгөөний систем",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 32),

            /// EMAIL / PHONE
            TextField(
              controller: _emailOrPhoneController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Имэйл эсвэл утас",
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: Colors.white70,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.greenAccent,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// PASSWORD
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Нууц үг",
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Colors.white70,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.greenAccent,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// LOGIN BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Нэвтрэх",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),

            const SizedBox(height: 12),

            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  "Шинэ хэрэглэгч? Бүртгэл үүсгэх",
                  style: TextStyle(color: Colors.greenAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
