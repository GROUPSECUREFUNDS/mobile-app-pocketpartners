import 'package:flutter_test/flutter_test.dart';
import "package:mobile_app_pocketpartners/data/models/auth/register_response_model.dart";

void main() {
  group('RegisterResponseModel', () {
    test('fromJson debe parsear correctamente el JSON con roles', () {
      final json = {
        'id': 10,
        'username': 'erick',
        'roles': ['admin', 'user']
      };

      final model = RegisterResponseModel.fromJson(json);

      expect(model.id, 10);
      expect(model.username, 'erick');
      expect(model.roles, isA<List<String>>());
      expect(model.roles.length, 2);
      expect(model.roles, contains('admin'));
      expect(model.roles, contains('user'));
    });

    test('fromJson debe manejar un JSON sin roles (lista vacía)', () {
      final json = {
        'id': 20,
        'username': 'ruiz',
      };

      final model = RegisterResponseModel.fromJson(json);

      expect(model.id, 20);
      expect(model.username, 'ruiz');
      expect(model.roles, isEmpty);
    });

    test('fromJson debe manejar un JSON con roles nulos (lista vacía)', () {
      final json = {
        'id': 30,
        'username': 'tester',
        'roles': null,
      };

      final model = RegisterResponseModel.fromJson(json);

      expect(model.id, 30);
      expect(model.username, 'tester');
      expect(model.roles, isEmpty);
    });
  });
}
