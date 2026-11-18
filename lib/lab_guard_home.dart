import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

const databaseUrl =
    'https://labguard-20e71-default-rtdb.asia-southeast1.firebasedatabase.app';

Map<String, dynamic> fields(Object? value) {
  if (value is! Map) return {};
  return value.map((key, value) => MapEntry(key.toString(), value));
}

String number(Object? value, String unit, {int digits = 1}) {
  if (value is! num) return '—';
  return '${value.toStringAsFixed(digits)} $unit';
}

String relayState(Object? value) {
  if (value == true) return 'ON';
  if (value == false) return 'OFF';
  return '—';
}

String timeLabel(Object? value) {
  if (value is! num) return 'Masa belum tersedia';
  final date = DateTime.fromMillisecondsSinceEpoch(value.toInt()).toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(date.day)}/${two(date.month)}/${date.year} '
      '${two(date.hour)}:${two(date.minute)}:${two(date.second)}';
}

class LabGuardHome extends StatefulWidget {
  const LabGuardHome({super.key});

  @override
  State<LabGuardHome> createState() => _LabGuardHomeState();
}

class _LabGuardHomeState extends State<LabGuardHome> {
  late final DatabaseReference device;
  late final Stream<DatabaseEvent> telemetry;
  late final Stream<DatabaseEvent> history;
  late final Stream<DatabaseEvent> events;
  Timer? clock;

  int tab = 0;
  bool sending = false;

  @override
  void initState() {
    super.initState();

    final db = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: databaseUrl,
    );

    device = db.ref('devices/lab01');
    telemetry = device.child('telemetry').onValue;

    // Susun ikut masa kerana firmware menggunakan bootId + sequence sebagai key.
    history = device.child('history')
        .orderByChild('receivedAt')
        .limitToLast(50)
        .onValue;
    events = device.child('events')
        .orderByChild('receivedAt')
        .limitToLast(50)
        .onValue;

