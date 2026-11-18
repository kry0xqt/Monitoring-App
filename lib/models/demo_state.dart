import 'package:flutter/foundation.dart';
class Reading {
  Reading(this.temperature, this.humidity, this.gas, this.danger)
      : time = DateTime.now();
  final double temperature, humidity;
  final int gas;
  final bool danger;
  final DateTime time;
}
class SafetyAlert {
  SafetyAlert() : time = DateTime.now();
  final DateTime time;
  bool acknowledged = false;
  DateTime? resolvedAt;
}
// Shared session state. No physical hardware or database is connected.
class DemoState extends ChangeNotifier {
  DemoState() { _record(); }
  bool danger = false, fan = false, buzzer = false;
  double get temperature => danger ? 42.5 : 27.4;
  double get humidity => danger ? 72 : 61;
  int get gas => danger ? 2800 : 450;
  final List<Reading> history = [];
  final List<SafetyAlert> alerts = [];
  void _record() {
    history.insert(0, Reading(temperature, humidity, gas, danger));
  }
  void record() { _record(); notifyListeners(); }
  void toggleScenario() {
    danger = !danger;
    fan = danger;
    buzzer = danger;
    if (danger) {
      alerts.insert(0, SafetyAlert());
    } else {
      for (final alert in alerts) {
        alert.resolvedAt ??= DateTime.now();
      }
    }
    _record();
    notifyListeners();
  }
  void setFan(bool value) {
    if (danger) return;
    fan = value; notifyListeners();
  }
  void setBuzzer(bool value) {
    if (danger) return;
    buzzer = value; notifyListeners();
  }
  void acknowledge(SafetyAlert alert) {
    alert.acknowledged = true; notifyListeners();
  }
}
String stamp(DateTime t) {
  String pad(int n) => n.toString().padLeft(2, '0');
  return '${pad(t.day)}/${pad(t.month)}/${t.year} '
      '${pad(t.hour)}:${pad(t.minute)}:${pad(t.second)}';
}
