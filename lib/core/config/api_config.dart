import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get productApiUrl => dotenv.env['PRODUCTS_API_URL'] ?? '';
}
