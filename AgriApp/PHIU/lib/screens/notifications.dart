import 'package:flutter/material.dart';
import '../widget/app_scaffold.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _NotificationItem(
        title: "Талбай A – усалгааны зөвлөгөө",
        time: "5 минутын өмнө",
        message:
            "Чийгийн түвшин 35% болсон тул энэ орой 18:00–19:00 цагийн хооронд услахыг зөвлөж байна.",
        isCritical: false,
      ),
      _NotificationItem(
        title: "Талбай C – хэт усалгааны анхааруулга",
        time: "Өчигдөр",
        message:
            "Чийгийн түвшин 80% хүрсэн тул түр хугацаанд усалгааг зогсооно уу.",
        isCritical: true,
      ),
      _NotificationItem(
        title: "Цаг агаарын сэрэмжлүүлэг",
        time: "2 хоногийн өмнө",
        message:
            "Дараагийн 24 цагийн турш хүчтэй бороо орох тул усалгааны төлөвлөгөөгөө дахин тооцоолно уу.",
        isCritical: false,
      ),
    ];

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff020617),
        title: const Text("Мэдэгдлүүд"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) =>
            _NotificationCard(item: notifications[index]),
      ),
    );
  }
}

class _NotificationItem {
  final String title;
  final String time;
  final String message;
  final bool isCritical;

  _NotificationItem({
    required this.title,
    required this.time,
    required this.message,
    this.isCritical = false,
  });
}

class _NotificationCard extends StatelessWidget {
  final _NotificationItem item;

  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final Color accent =
        item.isCritical ? Colors.redAccent : Colors.greenAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xff020617),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                item.isCritical ? Icons.error_outline : Icons.notifications,
                color: accent,
                size: 18,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            item.time,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(height: 8),
          Text(
            item.message,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
