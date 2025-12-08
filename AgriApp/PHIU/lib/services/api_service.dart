// lib/services/api_service.dart
// Save this file in your Flutter project

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // YOUR COMPUTER'S IP ADDRESS: 172.16.156.194
  // Use this for physical Android/iOS device
  static const String baseUrl = 'http://172.16.156.194:3000/api';

  // Alternative URLs (comment/uncomment as needed):
  // For Android Emulator: 'http://10.0.2.2:3000/api'
  // For iOS Simulator: 'http://localhost:3000/api'
  // For testing in browser: 'http://localhost:3000/api'

  static const Duration timeout = Duration(seconds: 10);

  // ============ FIELD MANAGEMENT ============

  /// Create a new field
  Future<Map<String, dynamic>> createField({
    required double size,
    required String location,
    required String crop,
    String? plantingDate,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/field/create'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'size': size,
              'location': location,
              'crop': crop,
              'plantingDate': plantingDate,
            }),
          )
          .timeout(timeout);

      print('Create Field Response: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create field: ${response.body}');
      }
    } catch (e) {
      print('Error creating field: $e');
      throw Exception('Network error: $e');
    }
  }

  /// Get all fields
  Future<List<dynamic>> getAllFields() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/field/all'))
          .timeout(timeout);

      print('Get All Fields Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['fields'] ?? [];
      } else {
        throw Exception('Failed to get fields');
      }
    } catch (e) {
      print('Error getting fields: $e');
      throw Exception('Network error: $e');
    }
  }

  /// Get field by ID
  Future<Map<String, dynamic>> getFieldById(String fieldId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/field/$fieldId'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Field not found');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ============ RECOMMENDATIONS ============

  /// Get AI-powered recommendations
  Future<Map<String, dynamic>> getRecommendations({
    required String location,
    required String crop,
    double? size,
    String? fieldId,
    Map<String, double>? sensorData,
  }) async {
    try {
      final body = {
        'location': location,
        'crop': crop,
        if (size != null) 'size': size,
        if (fieldId != null) 'fieldId': fieldId,
        if (sensorData != null) 'sensorData': sensorData,
      };

      print('Sending recommendation request: $body');

      final response = await http
          .post(
            Uri.parse('$baseUrl/advice/recommendations'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(timeout);

      print('Recommendations Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get recommendations: ${response.body}');
      }
    } catch (e) {
      print('Error getting recommendations: $e');
      throw Exception('Network error: $e');
    }
  }

  /// Get watering advice
  Future<Map<String, dynamic>> getWateringAdvice({
    required String location,
    required String crop,
    required double soilMoisture,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/advice/watering'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'location': location,
              'crop': crop,
              'soilMoisture': soilMoisture,
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get watering advice');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ============ SENSOR DATA ============

  /// Submit sensor reading
  Future<Map<String, dynamic>> submitSensorReading({
    required String fieldId,
    required double soilMoisture,
    double? soilTemp,
    double? airTemp,
    double? humidity,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/sensor/reading'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'fieldId': fieldId,
              'soilMoisture': soilMoisture,
              if (soilTemp != null) 'soilTemp': soilTemp,
              if (airTemp != null) 'airTemp': airTemp,
              if (humidity != null) 'humidity': humidity,
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to submit sensor reading');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Get sensor reading history
  Future<List<dynamic>> getSensorHistory({
    required String fieldId,
    int limit = 50,
  }) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/sensor/history/$fieldId?limit=$limit'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['readings'] ?? [];
      } else {
        throw Exception('Failed to get sensor history');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ============ HEALTH CHECK ============

  /// Check if server is reachable
  Future<bool> checkServerHealth() async {
    try {
      final response = await http
          .get(Uri.parse('${baseUrl.replaceAll('/api', '')}/health'))
          .timeout(Duration(seconds: 5));

      print('Server health check: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Server health check failed: $e');
      return false;
    }
  }
}
