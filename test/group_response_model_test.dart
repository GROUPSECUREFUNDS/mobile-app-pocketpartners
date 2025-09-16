import 'package:flutter_test/flutter_test.dart';
import "package:mobile_app_pocketpartners/data/models/group/group_response_model.dart";

void main() {
  group('GroupResponseModel', () {
    test('fromJson debe parsear correctamente el JSON con createdAt como String', () {
      final json = {
        'id': 1,
        'name': 'Grupo de trabajo',
        'groupPhoto': 'https://example.com/photo.jpg',
        'description': 'Grupo para el proyecto',
        'adminId': 10,
        'createdAt': '2025-07-09T12:00:00Z',
      };

      final model = GroupResponseModel.fromJson(json);

      expect(model.id, 1);
      expect(model.name, 'Grupo de trabajo');
      expect(model.groupPhoto, 'https://example.com/photo.jpg');
      expect(model.description, 'Grupo para el proyecto');
      expect(model.adminId, 10);
      expect(model.createdAt, isA<DateTime>());
      expect(model.createdAt.toUtc().toIso8601String(), '2025-07-09T12:00:00.000Z');
    });

    test('fromJson debe parsear correctamente el JSON con createdAt como int (timestamp)', () {
      final timestamp = 1752014400000; // Corresponde a 2025-07-09T12:00:00Z
      final json = {
        'id': 2,
        'name': 'Grupo de estudio',
        'groupPhoto': 'https://example.com/group.jpg',
        'description': 'Grupo de mates',
        'adminId': 11,
        'createdAt': timestamp,
      };

      final model = GroupResponseModel.fromJson(json);

      expect(model.createdAt, isA<DateTime>());
      expect(model.createdAt.millisecondsSinceEpoch, timestamp);
    });

    test('fromJson lanza excepción si createdAt tiene formato no soportado', () {
      final json = {
        'id': 3,
        'name': 'Grupo inválido',
        'groupPhoto': 'https://example.com/invalid.jpg',
        'description': 'Grupo inválido',
        'adminId': 12,
        'createdAt': 12.34, // tipo no soportado
      };

      expect(() => GroupResponseModel.fromJson(json), throwsException);
    });
  });
}
