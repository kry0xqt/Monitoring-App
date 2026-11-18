import 'package:flutter/material.dart';
import '../models/demo_state.dart';
import '../widgets/common.dart';
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.model});
  final DemoState model;
  @override
  Widget build(BuildContext context) => PageBody(title: 'Sensor History',
    subtitle: '${model.history.length} demo samples • Newest first', children: [
      const Text('Session-only records. Restarting the app clears this data.'),
      const SizedBox(height: 16), Card(child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, child: DataTable(columns: const [
          DataColumn(label: Text('Date / Time')), DataColumn(label: Text('°C')),
          DataColumn(label: Text('% RH')), DataColumn(label: Text('Gas ADC')),
          DataColumn(label: Text('Status')),
        ], rows: model.history.map((r) => DataRow(cells: [
          DataCell(Text(stamp(r.time))), DataCell(Text('${r.temperature}')),
          DataCell(Text('${r.humidity}')), DataCell(Text('${r.gas}')),
          DataCell(Text(r.danger ? 'ALERT' : 'NORMAL', style: TextStyle(
            color: r.danger ? Colors.red : Colors.green, fontWeight: FontWeight.bold))),
        ])).toList()))), const SizedBox(height: 8),
      const Text('Swipe the table sideways to view all columns.'),
    ]);
}
