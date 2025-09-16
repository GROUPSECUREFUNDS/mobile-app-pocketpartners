import 'package:flutter_test/flutter_test.dart';
import "package:mobile_app_pocketpartners/data/models/auth/login_response_model.dart";

void main() {
  group('LoginResponseModel', () {
    test('fromJson debe parsear correctamente el JSON', () {
      final json = {
        'id': 1,
        'username': 'erick',
        'token': 'abc123'
      };

      final model = LoginResponseModel.fromJson(json);

      expect(model.id, 1);
      expect(model.username, 'erick');
      expect(model.token, 'abc123');
    });

    test('toJson debe retornar un mapa válido', () {
      final model = LoginResponseModel(
        id: 2,
        username: 'ruiz',
        token: 'xyz789',
      );

      final json = model.toJson();

      expect(json['id'], 2);
      expect(json['username'], 'ruiz');
      expect(json['token'], 'xyz789');
    });

    test('toString debe retornar un string representativo', () {
      final model = LoginResponseModel(
        id: 3,
        username: 'tester',
        token: 'token321',
      );

      expect(model.toString(),
          'LoginResponseModel(id: 3, username: tester, token: token321)');
    });
  });
}
