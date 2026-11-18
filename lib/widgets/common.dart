import 'package:flutter/material.dart';
class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.title, required this.subtitle,
    required this.children});
  final String title, subtitle;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => ListView(
    key: PageStorageKey(title), padding: const EdgeInsets.all(20),
    children: [Text(title, style: const TextStyle(fontSize: 26,
      fontWeight: FontWeight.bold)), const SizedBox(height: 6),
      Text(subtitle, style: const TextStyle(color: Colors.black54)),
      const SizedBox(height: 20), ...children, const SizedBox(height: 20)]);
}
class InfoCard extends StatelessWidget {
  const InfoCard(this.title, this.value, this.icon, {super.key});
  final String title, value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(child: Padding(
    padding: const EdgeInsets.all(16), child: Row(children: [
      Icon(icon, color: const Color(0xFF176B87)), const SizedBox(width: 12),
      Expanded(child: Text(title)), const SizedBox(width: 8),
      Flexible(child: Text(value, textAlign: TextAlign.end,
        style: const TextStyle(fontWeight: FontWeight.bold))),
    ])));
}
