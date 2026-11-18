import 'package:flutter/material.dart';
import '../models/demo_state.dart';
import '../widgets/common.dart';
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.model});
  final DemoState model;
  @override
  Widget build(BuildContext context) => PageBody(
    title: 'Laboratory Overview', subtitle: 'Environment and safety devices.',
    children: [
      Container(padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
          color: model.danger ? const Color(0xFFB42318) : const Color(0xFF15803D)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(model.danger ? Icons.warning_amber : Icons.verified_user_outlined,
            size: 40, color: Colors.white), const SizedBox(height: 14),
          Text(model.danger ? 'SIMULATED ALERT' : 'SIMULATED NORMAL',
            style: const TextStyle(color: Colors.white, fontSize: 22,
              fontWeight: FontWeight.bold)), const SizedBox(height: 8),
          Text(model.danger ? 'High temperature and gas input. Demo fan and alarm ON.'
            : 'Sample readings are within the demo range.',
            style: const TextStyle(color: Colors.white)),
        ])), const SizedBox(height: 16),
      InfoCard('Temperature', '${model.temperature} °C', Icons.thermostat),
      InfoCard('Humidity', '${model.humidity} % RH', Icons.water_drop_outlined),
      InfoCard('Gas / Smoke', '${model.gas} raw ADC', Icons.air),
      InfoCard('Demo fan', model.fan ? 'ON' : 'OFF', Icons.toys_outlined),
      InfoCard('Demo buzzer', model.buzzer ? 'ON' : 'OFF', Icons.notifications_active_outlined),
      const InfoCard('ESP32', 'Not connected', Icons.wifi_off),
      const SizedBox(height: 20),
      FilledButton.icon(onPressed: model.toggleScenario,
        icon: const Icon(Icons.science_outlined), label: Text(model.danger
          ? 'Reset to Normal' : 'Simulate Abnormal Condition')),
      const SizedBox(height: 10), const Text(
        'Simulation creates a history sample. Abnormal conditions create an alert. '
        'No physical devices are controlled.', style: TextStyle(color: Colors.black54)),
    ]);
}
