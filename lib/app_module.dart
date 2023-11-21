// ignore: depend_on_referenced_packages
import 'package:flutter_modular/flutter_modular.dart';

import 'features/astronomy_picture_of_the_day/presentation/pages/detail/astronomy_picture_details_page.dart';
import 'features/astronomy_picture_of_the_day/presentation/pages/list/astronomy_picture_list_page.dart';

final class AppModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (context) => const AstronomyPictureListPage(),
    );
    r.child(
      '/details',
      child: (context) => const AstronomyPictureDetailsPage(),
    );
  }
}
