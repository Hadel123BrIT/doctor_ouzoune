import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxService {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final String _baseUrl = 'https://your-api.com/auth';

  // متغيرات تفاعلية لحالة المصادقة
  final RxBool isLoggedIn = false.obs;
  final RxString authToken = ''.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _dio.options.baseUrl = _baseUrl;
    _loadAuthData();
  }

  // تحميل بيانات المصادقة من التخزين المحلي
  void _loadAuthData() {
    authToken.value = _storage.read('auth_token') ?? '';
    isLoggedIn.value = authToken.isNotEmpty;
  }

  // تسجيل الدخول
  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        _saveAuthData(token);
        return true;
      }
      return false;
    } on DioException catch (e) {
      errorMessage.value = _handleError(e);
      return false;
    }
  }

  // تسجيل مستخدم جديد
  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post(
        '/register',
        data: userData,
      );

      if (response.statusCode == 201) {
        final token = response.data['token'];
        _saveAuthData(token);
        return true;
      }
      return false;
    } on DioException catch (e) {
      errorMessage.value = _handleError(e);
      return false;
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    await _storage.remove('auth_token');
    authToken.value = '';
    isLoggedIn.value = false;
    _dio.options.headers.remove('Authorization');
  }

  // حفظ بيانات المصادقة
  void _saveAuthData(String token) {
    _storage.write('auth_token', token);
    authToken.value = token;
    isLoggedIn.value = true;
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // معالجة الأخطاء
  String _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      return 'Invalid credentials';
    } else if (e.response?.statusCode == 400) {
      return e.response?.data['message'] ?? 'Bad request';
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout';
    } else {
      return 'An error occurred. Please try again.';
    }
  }

  // التحقق من المصادقة عند بدء التشغيل
  Future<void> checkAuth() async {
    if (authToken.isNotEmpty) {
      try {
        final response = await _dio.get('/verify-token');
        if (response.statusCode != 200) {
          await logout();
        }
      } catch (e) {
        await logout();
      }
    }
  }
}