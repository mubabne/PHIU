import 'package:flutter/material.dart';

class SoilCard extends StatelessWidget {
  final String fieldName;
  final String crop;
  final int moisture; 
  final int minMoisture;
  final int maxMoisture;

  const SoilCard({
    super.key,
    required this.fieldName,
    required this.crop,
    required this.moisture,
    required this.minMoisture,
    required this.maxMoisture,
  });

  @override
  Widget build(BuildContext context) {
    final withinRange = moisture >= minMoisture && moisture <= maxMoisture;
    final Color statusColor = withinRange ? Colors.greenAccent : Colors.orange;

    final double relative = ((moisture - 0) / 100).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff064e3b), Color(0xff022c22)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade700),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            crop,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '$moisture%',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    withinRange ? 'Тогтвортой чийг' : 'Анхаарах шаардлагатай',
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Зорилтот: $minMoisture–$maxMoisture%',
                    style: const TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: relative,
              minHeight: 10,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('0%', style: TextStyle(color: Colors.white38, fontSize: 10)),
              Text('50%', style: TextStyle(color: Colors.white38, fontSize: 10)),
              Text('100%', style: TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
