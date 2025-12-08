import 'package:flutter/material.dart';
import '../widget/app_scaffold.dart';
import '../widget/soil_card.dart';
import '../widget/section_title.dart';

class FieldDetailScreen extends StatelessWidget {
  final String fieldName;
  final String crop;
  final int moisture;
  final int minMoisture;
  final int maxMoisture;

  const FieldDetailScreen({
    super.key,
    required this.fieldName,
    required this.crop,
    required this.moisture,
    required this.minMoisture,
    required this.maxMoisture,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff020617),
        title: Text(fieldName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SoilCard(
              fieldName: fieldName,
              crop: crop,
              moisture: moisture,
              minMoisture: minMoisture,
              maxMoisture: maxMoisture,
            ),
            const SizedBox(height: 20),
            const SectionTitle(title: "Усалгааны зөвлөгөө"),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xff020617),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Өнөөдрийн зөвлөгөө",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "• Чийгийн түвшин зорилтот хэмжээнээс бага тул 18:00–19:00 цагийн хооронд услахыг зөвлөж байна.\n"
                    "• Хөрсний ус барих чадвараас хамаарч 25–30 мм усалгааны норм тохиромжтой.\n"
                    "• Маргааш бороо орох магадлалтай бол усалгааны хэмжээг 20%-иар бууруулж болно.",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionTitle(title: "Түүхэн график (прототип)"),
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xff020617),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: const Center(
                child: Text(
                  "Энд чийгийн\ngoingогдлын график байрлана",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
