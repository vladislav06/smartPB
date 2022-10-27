import 'package:flutter_test/flutter_test.dart';
import 'package:smart_pb/powerbank/powerbank.dart';

void main() {
  test('test voltage to charge conversion', () {
    Powerbank powerbank = Powerbank();
    for (int i = 0; i < 4096; i++) {
      powerbank.voltage = i;
      print('$i;${powerbank.charge}');
    }
  });
}
