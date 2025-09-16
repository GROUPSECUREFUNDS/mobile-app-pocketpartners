import 'package:flutter_test/flutter_test.dart';
import "package:mobile_app_pocketpartners/data/models/partner/partner_response_model.dart";

void main() {
  group('PartnerResponseModel', () {
    test('fromJson debe parsear correctamente el JSON', () {
      final json = {
        'id': 1,
        'fullName': 'Erick Ruiz',
        'email': 'erick@example.com',
        'phoneNumber': '+51987654321',
        'photo': 'https://example.com/photo.jpg',
      };

      final model = PartnerResponseModel.fromJson(json);

      expect(model.id, 1);
      expect(model.fullName, 'Erick Ruiz');
      expect(model.email, 'erick@example.com');
      expect(model.phoneNumber, '+51987654321');
      expect(model.photo, 'https://example.com/photo.jpg');
    });
  });
}
