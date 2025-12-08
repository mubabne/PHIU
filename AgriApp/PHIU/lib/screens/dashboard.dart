import 'package:flutter/material.dart';
import '../widget/app_scaffold.dart';
import '../widget/soil_card.dart';
import '../widget/field_tile.dart';
import '../widget/section_title.dart';
import '../services/api_service.dart';
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
  final ApiService _api = ApiService();

  // State variables for API data
  bool _loading = true;
  bool _serverConnected = false;
  List<dynamic> _fields = [];
  Map<String, dynamic>? _weatherData;
  String _weatherDescription = "Уншиж байна...";
  int _fieldsNeedingWater = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _loading = true);

    try {
      // Check server connection
      final health = await _api.checkServerHealth();

      if (!health) {
        setState(() {
          _serverConnected = false;
          _loading = false;
          _weatherDescription = "Сервер холбогдоогүй";
        });
        return;
      }

      setState(() => _serverConnected = true);

      // Get weather data for Ulaanbaatar
      final recommendations = await _api.getRecommendations(
        location: 'Ulaanbaatar',
        crop: 'wheat',
        sensorData: {'soilMoisture': 45.0},
      );

      // Get all fields
      final fields = await _api.getAllFields();

      // Count fields needing water
      int needsWater = 0;
      for (var field in fields) {
        final rec = await _api.getRecommendations(
          location: field['location'] ?? 'Ulaanbaatar',
          crop: field['crop'] ?? 'wheat',
          fieldId: field['id'],
          sensorData: {'soilMoisture': 45.0},
        );
        if (rec['recommendations']['shouldWater'] == true) {
          needsWater++;
        }
      }

      setState(() {
        _weatherData = recommendations['weather'];
        _fields = fields;
        _fieldsNeedingWater = needsWater;
        _weatherDescription = _getWeatherMongolian(
          recommendations['weather']['current']['description'],
        );
        _loading = false;
      });
    } catch (e) {
      print('Error loading dashboard: $e');
      setState(() {
        _loading = false;
        _serverConnected = false;
        _weatherDescription = "Алдаа гарлаа";
      });
    }
  }

  String _getWeatherMongolian(String description) {
    final Map<String, String> translations = {
      'clear': 'Цэлмэг',
      'sunny': 'Нарлаг',
      'cloudy': 'Үүлэрхэг',
      'partly cloudy': 'Хагас үүлэрхэг',
      'rain': 'Бороотой',
      'light rain': 'Бага зэргийн бороо',
      'heavy rain': 'Их бороо',
      'snow': 'Цастай',
    };

    for (var key in translations.keys) {
      if (description.toLowerCase().contains(key)) {
        return translations[key]!;
      }
    }
    return 'Цэлмэг';
  }

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
          // Server status indicator
          if (_serverConnected)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(
                Icons.cloud_done,
                color: Colors.greenAccent,
                size: 20,
              ),
            )
          else if (!_loading)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.cloud_off, color: Colors.redAccent, size: 20),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
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
          BottomNavigationBarItem(icon: Icon(Icons.water), label: 'Усалгаа'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Тохиргоо',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.greenAccent),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      color: Colors.greenAccent,
      child: Padding(
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
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: Colors.white54,
                ),
                const SizedBox(width: 4),
                const Text(
                  "Төв аймаг, Борнуур сум",
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
                if (_weatherData != null) ...[
                  const SizedBox(width: 12),
                  const Icon(Icons.thermostat, size: 14, color: Colors.white54),
                  const SizedBox(width: 4),
                  Text(
                    "${_weatherData!['current']['temp']}°C",
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            if (!_serverConnected)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.warning_amber, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Сервертэй холбогдож чадсангүй. Статик өгөгдөл харуулж байна.",
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

            if (_fields.isNotEmpty && _serverConnected)
              SoilCard(
                fieldName:
                    _fields[0]['crop']?.toString().toUpperCase() ?? "Талбай A",
                crop: _fields[0]['crop'] ?? "Улаан буудай",
                moisture: 38,
                minMoisture: 40,
                maxMoisture: 60,
              )
            else
              const SoilCard(
                fieldName: "Талбай A",
                crop: "Улаан буудай",
                moisture: 38,
                minMoisture: 40,
                maxMoisture: 60,
              ),

            const SizedBox(height: 20),

            const SectionTitle(title: "Өнөөдрийн тойм"),
            Row(
              children: [
                _summaryChip(
                  icon: Icons.water_drop_outlined,
                  label: "Усалгааны\nзөвлөмж",
                  value: "$_fieldsNeedingWater талбай",
                ),
                const SizedBox(width: 10),
                _summaryChip(
                  icon: Icons.cloud_outlined,
                  label: "Цаг агаар\n(өнөөдөр)",
                  value: _weatherDescription,
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
                  label: "Талбайн\nтоо",
                  value: "${_fields.length}",
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

            if (_fields.isNotEmpty && _serverConnected)
              ..._fields.map(
                (field) => FieldTile(
                  name: field['crop']?.toString().toUpperCase() ?? "Талбай",
                  crop: field['crop'] ?? "Үл мэдэгдэх",
                  moisture: 45,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FieldDetailScreen(
                          fieldName:
                              field['crop']?.toString().toUpperCase() ??
                              "Талбай",
                          crop: field['crop'] ?? "Үл мэдэгдэх",
                          moisture: 45,
                          minMoisture: 40,
                          maxMoisture: 60,
                        ),
                      ),
                    );
                  },
                ),
              )
            else ...[
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
          ],
        ),
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
                color: Colors.greenAccent.withOpacity(0.2),
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
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
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
