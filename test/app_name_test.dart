import 'package:flutter_test/flutter_test.dart';
import 'package:astronomy_picture_of_the_day/app_name.dart';

void main() {
  const name = 'Astronomy Picture Of The Day';
  test("The app name should be: '$name'.", () {
    expect(appName, name);
  });
}