    // Kemas kini status walaupun ESP32 berhenti menghantar bacaan.
    clock = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    clock?.cancel();
    super.dispose();
  }

  bool recent(Map<String, dynamic> data) {
    final timestamp = data['receivedAt'];
    if (timestamp is! num) return false;
    final age = DateTime.now().millisecondsSinceEpoch - timestamp.toInt();
    return age >= -5000 && age <= 20000;
  }

  Future<void> sendCommand({
    required bool led,
    required bool buzzer,
    required String mode,
  }) async {
    if (sending) return;
    setState(() => sending = true);

    try {
      await device.child('command').set({
        'mode': mode,
        'led': led,
        'buzzer': buzzer,
        'issuedAt': ServerValue.timestamp,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Arahan dihantar. Semak status balasan ESP32.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Arahan gagal: $e')),
      );
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }

  Widget row(String label, String value) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget readings(Map<String, dynamic> d) {
    return Column(
      children: [
        row('Temperature', number(d['temperature'], '°C')),
        row('Humidity', number(d['humidity'], '% RH')),
        row('Gas / Smoke', number(d['gasRaw'], 'raw ADC', digits: 0)),
        row('Ultrasonic', number(d['distanceCm'], 'cm')),
      ],
    );
  }

  Widget liveTab(Map<String, dynamic> d) {
    final fresh = recent(d);
    final status = d['status']?.toString() ?? 'UNKNOWN';
    final alarm = status == 'ALARM' || status == 'SENSOR_FAULT';
    final led = d['led'] == true;
    final buzzer = d['buzzer'] == true;

    // Manual control ikut status terakhir yang dilaporkan oleh firmware.
    final canControl = fresh && status == 'NORMAL' && !sending;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          ['Laboratory Overview', 'Sensor Monitor', 'Relay Control'][tab],
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Card(
          color: !fresh
              ? Colors.grey.shade200
              : alarm
              ? Colors.red.shade100
              : status == 'NORMAL'
              ? Colors.green.shade100
              : Colors.amber.shade100,
          child: ListTile(
            leading: Icon(alarm ? Icons.warning_amber : Icons.sensors),
            title: Text(fresh ? status : 'Bacaan terakhir · $status'),
            subtitle: Text(
              '${fresh ? "Data terkini" : "Tiada kemas kini terkini"}'
                  ' · ${timeLabel(d['receivedAt'])}',
            ),
          ),
        ),
        if (tab == 0 || tab == 1) readings(d),
        if (tab == 0 || tab == 2) ...[
          row('LED relay', relayState(d['led'])),
          row('Buzzer relay', relayState(d['buzzer'])),
        ],
        if (tab == 1) ...[
          row('DHT22', d['dhtOK'] == true ? 'OK' : 'Semak sensor'),
          row('HC-SR04', d['ultrasonicOK'] == true ? 'OK' : 'Semak sensor'),
          row('MQ135 gas alarm', relayState(d['gasAlarm'])),
        ],
        if (tab == 2) ...[
          const SizedBox(height: 12),
          Text(
            canControl
                ? 'Arahan manual sah selama 30 saat. Status relay di atas datang daripada ESP32.'
                : 'Kawalan manual tersedia apabila bacaan terkini dan status NORMAL.',
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: canControl
                ? () => sendCommand(led: !led, buzzer: buzzer, mode: 'manual')
                : null,
            child: Text(led ? 'Matikan LED' : 'Hidupkan LED'),
          ),
          FilledButton.tonal(
            onPressed: canControl
                ? () => sendCommand(led: led, buzzer: !buzzer, mode: 'manual')
                : null,
            child: Text(buzzer ? 'Matikan buzzer' : 'Hidupkan buzzer'),
          ),
          OutlinedButton(
            onPressed: fresh && !sending
                ? () => sendCommand(led: false, buzzer: false, mode: 'auto')
                : null,
            child: const Text('Kembali ke Auto'),
          ),
        ],
      ],
    );
  }

  Widget recordsTab({required bool alerts}) {
    return StreamBuilder<DatabaseEvent>(
      key: ValueKey(alerts),
      stream: alerts ? events : history,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Gagal baca rekod: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final records = snapshot.data!.snapshot.children
            .map((child) => fields(child.value))
            .where((d) => d.isNotEmpty)
            .toList()
            .reversed
            .toList();

        if (records.isEmpty) {
          return Center(
            child: Text(alerts ? 'Belum ada perubahan status.' : 'Belum ada rekod.'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: records.length,
          itemBuilder: (context, i) {
            final d = records[i];
            final status = d['status']?.toString() ?? 'UNKNOWN';
            final abnormal = status == 'ALARM' || status == 'SENSOR_FAULT';
            final reasons = <String>[
              if (d['gasAlarm'] == true) 'Gas',
              if (d['temperatureAlarm'] == true) 'Suhu',
              if (d['humidityAlarm'] == true) 'Kelembapan',
              if (d['proximityAlarm'] == true) 'Objek dekat',
              if (d['dhtOK'] == false) 'DHT22',
              if (d['ultrasonicOK'] == false) 'Ultrasonik',
            ];

            return Card(
              child: ListTile(
                leading: Icon(abnormal ? Icons.warning_amber : Icons.history),
                title: Text('$status · ${timeLabel(d['sampledAt'] ?? d['receivedAt'])}'),
                subtitle: Text(
                  alerts
                      ? (reasons.isEmpty ? 'Status sistem: $status' : reasons.join(' · '))
                      : '${number(d['temperature'], '°C')} · '
                      '${number(d['humidity'], '% RH')} · '
                      '${number(d['gasRaw'], 'ADC', digits: 0)} · '
                      '${number(d['distanceCm'], 'cm')}',
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LabGuard'),
        actions: [
          IconButton(
            tooltip: 'Log keluar',
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: tab >= 3
            ? recordsTab(alerts: tab == 4)
            : StreamBuilder<DatabaseEvent>(
          stream: telemetry,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Gagal baca telemetry: ${snapshot.error}'),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = fields(snapshot.data!.snapshot.value);
            if (data.isEmpty) {
              return const Center(
                child: Text('Belum ada data di /devices/lab01/telemetry'),
              );
            }
            return liveTab(data);
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.sensors), label: 'Monitor'),
          NavigationDestination(icon: Icon(Icons.tune), label: 'Control'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.notifications_outlined), label: 'Alerts'),
        ],
      ),
    );
  }
}