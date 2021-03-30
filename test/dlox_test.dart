import 'package:dlox/dlox.dart';
import 'package:test/test.dart';

void main() {
  const input = 'Random test file\nwith multiple lines\n\n(and some random symbols, like :%/~\'º_)';

  test('', () {
    final output = run(input);
    expect(output, equals(input));
  });
}
