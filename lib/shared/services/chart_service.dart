// lib/shared/services/chart_service.dart
import 'dart:convert';

import '../../data/models/chart/chart_request_model.dart';
import '../../data/models/chart/chart_response_model.dart';
import '../../data/services/base_service.dart';


class ChartService extends BaseService {
  ChartService() : super(resourcePath: 'payments');

  Future<List<ChartResponseModel>> getAllChartData() async {
    final response = await client.get(
      Uri.parse(getFullUrl()),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => ChartResponseModel.fromJson(e)).toList();
    } else {
      throw Exception('Error fetching chart data: ${response.body}');
    }
  }

  Future<void> createChartEntry(ChartRequestModel data) async {
    final response = await client.post(
      Uri.parse(getFullUrl()),
      headers: await getHeaders(),
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error creating chart entry: ${response.body}');
    }
  }
}