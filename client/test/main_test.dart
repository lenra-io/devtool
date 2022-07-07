import 'package:client/main.dart';
import 'package:flutter_test/flutter_test.dart';

@Skip('Useless test')

void main() {
  test('Main test', () {
    DevTools devtools = DevTools();

    // ignore: unnecessary_type_check
    expect(devtools is DevTools, true);
  });
}
