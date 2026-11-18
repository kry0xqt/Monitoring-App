import 'package:flutter/material.dart';
import '../models/demo_state.dart';
import '../widgets/common.dart';
class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key, required this.model});
  final DemoState model;
  @override
  Widget build(BuildContext context) => PageBody(title: 'Device Control',
    subtitle: 'Switches control simulated device states only.', children: [
      if (model.danger) const Card(color: Color(0xFFFFE4E4), child: Padding(
        padding: EdgeInsets.all(16), child: Text('Safety override active. '
          'Reset the abnormal condition on Home to unlock manual controls.'))),
      Card(child: SwitchListTile(title: const Text('Exhaust Fan'),
        subtitle: Text(model.fan ? 'Demo state: ON' : 'Demo state: OFF'),
        secondary: const Icon(Icons.toys_outlined), value: model.fan,
        onChanged: model.danger ? null : model.setFan)),
      Card(child: SwitchListTile(title: const Text('Warning Buzzer'),
        subtitle: Text(model.buzzer ? 'Demo state: ON' : 'Demo state: OFF'),
        secondary: const Icon(Icons.notifications_active_outlined), value: model.buzzer,
        onChanged: model.danger ? null : model.setBuzzer)),
      const SizedBox(height: 16), const Text('Security/PIN and hardware commands '
        'are not implemented yet. The abnormal-state lock is demo safety logic, '
        'not authentication.', style: TextStyle(color: Colors.black54)),
    ]);
}
