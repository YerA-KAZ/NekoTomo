import 'package:dio/dio.dart';
import 'package:nekotomo_app/core/constants/api_constants.dart';
import 'package:nekotomo_app/services/storage_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;
  final StorageService _storage = StorageService();

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add auth interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          _storage.clearToken();
        }
        handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;

  // ─── Auth ──────────────────────────────────
  Future<Response> register(String username, String email, String password) {
    return _dio.post(ApiConstants.register, data: {
      'username': username,
      'email': email,
      'password': password,
    });
  }

  Future<Response> login(String email, String password) {
    return _dio.post(ApiConstants.login, data: {
      'email': email,
      'password': password,
    });
  }

  Future<Response> getMe() {
    return _dio.get(ApiConstants.me);
  }

  // ─── Pet ───────────────────────────────────
  Future<Response> getPet() {
    return _dio.get(ApiConstants.pet);
  }

  Future<Response> feedPet({String itemName = 'Onigiri'}) {
    return _dio.post(ApiConstants.petFeed, data: {'itemName': itemName});
  }

  Future<Response> playWithPet() {
    return _dio.post(ApiConstants.petPlay);
  }

  // ─── Lessons ───────────────────────────────
  Future<Response> getLessons() {
    return _dio.get(ApiConstants.lessons);
  }

  Future<Response> getLessonDetail(int id) {
    return _dio.get('${ApiConstants.lessons}/$id');
  }

  Future<Response> completeLesson(int id) {
    return _dio.post('${ApiConstants.lessons}/$id/complete');
  }

  // ─── Exercises ─────────────────────────────
  Future<Response> getExercises(int lessonId) {
    return _dio.get('${ApiConstants.exercises}/$lessonId');
  }

  Future<Response> answerExercise(int id, String answer) {
    return _dio.post('${ApiConstants.exercises}/$id/answer', data: {
      'answer': answer,
    });
  }

  // ─── Progress ──────────────────────────────
  Future<Response> getProgress() {
    return _dio.get(ApiConstants.progress);
  }

  Future<Response> getInventory() {
    return _dio.get(ApiConstants.inventory);
  }
}
