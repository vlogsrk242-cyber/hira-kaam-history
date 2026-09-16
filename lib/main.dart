import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppData.instance.load();
  runApp(const HiraKaamHistoryApp());
}

// ============================================================
// APP
// ============================================================

class HiraKaamHistoryApp extends StatelessWidget {
  const HiraKaamHistoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'હિરા કામ હિસ્ટરી',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: const Color(0xfff5f7fb),
      ),
      home: const LoginPage(),
    );
  }
}

// ============================================================
// MODELS
// ============================================================

class Worker {
  String id;
  String name;
  String mobile;
  String factory;

  Worker({
    required this.id,
    required this.name,
    required this.mobile,
    required this.factory,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mobile': mobile,
        'factory': factory,
      };

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      factory: json['factory']?.toString() ?? '',
    );
  }
}

class WorkRecord {
  String id;
  String section;
  String date;
  String workerId;
  double diamonds;
  double rate;

  WorkRecord({
    required this.id,
    required this.section,
    required this.date,
    required this.workerId,
    required this.diamonds,
    required this.rate,
  });

  double get total => diamonds * rate;

  Map<String, dynamic> toJson() => {
        'id': id,
        'section': section,
        'date': date,
        'workerId': workerId,
        'diamonds': diamonds,
        'rate': rate,
      };

  factory WorkRecord.fromJson(Map<String, dynamic> json) {
    return WorkRecord(
      id: json['id']?.toString() ?? '',
      section: json['section']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      workerId: json['workerId']?.toString() ?? '',
      diamonds: (json['diamonds'] as num?)?.toDouble() ?? 0,
      rate: (json['rate'] as num?)?.toDouble() ?? 0,
    );
  }
}

class WithdrawalRecord {
  String id;
  String section;
  String date;
  String workerId;
  double amount;

  WithdrawalRecord({
    required this.id,
    required this.section,
    required this.date,
    required this.workerId,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'section': section,
        'date': date,
        'workerId': workerId,
        'amount': amount,
      };

  factory WithdrawalRecord.fromJson(Map<String, dynamic> json) {
    return WithdrawalRecord(
      id: json['id']?.toString() ?? '',
      section: json['section']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      workerId: json['workerId']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
    );
  }
}

// ============================================================
// APP DATA
// ============================================================

class AppData {
  AppData._();

  static final AppData instance = AppData._();

  List<Worker> workers = [];
  List<WorkRecord> works = [];
  List<WithdrawalRecord> withdrawals = [];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final workersJson = prefs.getString('workers');
    final worksJson = prefs.getString('works');
    final withdrawalsJson = prefs.getString('withdrawals');

