import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../errors/driver_exception.dart';
import '../../data/drivers/connectivity_driver.dart';

/// [ConnectivityDriver] implementation based on 'connectivity_plus' and
/// 'internet_connection_checker_plus' packages.
///
/// For further information, see:
///
/// - [connectivity_plus](https://pub.dev/packages/connectivity_plus)
/// - [internet_connection_checker_plus](https://pub.dev/packages/internet_connection_checker_plus)
final class ConnectivityDriverImpl implements ConnectivityDriver {
  ConnectivityDriverImpl([
    Connectivity? connectivity,
    InternetConnection? internet,
  ])  : _connectivity = connectivity ?? Connectivity(),
        _internet = internet ?? InternetConnection();

  final Connectivity _connectivity;
  final InternetConnection _internet;

  @override
  Future<bool> get hasActiveInternetConnection async {
    try {
      final result = await _connectivity.onConnectivityChanged.first;
      return result != ConnectivityResult.none &&
          await _internet.hasInternetAccess;
    } on Exception catch (ex) {
      throw DriverException(
        'Error while checking connection status',
        exception: ex,
      );
    }
  }
}
