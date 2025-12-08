import 'package:flutter/material.dart';

class FieldTile extends StatelessWidget {
  final String name;
  final String crop;
  final int moisture;
  final VoidCallback? onTap;

  const FieldTile({
    super.key,
    required this.name,
    required this.crop,
    required this.moisture,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String status;

    if (moisture < 40) {
      statusColor = Colors.orangeAccent;
      status = 'Хуурай';
    } else if (moisture > 70) {
      statusColor = Colors.redAccent;
      status = 'Хэт нойтон';
    } else {
      statusColor = Colors.greenAccent;
      status = 'Тогтвортой';
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xff020617),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.grass, size: 22, color: Colors.greenAccent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    crop,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$moisture%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
