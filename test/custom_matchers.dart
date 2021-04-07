import 'package:flutter_test/flutter_test.dart';

const Matcher isToday = _IsToday();

class _IsToday extends Matcher {
  const _IsToday();

  @override
  Description describe(Description description) =>
      description.add(DateTime.now().toIso8601String().substring(0, 10));

  @override
  bool matches(item, Map matchState) {
    final now = DateTime.now();
    final it = item as DateTime;
    if (now.day != it.day) {
      return false;
    }
    if (now.month != it.month) {
      return false;
    }
    return now.year == it.year;
  }
}
