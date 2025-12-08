// Create: lib/screens/add_field_test.dart
// This is a test screen to add fields to your backend

import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddFieldTestScreen extends StatefulWidget {
  const AddFieldTestScreen({Key? key}) : super(key: key);

  @override
  State<AddFieldTestScreen> createState() => _AddFieldTestScreenState();
}

class _AddFieldTestScreenState extends State<AddFieldTestScreen> {
  final ApiService _api = ApiService();
  bool _loading = false;
  String _message = '';

  Future<void> _addTestFields() async {
    setState(() {
      _loading = true;
      _message = 'Талбай нэмж байна...';
    });

    try {
      // Add Field A - Wheat
      await _api.createField(
        size: 2.5,
        location: 'Ulaanbaatar',
        crop: 'wheat',
        plantingDate: DateTime.now().toIso8601String(),
      );

      // Add Field B - Potato
      await _api.createField(
        size: 3.0,
        location: 'Ulaanbaatar',
        crop: 'potato',
        plantingDate: DateTime.now().toIso8601String(),
      );

      // Add Field C - Tomato
      await _api.createField(
        size: 1.5,
        location: 'Ulaanbaatar',
        crop: 'tomato',
        plantingDate: DateTime.now().toIso8601String(),
      );

      setState(() {
        _loading = false;
        _message = '✅ 3 талбай амжилттай нэмэгдлээ!';
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Талбайнууд амжилттай нэмэгдлээ!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _message = '❌ Алдаа: $e';
      });
    }
  }

  Future<void> _checkFields() async {
    setState(() {
      _loading = true;
      _message = 'Талбайнуудыг шалгаж байна...';
    });

    try {
      final fields = await _api.getAllFields();

      setState(() {
        _loading = false;
        _message =
            '📊 Нийт ${fields.length} талбай байна\n\n' +
            fields.map((f) => '• ${f['crop']} - ${f['size']} га').join('\n');
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _message = '❌ Алдаа: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f172a),
      appBar: AppBar(
        backgroundColor: const Color(0xff020617),
        title: const Text('Талбай нэмэх тест'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_loading)
                const CircularProgressIndicator(color: Colors.greenAccent)
              else
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xff020617),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Text(
                    _message.isEmpty
                        ? 'Доорх товчийг дарж талбай нэмнэ үү'
                        : _message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

              const SizedBox(height: 40),

              ElevatedButton.icon(
                onPressed: _loading ? null : _addTestFields,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('3 Туршилтын талбай нэмэх'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: _loading ? null : _checkFields,
                icon: const Icon(Icons.list),
                label: const Text('Талбайнуудыг шалгах'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.greenAccent,
                  side: const BorderSide(color: Colors.greenAccent),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'ℹ️ Заавар:',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Backend сервер ажиллаж байгаа эсэхийг шалгаарай\n'
                      '2. "3 Туршилтын талбай нэмэх" дарна уу\n'
                      '3. Дашбоард руу буцаад refresh хийнэ үү\n'
                      '4. Талбайнууд харагдана!',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
