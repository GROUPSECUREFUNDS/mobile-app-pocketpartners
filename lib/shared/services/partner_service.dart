// lib/shared/services/partner_service.dart
import 'dart:convert';
import '../../data/models/partner/partner_request_model.dart';
import '../../data/models/partner/partner_response_model.dart';
import '../../data/services/base_service.dart';

class PartnerService extends BaseService {
  PartnerService() : super(resourcePath: 'usersInformation');

  Future<PartnerResponseModel> getPartnerById(int userId) async {
    final response = await client.get(
      Uri.parse("${getFullUrl()}/userId/$userId"),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return PartnerResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error fetching partner: ${response.body}');
    }
  }

  Future<void> updatePartner(PartnerRequestModel data) async {
    final response = await client.put(
      Uri.parse(getFullUrl()),
      headers: await getHeaders(),
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error updating partner: ${response.body}');
    }
  }
}
