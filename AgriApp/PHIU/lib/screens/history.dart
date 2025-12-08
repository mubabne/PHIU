import 'package:flutter/material.dart';
import '../widget/app_scaffold.dart';
import '../widget/section_title.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _HistoryItem(
        date: "2025-09-20",
        field: "Талбай A",
        action: "Усалгааны зөвлөгөө дагаж усалсан",
        moistureBefore: 35,
        moistureAfter: 48,
      ),
      _HistoryItem(
        date: "2025-09-18",
        field: "Талбай B",
        action: "Борооны улмаас усалгааг алгассан",
        moistureBefore: 60,
        moistureAfter: 64,
      ),
      _HistoryItem(
        date: "2025-09-15",
        field: "Талбай A",
        action: "Хэт усалгааны анхааруулга ирсэн",
        moistureBefore: 78,
        moistureAfter: 72,
      ),
    ];

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff020617),
        title: const Text("Түүхэн мэдээлэл"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SectionTitle(title: "Системийн өгөгдлийн түүх"),
            const SizedBox(height: 4),
            ...items.map((e) => _HistoryCard(item: e)),
          ],
        ),
      ),
    );
  }
}

class _HistoryItem {
  final String date;
  final String field;
  final String action;
  final int moistureBefore;
  final int moistureAfter;

  _HistoryItem({
    required this.date,
    required this.field,
    required this.action,
    required this.moistureBefore,
    required this.moistureAfter,
  });
}

class _HistoryCard extends StatelessWidget {
  final _HistoryItem item;

  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff020617),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.date,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            item.field,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.action,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            "Чийг: ${item.moistureBefore}% → ${item.moistureAfter}%",
            style: const TextStyle(color: Colors.greenAccent, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