    if (workersJson != null && workersJson.isNotEmpty) {
      final list = jsonDecode(workersJson) as List;
      workers = list
          .map((e) => Worker.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList();
    }

    if (worksJson != null && worksJson.isNotEmpty) {
      final list = jsonDecode(worksJson) as List;
      works = list
          .map((e) => WorkRecord.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList();
    }

    if (withdrawalsJson != null && withdrawalsJson.isNotEmpty) {
      final list = jsonDecode(withdrawalsJson) as List;
      withdrawals = list
          .map((e) => WithdrawalRecord.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList();
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'workers',
      jsonEncode(
        workers.map((e) => e.toJson()).toList(),
      ),
    );

    await prefs.setString(
      'works',
      jsonEncode(
        works.map((e) => e.toJson()).toList(),
      ),
    );

    await prefs.setString(
      'withdrawals',
      jsonEncode(
        withdrawals.map((e) => e.toJson()).toList(),
      ),
    );
  }

  Worker? workerById(String id) {
    for (final worker in workers) {
      if (worker.id == id) {
        return worker;
      }
    }
    return null;
  }
}

// ============================================================
// LOGIN
// ============================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final mobileController = TextEditingController();

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.diamond,
                    size: 55,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'હિરા કામ હિસ્ટરી',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'શેઠ APK',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: 'મોબાઇલ નંબર',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: () {
                      final mobile = mobileController.text.trim();

                      if (!RegExp(r'^[0-9]{10}$').hasMatch(mobile)) {
                        showMessage(
                          context,
                          '10 અંકનો મોબાઇલ નંબર નાખો',
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OtpPage(
                            mobile: mobile,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.lock),
                    label: const Text(
                      'OTP Verification',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'નોંધ: હાલ OTP screen તૈયાર છે.\n'
                  'Real SMS OTP આગળ backend સાથે જોડાશે.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// OTP
// ============================================================

class OtpPage extends StatefulWidget {
  final String mobile;

  const OtpPage({
    super.key,
    required this.mobile,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 25),
          const Icon(
            Icons.verified_user,
            size: 75,
            color: Colors.blue,
          ),
          const SizedBox(height: 20),
          Text(
            'OTP મોકલવામાં આવ્યો',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            widget.mobile,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              labelText: '6 અંકનો OTP',
              prefixIcon: Icon(Icons.password),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 54,
            child: FilledButton(
              onPressed: () {
                if (otpController.text.length != 6) {
                  showMessage(
                    context,
                    '6 અંકનો OTP નાખો',
                  );
                  return;
                }

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DashboardPage(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Verify & Continue'),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DASHBOARD
// ============================================================

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0;

  final sections = const [
    'તળીયા',
    'પેલ',
    'મથાળા',
  ];

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> openWork() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const WorkFormPage(
          initialSection: 'તળીયા',
        ),
      ),
    );
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      SectionPage(
        section: 'તળીયા',
        refresh: refresh,
      ),
      SectionPage(
        section: 'પેલ',
        refresh: refresh,
      ),
      SectionPage(
        section: 'મથાળા',
        refresh: refresh,
      ),
      WorkerPage(
        refresh: refresh,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'હિરા કામ હિસ્ટરી',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'ટોટલ હીરા',
            icon: const Icon(Icons.diamond),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TotalDiamondsPage(),
                ),
              );
              refresh();
            },
          ),
          IconButton(
            tooltip: 'PDF',
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PdfPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: pages[selectedIndex],
      floatingActionButton: selectedIndex < 3
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkFormPage(
                      initialSection: sections[selectedIndex],
                    ),
                  ),
                );
                refresh();
              },
              icon: const Icon(Icons.add),
              label: const Text('કામ ઉમેરો'),
            )
          : FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WorkerFormPage(),
                  ),
                );
                refresh();
              },
              icon: const Icon(Icons.person_add),
              label: const Text('કારીગર ઉમેરો'),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.layers),
            label: 'તળીયા',
          ),
          NavigationDestination(
            icon: Icon(Icons.work),
            label: 'પેલ',
          ),
          NavigationDestination(
            icon: Icon(Icons.layers_outlined),
            label: 'મથાળા',
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'કારીગર',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SECTION PAGE
// ============================================================

class SectionPage extends StatelessWidget {
  final String section;
  final VoidCallback refresh;

  const SectionPage({
    super.key,
    required this.section,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    final data = AppData.instance;

    final works = data.works
        .where((e) => e.section == section)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final withdrawals = data.withdrawals
        .where((e) => e.section == section)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final totalDiamonds = works.fold<double>(
      0,
      (sum, e) => sum + e.diamonds,
    );

    final totalWork = works.fold<double>(
      0,
      (sum, e) => sum + e.total,
    );

    final totalWithdrawal = withdrawals.fold<double>(
      0,
      (sum, e) => sum + e.amount,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          section,
          style: const TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'હીરા',
                value: formatNumber(totalDiamonds),
                icon: Icons.diamond,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SummaryCard(
                title: 'ટોટલ કામ',
                value: money(totalWork),
                icon: Icons.currency_rupee,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SummaryCard(
                title: 'ઉપાડ',
                value: money(totalWithdrawal),
                icon: Icons.payments,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SectionHeader(
          title: 'કામની હિસ્ટરી',
          actionText: 'ઉપાડ',
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WithdrawalFormPage(
                  initialSection: section,
                ),
              ),
            );
            refresh();
          },
        ),
        const SizedBox(height: 8),
        if (works.isEmpty)
          const EmptyCard(
            text: 'આ વિભાગમાં હજુ કામ નથી',
          )
        else
          ...works.map(
            (record) => WorkCard(
              record: record,
              onChanged: refresh,
            ),
          ),
        const SizedBox(height: 20),
        const Text(
          'ઉપાડની હિસ્ટરી',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (withdrawals.isEmpty)
          const EmptyCard(
            text: 'આ વિભાગમાં હજુ ઉપાડ નથી',
          )
        else
          ...withdrawals.map(
            (record) => WithdrawalCard(
              record: record,
              onChanged: refresh,
            ),
          ),
      ],
    );
  }
}

// ============================================================
// SUMMARY CARD
// ============================================================

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 7,
          vertical: 14,
        ),
        child: Column(
          children: [
            Icon(icon, size: 25),
            const SizedBox(height: 7),
            Text(
              title,
              style: const TextStyle(fontSize: 11),
            ),
            const SizedBox(height: 4),
            FittedBox(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SECTION HEADER
// ============================================================

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onPressed;

  const SectionHeader({
    super.key,
    required this.title,
    required this.actionText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.payments),
          label: Text(actionText),
        ),
      ],
    );
  }
}

