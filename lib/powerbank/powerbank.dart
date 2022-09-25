/// Power bank object
class Powerbank {
  /// Charge of powerbank, from 0 to 1
  double _charge = 0;

  /// Charge of powerbank, measured in %, from 0% to 100%
  double get charge => _charge * 100;

  /// Charge of powerbank, measured in %, from 0% to 100%
  set charge(double charge) {
    if (charge > 100) charge = 100;
    _charge = charge / 100;
  }

  /// Current capacity of power bank, is measured in mAh
  int get capacity {
    return (totalCapacity * _charge).toInt();
  }

  /// Total capacity of powerbank, is measured in mAh
  int totalCapacity = 0;

  /// Is connected to app?
  /// Returns true if last packet from device was received less than 5 seconds ago
  bool isConnected = false;

  /// Last received data time, uses UNIX time
  int lastPacketTime = 0;
}
