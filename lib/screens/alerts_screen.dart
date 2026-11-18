import 'package:flutter/material.dart';
import '../models/demo_state.dart';
import '../widgets/common.dart';
class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key, required this.model});
  final DemoState model;
  @override
  Widget build(BuildContext context) => PageBody(title: 'Safety Alerts',
    subtitle: 'Review and acknowledge simulated safety events.', children: [
      InfoCard('Active demo alerts',
        '${model.alerts.where((a) => a.resolvedAt == null).length}', Icons.warning_amber),
      if (model.alerts.isEmpty) const Card(child: Padding(padding: EdgeInsets.all(24),
        child: Text('No alerts recorded. Simulate an abnormal condition on Home.'))),
      ...model.alerts.map((a) => Card(child: Padding(padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(a.resolvedAt == null ? 'ACTIVE • Demo' : 'RESOLVED • Demo',
            style: TextStyle(fontWeight: FontWeight.bold,
              color: a.resolvedAt == null ? Colors.red : Colors.green)),
          const SizedBox(height: 8), const Text('High temperature and gas input simulated.'),
          Text('Detected: ${stamp(a.time)}'),
          if (a.resolvedAt != null) Text('Resolved: ${stamp(a.resolvedAt!)}'),
          const SizedBox(height: 8),
          if (a.acknowledged) const Text('Acknowledged ✓') else
            OutlinedButton(onPressed: () => model.acknowledge(a),
              child: const Text('Acknowledge')),
        ])))), const SizedBox(height: 12), const Text('Acknowledgement marks an '
        'alert as seen. It does not clear the condition or stop devices. '
        'Records reset when the app restarts.'),
    ]);
}
