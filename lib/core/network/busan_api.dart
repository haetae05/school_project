import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class BusanApiClient {
  late final Dio _dio;
  
  BusanApiClient() {
    // Cache options for offline support
    final cacheOptions = CacheOptions(
      store: MemCacheStore(), // In a real app, use HiveCacheStore for persistence
      policy: CachePolicy.request,
      hitCacheOnErrorExcept: [401, 403],
      maxStale: const Duration(days: 7),
    );

    _dio = Dio(BaseOptions(
      baseUrl: 'http://apis.data.go.kr/6260000/AttractionService',
      connectTimeout: const Duration(seconds: 5),
    ));

    _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
  }

  Future<Map<String, dynamic>?> getAttractions() async {
    try {
      final response = await _dio.get('/getAttractionKr', queryParameters: {
        'serviceKey': 'DUMMY_API_KEY', // Fallback to dummy key
        'pageNo': 1,
        'numOfRows': 10,
        'resultType': 'json',
      });
      return response.data;
    } catch (e) {
      print('Failed to fetch attractions: \$e');
      return null;
    }
  }
}
