import 'package:agriapp/services/api_service.dart';

class Authcontroller {
  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final bool success = await ApiService().register(
      username: username,
      email: email,
      password: password,
    );
    return success;
  }

  Future<bool> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final bool success = await ApiService().login(
      emailOrPhone: emailOrPhone,
      password: password,
    );
    return success;
  }
}
