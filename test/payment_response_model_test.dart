import 'package:flutter_test/flutter_test.dart';
import "package:mobile_app_pocketpartners/data/models/payment/payment_response_model.dart";

void main() {
  group('PaymentResponseModel', () {
    test('fromJson debe parsear correctamente el JSON', () {
      final json = {
        'id': 1,
        'description': 'Pago mensual',
        'amount': 250.50,
        'status': 'completed',
        'userId': 10,
        'expenseId': 5,
      };

      final model = PaymentResponseModel.fromJson(json);

      expect(model.id, 1);
      expect(model.description, 'Pago mensual');
      expect(model.amount, 250.50);
      expect(model.status, 'completed');
      expect(model.userId, 10);
      expect(model.expenseId, 5);
    });

    test('fromJson convierte amount a double si es int', () {
      final json = {
        'id': 2,
        'description': 'Pago servicio',
        'amount': 100, // int
        'status': 'pending',
        'userId': 11,
        'expenseId': 6,
      };

      final model = PaymentResponseModel.fromJson(json);

      expect(model.amount, 100.0); // Debe convertirse a double
    });
  });
}
