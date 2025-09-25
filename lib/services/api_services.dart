import 'package:coinharbor/data/model/chart_model.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Candle>> fetchOHLC({
    required String coinId,
    String vsCurrency = "usd",
    int days = 1,
  }) async {
    final url =
        "https://api.coingecko.com/api/v3/coins/$coinId/ohlc?vs_currency=$vsCurrency&days=$days";

    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((e) => Candle.fromList(e as List<dynamic>)).toList();
    } else {
      throw Exception("Failed to fetch OHLC data");
    }
  }
}
