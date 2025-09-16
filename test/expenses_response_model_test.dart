import 'package:flutter_test/flutter_test.dart';
import "package:mobile_app_pocketpartners/data/models/expenses/expenses_response_model.dart";

void main() {
  group('ExpensesResponseModel', () {
    test('fromJson debe parsear correctamente el JSON', () {
      final json = {
        'id': 1,
        'name': 'Alquiler oficina',
        'amount': 1500.75,
        'userId': 10,
        'groupId': 5,
        'dueDate': '2025-07-15',
        'createdAt': '2025-07-01T10:00:00Z',
        'updatedAt': '2025-07-08T18:30:00Z',
      };

      final model = ExpensesResponseModel.fromJson(json);

      expect(model.id, 1);
      expect(model.name, 'Alquiler oficina');
      expect(model.amount, 1500.75);
      expect(model.userId, 10);
      expect(model.groupId, 5);
      expect(model.dueDate, '2025-07-15');
      expect(model.createdAt, '2025-07-01T10:00:00Z');
      expect(model.updatedAt, '2025-07-08T18:30:00Z');
    });

    test('fromJson convierte amount a double si es int', () {
      final json = {
        'id': 2,
        'name': 'Internet',
        'amount': 200, // int
        'userId': 11,
        'groupId': 6,
        'dueDate': '2025-07-20',
        'createdAt': '2025-07-05T09:00:00Z',
        'updatedAt': '2025-07-09T12:00:00Z',
      };

      final model = ExpensesResponseModel.fromJson(json);

      expect(model.amount, 200.0); // Debe ser double
    });
  });
}
