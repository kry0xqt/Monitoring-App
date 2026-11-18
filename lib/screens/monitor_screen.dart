import 'package:flutter/material.dart';
import '../models/demo_state.dart';
import '../widgets/common.dart';
class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key, required this.model});
  final DemoState model;
  Widget meter(String name, String value, double fraction, String scale, Color color) =>
    Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name),
      const SizedBox(height: 8), Text(value, style: TextStyle(fontSize: 28,
        fontWeight: FontWeight.bold, color: color)), const SizedBox(height: 12),
      LinearProgressIndicator(value: fraction.clamp(0.0, 1.0).toDouble(),
        minHeight: 8, color: color), const SizedBox(height: 10), Text(scale),
    ])));
  @override
  Widget build(BuildContext context) => PageBody(title: 'Live Monitoring',
    subtitle: 'Demo preview. Values change through the Dashboard simulation.',
    children: [
      meter('Temperature', '${model.temperature} °C', model.temperature / 60,
        'Display scale: 0–60 °C', model.danger ? Colors.red : Colors.orange),
      meter('Humidity', '${model.humidity} % RH', model.humidity / 100,
        'Display scale: 0–100 % RH', Colors.blue),
      meter('Gas / Smoke', '${model.gas} raw ADC', model.gas / 4095,
        'Example 12-bit ADC scale: 0–4095; not calibrated ppm.',
        model.danger ? Colors.red : Colors.purple),
      const SizedBox(height: 16), Text('Latest sample: ${stamp(model.history.first.time)}'),
      OutlinedButton.icon(onPressed: () {
        model.record();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Demo sample saved to History')));
      }, icon: const Icon(Icons.add_chart), label: const Text('Record Current Demo Sample')),
    ]);
}