// ============================================================
// WORKER PAGE
// ============================================================

class WorkerPage extends StatelessWidget {
  final VoidCallback refresh;

  const WorkerPage({
    super.key,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    final workers = AppData.instance.workers;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'કારીગર',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (workers.isEmpty)
          const EmptyCard(
            text: 'હજુ કોઈ કારીગર ઉમેરાયેલ નથી',
          )
        else
          ...workers.map(
            (worker) => Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(
                  worker.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'મોબાઇલ: ${worker.mobile}\n'
                  'ફેક્ટરી: ${worker.factory}',
                ),
                isThreeLine: true,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkerHistoryPage(
                        worker: worker,
                      ),
                    ),
                  );
                  refresh();
                },
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WorkerFormPage(
                            worker: worker,
                          ),
                        ),
                      );
                      refresh();
                    }

                    if (value == 'delete') {
                      final confirmed =
                          await confirmDelete(context);

                      if (!confirmed) return;

                      AppData.instance.workers.removeWhere(
                        (e) => e.id == worker.id,
                      );

                      await AppData.instance.save();
                      refresh();
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ============================================================
// WORKER FORM
// ============================================================

class WorkerFormPage extends StatefulWidget {
  final Worker? worker;

  const WorkerFormPage({
    super.key,
    this.worker,
  });

  @override
  State<WorkerFormPage> createState() => _WorkerFormPageState();
}

class _WorkerFormPageState extends State<WorkerFormPage> {
  late final TextEditingController nameController;
  late final TextEditingController mobileController;
  late final TextEditingController factoryController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.worker?.name ?? '',
    );

    mobileController = TextEditingController(
      text: widget.worker?.mobile ?? '',
    );

    factoryController = TextEditingController(
      text: widget.worker?.factory ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    factoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.worker != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editing ? 'કારીગર Edit' : 'કારીગર ઉમેરો',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'કારીગરનું નામ',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: mobileController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: const InputDecoration(
              labelText: 'મોબાઇલ નંબર',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: factoryController,
            decoration: const InputDecoration(
              labelText: 'ફેક્ટરી નંબર',
              prefixIcon: Icon(Icons.factory),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 54,
            child: FilledButton.icon(
              onPressed: () async {
                final name = nameController.text.trim();
                final mobile = mobileController.text.trim();
                final factory = factoryController.text.trim();

                if (name.isEmpty) {
                  showMessage(
                    context,
                    'કારીગરનું નામ નાખો',
                  );
                  return;
                }

                if (!RegExp(r'^[0-9]{10}$')
                    .hasMatch(mobile)) {
                  showMessage(
                    context,
                    '10 અંકનો મોબાઇલ નંબર નાખો',
                  );
                  return;
                }

                if (factory.isEmpty) {
                  showMessage(
                    context,
                    'ફેક્ટરી નંબર નાખો',
                  );
                  return;
                }

                final id = widget.worker?.id ??
                    DateTime.now()
                        .microsecondsSinceEpoch
                        .toString();

                final worker = Worker(
                  id: id,
                  name: name,
                  mobile: mobile,
                  factory: factory,
                );

                if (editing) {
                  final index =
                      AppData.instance.workers.indexWhere(
                    (e) => e.id == widget.worker!.id,
                  );

                  if (index >= 0) {
                    AppData.instance.workers[index] =
                        worker;
                  }
                } else {
                  AppData.instance.workers.add(worker);
                }

                await AppData.instance.save();

                if (!context.mounted) return;

                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
              label: Text(
                editing ? 'Update' : 'Save',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WORK FORM
// ============================================================

class WorkFormPage extends StatefulWidget {
  final String initialSection;
  final WorkRecord? record;

  const WorkFormPage({
    super.key,
    required this.initialSection,
    this.record,
  });

  @override
  State<WorkFormPage> createState() => _WorkFormPageState();
}

class _WorkFormPageState extends State<WorkFormPage> {
  late String section;
  String? workerId;
  DateTime selectedDate = DateTime.now();

  late final TextEditingController diamondsController;
  late final TextEditingController rateController;

  @override
  void initState() {
    super.initState();

    section = widget.record?.section ?? widget.initialSection;
    workerId = widget.record?.workerId;

    diamondsController = TextEditingController(
      text: widget.record == null
          ? ''
          : formatNumber(widget.record!.diamonds),
    );

    rateController = TextEditingController(
      text: widget.record == null
          ? ''
          : formatNumber(widget.record!.rate),
    );

    if (widget.record != null) {
      final parts = widget.record!.date.split('/');

      if (parts.length == 3) {
        selectedDate = DateTime(
          int.tryParse(parts[2]) ?? DateTime.now().year,
          int.tryParse(parts[1]) ?? DateTime.now().month,
          int.tryParse(parts[0]) ?? DateTime.now().day,
        );
      }
    }

    diamondsController.addListener(_refresh);
    rateController.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    diamondsController.dispose();
    rateController.dispose();
    super.dispose();
  }

  double get diamonds =>
      double.tryParse(diamondsController.text) ?? 0;

  double get rate =>
      double.tryParse(rateController.text) ?? 0;

  double get total => diamonds * rate;

  @override
  Widget build(BuildContext context) {
    final workers = AppData.instance.workers;
    final editing = widget.record != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editing ? 'કામ Edit' : 'કામ ઉમેરો',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DropdownButtonFormField<String>(
            value: section,
            decoration: const InputDecoration(
              labelText: 'વિભાગ',
              prefixIcon: Icon(Icons.layers),
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'તળીયા',
                child: Text('તળીયા'),
              ),
              DropdownMenuItem(
                value: 'પેલ',
                child: Text('પેલ'),
              ),
              DropdownMenuItem(
                value: 'મથાળા',
                child: Text('મથાળા'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                section = value;
              });
            },
          ),
          const SizedBox(height: 16),
          DatePickerField(
            date: selectedDate,
            onChanged: (date) {
              setState(() {
                selectedDate = date;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: workers.any((e) => e.id == workerId)
                ? workerId
                : null,
            decoration: const InputDecoration(
              labelText: 'કારીગર',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            items: workers
                .map(
                  (worker) => DropdownMenuItem(
                    value: worker.id,
                    child: Text(worker.name),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                workerId = value;
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: diamondsController,
            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'હીરા',
              prefixIcon: Icon(Icons.diamond),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: rateController,
            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'ભાવ',
              prefixIcon: Icon(Icons.currency_rupee),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'ટોટલ કામ',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    money(total),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${formatNumber(diamonds)} × ${money(rate)}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 54,
            child: FilledButton.icon(
              onPressed: () async {
                if (workerId == null) {
                  showMessage(
                    context,
                    'કારીગર પસંદ કરો',
                  );
                  return;
                }

                if (diamonds <= 0) {
                  showMessage(
                    context,
                    'હીરા નાખો',
                  );
                  return;
                }

                if (rate < 0) {
                  showMessage(
                    context,
                    'ભાવ સાચો નાખો',
                  );
                  return;
                }

                final record = WorkRecord(
                  id: widget.record?.id ??
                      DateTime.now()
                          .microsecondsSinceEpoch
                          .toString(),
                  section: section,
                  date: dateToString(selectedDate),
                  workerId: workerId!,
                  diamonds: diamonds,
                  rate: rate,
                );

                if (editing) {
                  final index =
                      AppData.instance.works.indexWhere(
                    (e) => e.id == widget.record!.id,
                  );

                  if (index >= 0) {
                    AppData.instance.works[index] = record;
                  }
                } else {
                  AppData.instance.works.add(record);
                }

                await AppData.instance.save();

                if (!context.mounted) return;

                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
              label: Text(
                editing ? 'Update' : 'કામ Save કરો',
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WithdrawalFormPage(
                    initialSection: section,
                    workerId: workerId,
                  ),
                ),
              );

              if (mounted) {
                setState(() {});
              }
            },
            icon: const Icon(Icons.payments),
            label: const Text('ઉપાડ ઉમેરો'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WITHDRAWAL FORM
// ============================================================

class WithdrawalFormPage extends StatefulWidget {
  final String initialSection;
  final String? workerId;
  final WithdrawalRecord? record;

  const WithdrawalFormPage({
    super.key,
    required this.initialSection,
    this.workerId,
    this.record,
  });

  @override
  State<WithdrawalFormPage> createState() =>
      _WithdrawalFormPageState();
}

class _WithdrawalFormPageState
    extends State<WithdrawalFormPage> {
  late String section;
  String? workerId;
  DateTime selectedDate = DateTime.now();

  late final TextEditingController amountController;

  @override
  void initState() {
    super.initState();

    section = widget.record?.section ?? widget.initialSection;
    workerId = widget.record?.workerId ?? widget.workerId;

    amountController = TextEditingController(
      text: widget.record == null
          ? ''
          : formatNumber(widget.record!.amount),
    );

    if (widget.record != null) {
      final parts = widget.record!.date.split('/');

      if (parts.length == 3) {
        selectedDate = DateTime(
          int.tryParse(parts[2]) ?? DateTime.now().year,
          int.tryParse(parts[1]) ?? DateTime.now().month,
          int.tryParse(parts[0]) ?? DateTime.now().day,
        );
      }
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workers = AppData.instance.workers;
    final editing = widget.record != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editing ? 'ઉપાડ Edit' : 'ઉપાડ ઉમેરો',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DropdownButtonFormField<String>(
            value: section,
            decoration: const InputDecoration(
              labelText: 'વિભાગ',
              prefixIcon: Icon(Icons.layers),
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'તળીયા',
                child: Text('તળીયા'),
              ),
              DropdownMenuItem(
                value: 'પેલ',
                child: Text('પેલ'),
              ),
              DropdownMenuItem(
                value: 'મથાળા',
                child: Text('મથાળા'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                section = value;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: workers.any((e) => e.id == workerId)
                ? workerId
                : null,
            decoration: const InputDecoration(
              labelText: 'કારીગર',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            items: workers
                .map(
                  (worker) => DropdownMenuItem(
                    value: worker.id,
                    child: Text(worker.name),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                workerId = value;
              });
            },
          ),
          const SizedBox(height: 16),
          DatePickerField(
            date: selectedDate,
            onChanged: (date) {
              setState(() {
                selectedDate = date;
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: amountController,
            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'ઉપાડ',
              prefixIcon: Icon(Icons.currency_rupee),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 54,
            child: FilledButton.icon(
              onPressed: () async {
                if (workerId == null) {
                  showMessage(
                    context,
                    'કારીગર પસંદ કરો',
                  );
                  return;
                }

                final amount =
                    double.tryParse(
                          amountController.text.trim(),
                        ) ??
                        0;

                if (amount <= 0) {
                  showMessage(
                    context,
                    'ઉપાડની રકમ નાખો',
                  );
                  return;
                }

                final record = WithdrawalRecord(
                  id: widget.record?.id ??
                      DateTime.now()
                          .microsecondsSinceEpoch
                          .toString(),
                  section: section,
                  date: dateToString(selectedDate),
                  workerId: workerId!,
                  amount: amount,
                );

                if (editing) {
                  final index =
                      AppData.instance.withdrawals
                          .indexWhere(
                    (e) => e.id == widget.record!.id,
                  );

                  if (index >= 0) {
                    AppData.instance.withdrawals[index] =
                        record;
                  }
                } else {
                  AppData.instance.withdrawals.add(record);
                }

                await AppData.instance.save();

                if (!context.mounted) return;

                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
              label: Text(
                editing ? 'Update' : 'ઉપાડ Save કરો',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DATE FIELD
// ============================================================

class DatePickerField extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const DatePickerField({
    super.key,
    required this.date,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Colors.grey,
        ),
      ),
      leading: const Icon(Icons.calendar_month),
      title: const Text('તારીખ'),
      subtitle: Text(dateToString(date)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          initialDate: date,
        );

        if (picked != null) {
          onChanged(picked);
        }
      },
    );
  }
}

// ============================================================
// WORK CARD
// ============================================================

class WorkCard extends StatelessWidget {
  final WorkRecord record;
  final VoidCallback onChanged;

  const WorkCard({
    super.key,
    required this.record,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final worker =
        AppData.instance.workerById(record.workerId);

    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.diamond),
        ),
        title: Text(
          worker?.name ?? 'Unknown',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${record.date}\n'
          '${record.section} • '
          '${formatNumber(record.diamonds)} × '
          '${money(record.rate)}',
        ),
        isThreeLine: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              money(record.total),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              onSelected: (value) async {
                if (value == 'edit') {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkFormPage(
                        initialSection: record.section,
                        record: record,
                      ),
                    ),
                  );
                  onChanged();
                }

                if (value == 'delete') {
                  final confirmed =
                      await confirmDelete(context);

                  if (!confirmed) return;

                  AppData.instance.works.removeWhere(
                    (e) => e.id == record.id,
                  );

                  await AppData.instance.save();
                  onChanged();
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// WITHDRAWAL CARD
// ============================================================

class WithdrawalCard extends StatelessWidget {
  final WithdrawalRecord record;
  final VoidCallback onChanged;

  const WithdrawalCard({
    super.key,
    required this.record,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final worker =
        AppData.instance.workerById(record.workerId);

    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.payments),
        ),
        title: Text(
          worker?.name ?? 'Unknown',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${record.date}\n${record.section}',
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              money(record.amount),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WithdrawalFormPage(
                        initialSection: record.section,
                        record: record,
                      ),
                    ),
                  );
                  onChanged();
                }

                if (value == 'delete') {
                  final confirmed =
                      await confirmDelete(context);

                  if (!confirmed) return;

                  AppData.instance.withdrawals
                      .removeWhere(
                    (e) => e.id == record.id,
                  );

                  await AppData.instance.save();
                  onChanged();
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// WORKER HISTORY
// ============================================================

class WorkerHistoryPage extends StatelessWidget {
  final Worker worker;

  const WorkerHistoryPage({
    super.key,
    required this.worker,
  });

  @override
  Widget build(BuildContext context) {
    final works = AppData.instance.works
        .where((e) => e.workerId == worker.id)
        .toList();

    final withdrawals = AppData.instance.withdrawals
        .where((e) => e.workerId == worker.id)
        .toList();

    final totalDiamonds = works.fold<double>(
      0,
      (sum, e) => sum + e.diamonds,
    );

    final totalWork = works.fold<double>(
      0,
      (sum, e) => sum + e.total,
    );

    final totalWithdrawal = withdrawals.fold<double>(
      0,
      (sum, e) => sum + e.amount,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(worker.name),
        actions: [
          IconButton(
            tooltip: 'Worker PDF',
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              generateWorkerPdf(worker);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                radius: 27,
                child: Icon(Icons.person),
              ),
              title: Text(
                worker.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'મોબાઇલ: ${worker.mobile}\n'
                'ફેક્ટરી: ${worker.factory}',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'હીરા',
                  value: formatNumber(totalDiamonds),
                  icon: Icons.diamond,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SummaryCard(
                  title: 'ટોટલ કામ',
                  value: money(totalWork),
                  icon: Icons.currency_rupee,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SummaryCard(
                  title: 'ઉપાડ',
                  value: money(totalWithdrawal),
                  icon: Icons.payments,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'કામની હિસ્ટરી',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (works.isEmpty)
            const EmptyCard(
              text: 'કામની હિસ્ટરી નથી',
            )
          else
            ...works.map(
              (record) => Card(
                child: ListTile(
                  title: Text(record.date),
                  subtitle: Text(
                    '${record.section}\n'
                    '${formatNumber(record.diamonds)} × '
                    '${money(record.rate)}',
                  ),
                  isThreeLine: true,
                  trailing: Text(
                    money(record.total),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          const Text(
            'ઉપાડની હિસ્ટરી',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (withdrawals.isEmpty)
            const EmptyCard(
              text: 'ઉપાડની હિસ્ટરી નથી',
            )
          else
            ...withdrawals.map(
              (record) => Card(
                child: ListTile(
                  title: Text(record.date),
                  subtitle: Text(record.section),
                  trailing: Text(
                    money(record.amount),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// TOTAL DIAMONDS
// ============================================================

class TotalDiamondsPage extends StatelessWidget {
  const TotalDiamondsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = [
      'તળીયા',
      'પેલ',
      'મથાળા',
    ];

    final allDiamonds = AppData.instance.works.fold<double>(
      0,
      (sum, e) => sum + e.diamonds,
    );

    final allWork = AppData.instance.works.fold<double>(
      0,
      (sum, e) => sum + e.total,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('ટોટલ હીરા'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.diamond,
                    size: 45,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'કુલ હીરા',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    formatNumber(allDiamonds),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ટોટલ કામ: ${money(allWork)}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'વિભાગ પ્રમાણે',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...sections.map(
            (section) {
              final works = AppData.instance.works
                  .where((e) => e.section == section)
                  .toList();

              final diamonds = works.fold<double>(
                0,
                (sum, e) => sum + e.diamonds,
              );

              final total = works.fold<double>(
                0,
                (sum, e) => sum + e.total,
              );

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.diamond),
                  title: Text(
                    section,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'હીરા: ${formatNumber(diamonds)}\n'
                    'ટોટલ કામ: ${money(total)}',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'કારીગર પ્રમાણે',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...AppData.instance.workers.map(
            (worker) {
              final works = AppData.instance.works
                  .where((e) => e.workerId == worker.id)
                  .toList();

              final diamonds = works.fold<double>(
                0,
                (sum, e) => sum + e.diamonds,
              );

              final total = works.fold<double>(
                0,
                (sum, e) => sum + e.total,
              );

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(worker.name),
                  subtitle: Text(
                    'હીરા: ${formatNumber(diamonds)}\n'
                    'ટોટલ કામ: ${money(total)}',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PDF PAGE
// ============================================================

class PdfPage extends StatelessWidget {
  const PdfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.picture_as_pdf,
                size: 32,
              ),
              title: const Text(
                'Complete History PDF',
              ),
              subtitle: const Text(
                'કામ + ઉપાડની સંપૂર્ણ હિસ્ટરી',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                generateCompletePdf();
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.people,
                size: 32,
              ),
              title: const Text(
                'Worker-wise PDF',
              ),
              subtitle: const Text(
                'કારીગર પ્રમાણે PDF',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const WorkerPdfSelectPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WORKER PDF SELECT
// ============================================================

class WorkerPdfSelectPage extends StatelessWidget {
  const WorkerPdfSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final workers = AppData.instance.workers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('કારીગર પસંદ કરો'),
      ),
      body: workers.isEmpty
          ? const Center(
              child: Text(
                'પહેલા કારીગર ઉમેરો',
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: workers
                  .map(
                    (worker) => Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(worker.name),
                        subtitle: Text(
                          '${worker.mobile}\n'
                          'ફેક્ટરી: ${worker.factory}',
                        ),
                        isThreeLine: true,
                        trailing: const Icon(
                          Icons.picture_as_pdf,
                        ),
                        onTap: () {
                          generateWorkerPdf(worker);
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

// ============================================================
// PDF GENERATION
// ============================================================

Future<void> generateCompletePdf() async {
  final pdf = pw.Document();

  final works = AppData.instance.works;
  final withdrawals = AppData.instance.withdrawals;

  final totalDiamonds = works.fold<double>(
    0,
    (sum, e) => sum + e.diamonds,
  );

  final totalWork = works.fold<double>(
    0,
    (sum, e) => sum + e.total,
  );

  final totalWithdrawal = withdrawals.fold<double>(
    0,
    (sum, e) => sum + e.amount,
  );

  pdf.addPage(
    pw.MultiPage(
      build: (context) {
        return [
          pw.Header(
            level: 0,
            child: pw.Text(
              'HIRA KAAM HISTORY',
            ),
          ),
          pw.Text(
            'Total Diamonds: '
            '${formatNumber(totalDiamonds)}',
          ),
          pw.Text(
            'Total Work: ${money(totalWork)}',
          ),
          pw.Text(
            'Total Withdrawal: '
            '${money(totalWithdrawal)}',
          ),
          pw.SizedBox(height: 20),
          pw.Text('WORK HISTORY'),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: const [
              'Date',
              'Section',
              'Worker',
              'Diamonds',
              'Rate',
              'Total',
            ],
            data: works.map(
              (record) {
                final worker =
                    AppData.instance.workerById(
                  record.workerId,
                );

                return [
                  record.date,
                  record.section,
                  worker?.name ?? '',
                  formatNumber(record.diamonds),
                  money(record.rate),
                  money(record.total),
                ];
              },
            ).toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Text('WITHDRAWAL HISTORY'),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: const [
              'Date',
              'Section',
              'Worker',
              'Withdrawal',
            ],
            data: withdrawals.map(
              (record) {
                final worker =
                    AppData.instance.workerById(
                  record.workerId,
                );

                return [
                  record.date,
                  record.section,
                  worker?.name ?? '',
                  money(record.amount),
                ];
              },
            ).toList(),
          ),
        ];
      },
    ),
  );

  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename: 'hira_kaam_history.pdf',
  );
}

Future<void> generateWorkerPdf(
  Worker worker,
) async {
  final pdf = pw.Document();

  final works = AppData.instance.works
      .where((e) => e.workerId == worker.id)
      .toList();

  final withdrawals = AppData.instance.withdrawals
      .where((e) => e.workerId == worker.id)
      .toList();

  final totalDiamonds = works.fold<double>(
    0,
    (sum, e) => sum + e.diamonds,
  );

  final totalWork = works.fold<double>(
    0,
    (sum, e) => sum + e.total,
  );

  final totalWithdrawal = withdrawals.fold<double>(
    0,
    (sum, e) => sum + e.amount,
  );

  pdf.addPage(
    pw.MultiPage(
      build: (context) {
        return [
          pw.Header(
            level: 0,
            child: pw.Text(
              'WORKER HISTORY',
            ),
          ),
          pw.Text(
            'Worker: ${worker.name}',
          ),
          pw.Text(
            'Mobile: ${worker.mobile}',
          ),
          pw.Text(
            'Factory: ${worker.factory}',
          ),
          pw.SizedBox(height: 15),
          pw.Text(
            'Total Diamonds: '
            '${formatNumber(totalDiamonds)}',
          ),
          pw.Text(
            'Total Work: ${money(totalWork)}',
          ),
          pw.Text(
            'Total Withdrawal: '
            '${money(totalWithdrawal)}',
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: const [
              'Date',
              'Section',
              'Diamonds',
              'Rate',
              'Total Work',
            ],
            data: works.map(
              (record) => [
                record.date,
                record.section,
                formatNumber(record.diamonds),
                money(record.rate),
                money(record.total),
              ],
            ).toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Text('WITHDRAWAL'),
          pw.TableHelper.fromTextArray(
            headers: const [
              'Date',
              'Section',
              'Withdrawal',
            ],
            data: withdrawals.map(
              (record) => [
                record.date,
                record.section,
                money(record.amount),
              ],
            ).toList(),
          ),
        ];
      },
    ),
  );

  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename:
        'worker_${worker.name.replaceAll(' ', '_')}.pdf',
  );
}

// ============================================================
// HELPERS
// ============================================================

String money(double value) {
  return '₹${value.toStringAsFixed(2)}';
}

String formatNumber(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }

  return value.toStringAsFixed(2);
}

String dateToString(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}

void showMessage(
  BuildContext context,
  String message,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

Future<bool> confirmDelete(
  BuildContext context,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete?'),
        content: const Text(
          'શું તમે ખરેખર આ record delete કરવા માંગો છો?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );

  return result ?? false;
}

// ============================================================
// EMPTY CARD
// ============================================================

class EmptyCard extends StatelessWidget {
  final String text;

  const EmptyCard({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
