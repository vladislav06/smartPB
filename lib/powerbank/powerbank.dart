import 'package:flutter/material.dart';

/// Power bank object
class Powerbank extends ChangeNotifier {
  /// Charge of powerbank, from 0 to 1
  double _charge = 0;

  /// Charge of powerbank, measured in %, from 0% to 100%
  double get charge => _charge * 100;

  /// Charge of powerbank, measured in %, from 0% to 100%
  set charge(double charge) {
    if (charge > 100) charge = 100;
    _charge = charge / 100;
    notifyListeners();
  }

  /// Lookup table for voltage vs charge
  final List<List<double>> _VtoC = [
    [3.00, 0.0],
    [3.45, 0.05],
    [3.68, 0.1],
    [3.74, 0.2],
    [3.79, 0.4],
    [3.77, 0.3],
    [3.82, 0.5],
    [3.87, 0.6],
    [3.92, 0.7],
    [3.98, 0.8],
    [4.06, 0.9],
    [4.2, 1],
  ];

  /// Voltage of powerbank cells from 0 to 4096
  set voltage(int vol) {
    if (vol > 4096) {
      vol = 4096;
    } else if (vol < 0) {
      vol = 0;
    }
    //map voltage to charge
    double charge = 0;
    //convert from some value to actual voltage
    double voltage = (vol * (3.3 / 4096)) * (1 / 0.701); //47k 20k

    //stop points
    if (voltage < _VtoC[0][0]) {
      charge = _VtoC[0][1];
    } else if (voltage > _VtoC[_VtoC.length - 1][0]) {
      charge = _VtoC[_VtoC.length - 1][1];
    } else {
      for (int i = 0; i < _VtoC.length - 1; i++) {
        //voltage already exist in table
        if (voltage == _VtoC[i][0]) {
          charge = _VtoC[i][1];
          //voltage is somewhere in between two values in table
        } else if (_VtoC[i][0] < voltage && voltage < _VtoC[i + 1][0]) {
          //linear interpolation between i and i+1 points
          double x1 = _VtoC[i][0];
          double x2 = _VtoC[i + 1][0];
          double y1 = _VtoC[i][1];
          double y2 = _VtoC[i + 1][1];
          double slope = (y2 - y1) / (x2 - x1);
          charge = y1 + slope * (voltage - x1);
        }
      }
    }

    _charge = charge;
    notifyListeners();
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
  int _lastUpdateTime = 0;

  /// Sets last received data time and notifies listeners, uses UNIX time
  set lastUpdateTime(int time) {
    _lastUpdateTime = time;
    notifyListeners();
  }

  /// Get last received data time, uses UNIX time
  int get lastUpdateTime => _lastUpdateTime;
}
