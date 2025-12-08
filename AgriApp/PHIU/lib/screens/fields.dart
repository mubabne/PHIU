import 'package:flutter/material.dart';
import '../widget/app_scaffold.dart';
import '../widget/field_tile.dart';
import '../widget/section_title.dart';
import 'field_detail.dart';

class FieldsScreen extends StatelessWidget {
  const FieldsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff020617),
        title: const Text("Талбайн жагсаалт"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SectionTitle(title: "Бүртгэлтэй талбайнууд"),
            FieldTile(
              name: "Талбай A",
              crop: "Улаан буудай",
              moisture: 38,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FieldDetailScreen(
                      fieldName: "Талбай A",
                      crop: "Улаан буудай",
                      moisture: 38,
                      minMoisture: 40,
                      maxMoisture: 60,
                    ),
                  ),
                );
              },
            ),
            FieldTile(
              name: "Талбай B",
              crop: "Төмс",
              moisture: 62,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FieldDetailScreen(
                      fieldName: "Талбай B",
                      crop: "Төмс",
                      moisture: 62,
                      minMoisture: 45,
                      maxMoisture: 65,
                    ),
                  ),
                );
              },
            ),
            FieldTile(
              name: "Талбай C",
              crop: "Арвай",
              moisture: 55,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FieldDetailScreen(
                      fieldName: "Талбай C",
                      crop: "Арвай",
                      moisture: 55,
                      minMoisture: 45,
                      maxMoisture: 65,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.greenAccent,
                side: const BorderSide(color: Colors.greenAccent),
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Шинэ талбай нэмэх форм (прототип)")),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Шинэ талбай нэмэх"),
            ),
          ],
        ),
      ),
    );
  }
}
