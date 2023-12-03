/// Driver for checking the availability of a connection to a data network and
/// the connection status.
abstract interface class ConnectivityDriver {
  /// Returns `true` if an active data connection is actually available — the
  /// device is not only connected but can also send/receive data over the
  /// network. Otherwise, it returns `false`.
  ///
  /// For example, it will return `true` if the device is both connected to a
  /// network (Wi-Fi, 3g, 4g, bluetooth, ethernet, etc) and can send/receive
  /// data.
  ///
  /// Throws [DriverException] to indicate an operation error.
  Future<bool> get hasActiveInternetConnection;
}
