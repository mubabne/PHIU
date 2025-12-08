import 'package:flutter/material.dart';
import '../widget/app_scaffold.dart';
import '../widget/soil_card.dart';
import '../widget/field_tile.dart';
import '../widget/section_title.dart';
import 'fields.dart';
import 'history.dart';
import 'notifications.dart';
import 'settings.dart';
import 'field_detail.dart';
import 'watering_system.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _bottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Widget page;
    switch (_bottomIndex) {
      case 0:
        page = _buildDashboardContent(context);
        break;
      case 1:
        page = const FieldsScreen();
        break;
      case 2:
        page = const HistoryScreen();
        break;
      case 4:
        page = const SettingsScreen();
        break;
      case 3:
        page = const WateringSystem();
        break;
      default:
        page = _buildDashboardContent(context);
    }

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff020617),
        title: const Text("Хяналтын самбар"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomIndex,
        backgroundColor: const Color(0xff020617),
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _bottomIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Самбар',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grass_outlined),
            label: 'Талбай',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline_outlined),
            label: 'Түүх',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.water),
            label: 'Усалгаа',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Тохиргоо',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text(
            "Сайн уу, Admin ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: const [
              Icon(Icons.location_on_outlined,
                  size: 14, color: Colors.white54),
              SizedBox(width: 4),
              Text(
                "Төв аймаг, Борнуур сум",
                style: TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 16),

          const SoilCard(
            fieldName: "Талбай A",
            crop: "Улаан буудай",
            moisture: 38,
            minMoisture: 40,
            maxMoisture: 60,
          ),

          const SizedBox(height: 20),

          const SectionTitle(
            title: "Өнөөдрийн тойм",
          ),
          Row(
            children: [
              _summaryChip(
                icon: Icons.water_drop_outlined,
                label: "Усалгааны\nзөвлөмж",
                value: "2 талбай",
              ),
              const SizedBox(width: 10),
              _summaryChip(
                icon: Icons.cloud_outlined,
                label: "Цаг агаар\n(өнөөдөр)",
                value: "Бороотой",
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _summaryChip(
                icon: Icons.energy_savings_leaf_outlined,
                label: "Усны\nхэмнэлт",
                value: "≈ 24%",
              ),
              const SizedBox(width: 10),
              _summaryChip(
                icon: Icons.timeline_outlined,
                label: "Түүхэн\nөгөгдөл",
                value: "30 хоног",
              ),
            ],
          ),

          const SizedBox(height: 24),

          SectionTitle(
            title: "Талбайн жагсаалт",
            actionText: "Бүгдийг харах",
            onActionTap: () {
              setState(() => _bottomIndex = 1);
            },
          ),

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
            crop: "Төмс (туршилт)",
            moisture: 75,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FieldDetailScreen(
                    fieldName: "Талбай C",
                    crop: "Төмс (туршилт)",
                    moisture: 75,
                    minMoisture: 45,
                    maxMoisture: 65,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _summaryChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xff020617),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(icon, color: Colors.greenAccent, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
