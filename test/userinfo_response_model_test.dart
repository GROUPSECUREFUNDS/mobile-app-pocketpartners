import 'package:flutter_test/flutter_test.dart';
import "package:mobile_app_pocketpartners/data/models/user_info/userinfo_response_model.dart";

void main() {
  group('UserinfoResponseModel', () {
    test('fromJson parsea correctamente cuando firstName y lastName están en JSON', () {
      final json = {
        'id': 1,
        'firstName': 'Erick',
        'lastName': 'Ruiz',
        'phoneNumber': '+51987654321',
        'photo': 'https://example.com/photo.jpg',
        'email': 'erick@example.com',
        'userId': 10,
      };

      final model = UserinfoResponseModel.fromJson(json);

      expect(model.id, 1);
      expect(model.firstName, 'Erick');
      expect(model.lastName, 'Ruiz');
      expect(model.phoneNumber, '+51987654321');
      expect(model.photo, 'https://example.com/photo.jpg');
      expect(model.email, 'erick@example.com');
      expect(model.userId, 10);
    });

    test('fromJson parsea correctamente usando fullName si no hay firstName y lastName', () {
      final json = {
        'id': 2,
        'fullName': 'Juan Perez Gonzales',
        'phoneNumber': '+51999999999',
        'photo': 'https://example.com/juan.jpg',
        'email': 'juan@example.com',
        'userId': 11,
      };

      final model = UserinfoResponseModel.fromJson(json);

      expect(model.id, 2);
      expect(model.firstName, 'Juan');
      expect(model.lastName, 'Perez Gonzales');
      expect(model.phoneNumber, '+51999999999');
      expect(model.photo, 'https://example.com/juan.jpg');
      expect(model.email, 'juan@example.com');
      expect(model.userId, 11);
    });

    test('fromJson parsea correctamente usando fullName con solo un nombre', () {
      final json = {
        'id': 3,
        'fullName': 'Luisa',
        'phoneNumber': '+51988888888',
        'photo': 'https://example.com/luisa.jpg',
        'email': 'luisa@example.com',
        'userId': 12,
      };

      final model = UserinfoResponseModel.fromJson(json);

      expect(model.id, 3);
      expect(model.firstName, 'Luisa');
      expect(model.lastName, ''); // no hay apellido
      expect(model.phoneNumber, '+51988888888');
      expect(model.photo, 'https://example.com/luisa.jpg');
      expect(model.email, 'luisa@example.com');
      expect(model.userId, 12);
    });

    test('fromJson retorna valores por defecto si campos faltan', () {
      final Map<String, dynamic> json = {};
      final model = UserinfoResponseModel.fromJson(json);


      expect(model.id, 0);
      expect(model.firstName, '');
      expect(model.lastName, '');
      expect(model.phoneNumber, '');
      expect(model.photo, '');
      expect(model.email, '');
      expect(model.userId, 0);
    });
  });
}
