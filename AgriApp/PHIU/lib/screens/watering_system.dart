import 'package:flutter/material.dart';
import '../widget/app_scaffold.dart';
import '../widget/section_title.dart';

class WateringSystem extends StatelessWidget {
  const WateringSystem({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_FieldWaterItem> items = [
      _FieldWaterItem(
        date: "2025-09-20 08:30",
        field: "Талбай 1",
        action: "Хуурай байна, услах шаардлагатай.",
        moistureBefore: 28,    
        moistureAfter: 45,     
      ),
      _FieldWaterItem(
        date: "2025-09-20 08:30",
        field: "Талбай 2",
        action: "Хэвийн түвшинд байна, хөнгөн усалгаа зөвлөмжтэй.",
        moistureBefore: 42,
        moistureAfter: 50,
      ),
      _FieldWaterItem(
        date: "2025-09-19 19:10",
        field: "Талбай 3",
        action: "Саяхан усалсан, одоогоор услах хэрэггүй.",
        moistureBefore: 65,
        moistureAfter: 65,
      ),
    ];

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff020617),
        title: const Text("Усалгааны систем"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SectionTitle(title: "Талбайн усалгааны төлөв"),
            const SizedBox(height: 8),
            ...items.map((e) => _FieldCard(item: e)),
          ],
        ),
      ),
    );
  }
}

class _FieldWaterItem {
  final String date;           
  final String field;          
  final String action;         
  final int moistureBefore;    
  final int moistureAfter;     

  const _FieldWaterItem({
    required this.date,
    required this.field,
    required this.action,
    required this.moistureBefore,
    required this.moistureAfter,
  });
}

class _FieldCard extends StatelessWidget {
  final _FieldWaterItem item;

  const _FieldCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xff020617),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.date,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  item.field,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              item.action,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Одоогийн чийг: ${item.moistureBefore}%",
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  "Зорилтот: ${item.moistureAfter}%",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${item.field} талбайн усалгааг эхлүүллээ."),
                    ),
                  );
                },
                child: const Text("Энэ талбайг услах"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
