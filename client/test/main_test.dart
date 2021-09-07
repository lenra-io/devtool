import 'package:client/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Main test', () {
    DevTools devtools = DevTools();

    expect(devtools is DevTools, true);
  });
}