import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(const HiraKaamHistoryApp());
}

// ================= APP =================

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
      home: const SignUpPage(),
    );
  }
}

// ================= MODELS =================

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
      id: json['id'],
      name: json['name'],
      mobile: json['mobile'],
      factory: json['factory'],
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
      id: json['id'],
      section: json['section'],
      date: json['date'],
      workerId: json['workerId'],
      diamonds: (json['diamonds'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
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
      id: json['id'],
      section: json['section'],
      date: json['date'],
      workerId: json['workerId'],
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

// ================= DATA =================

class AppData {
  AppData._();

  static final AppData instance = AppData._();

  List<Worker> workers = [];
  List<WorkRecord> works = [];
  List<WithdrawalRecord> withdrawals = [];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final workersData = prefs.getString('workers');
    final worksData = prefs.getString('works');
    final withdrawalsData = prefs.getString('withdrawals');

    if (workersData != null) {
      workers = (jsonDecode(workersData) as List)
          .map((e) => Worker.fromJson(e))
          .toList();
    }

    if (worksData != null) {
      works = (jsonDecode(worksData) as List)
          .map((e) => WorkRecord.fromJson(e))
          .toList();
    }

    if (withdrawalsData != null) {
      withdrawals = (jsonDecode(withdrawalsData) as List)
          .map((e) => WithdrawalRecord.fromJson(e))
          .toList();
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'workers',
      jsonEncode(workers.map((e) => e.toJson()).toList()),
    );

    await prefs.setString(
      'works',
      jsonEncode(works.map((e) => e.toJson()).toList()),
    );

    await prefs.setString(
      'withdrawals',
      jsonEncode(withdrawals.map((e) => e.toJson()).toList()),
    );
  }

  Worker? getWorker(String id) {
    try {
      return workers.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }
}

// ================= SIGN UP =================

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(
                  Icons.diamond,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 20),
                const Text(
                  'હિરા કામ હિસ્ટરી',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('શેઠ એપ'),
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
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      if (mobileController.text.length != 10) {
                        showMessage(context, '10 અંકનો મોબાઇલ નંબર નાખો');
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OtpPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'OTP Verification',
                      style: TextStyle(fontSize: 17),
                    ),
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

// ================= OTP =================

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.verified_user, size: 70),
            const SizedBox(height: 20),
            const Text(
              'તમારો 6 અંકનો OTP નાખો',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () async {
                  if (otpController.text.length != 6) {
                    showMessage(context, '6 અંકનો OTP નાખો');
                    return;
                  }

                  await AppData.instance.load();

                  if (!context.mounted) return;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainDashboard(),
                    ),
                  );
                },
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= DASHBOARD =================

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int index = 0;

  final sections = const [
    'તળીયા',
    'પેલ',
    'મથાળા',
  ];

  @override
  Widget build(BuildContext context) {
    final pages = sections
        .map(
          (section) => SectionPage(
            section: section,
            refresh: () => setState(() {}),
          ),
        )
        .toList();

    pages.add(
      WorkerPage(
        refresh: () => setState(() {}),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'હિરા કામ હિસ્ટરી',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.diamond),
            tooltip: 'ટોટલ હીરા',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TotalDiamondsPage(),
                ),
              );
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'PDF',
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
      body: pages[index],
      floatingActionButton: index < 3
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkPage(
                      section: sections[index],
                    ),
                  ),
                );
                setState(() {});
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
                setState(() {});
              },
              icon: const Icon(Icons.person_add),
              label: const Text('કારીગર ઉમેરો'),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          setState(() {
            index = value;
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

// ================= SECTION =================

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

    final works =
        data.works.where((e) => e.section == section).toList();

    final withdrawals =
        data.withdrawals.where((e) => e.section == section).toList();

    final totalDiamonds =
        works.fold<double>(0, (sum, e) => sum + e.diamonds);

    final totalWork =
        works.fold<double>(0, (sum, e) => sum + e.total);

    final totalWithdrawal =
        withdrawals.fold<double>(0, (sum, e) => sum + e.amount);

    return RefreshIndicator(
      onRefresh: () async => refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            section,
            style: const TextStyle(
              fontSize: 26,
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
              const SizedBox(width: 10),
              Expanded(
                child: SummaryCard(
                  title: 'ટોટલ કામ',
                  value: money(totalWork),
                  icon: Icons.currency_rupee,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SummaryCard(
                  title: 'ઉપાડ',
                  value: money(totalWithdrawal),
                  icon: Icons.payments,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'કામની હિસ્ટરી',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (works.isEmpty)
            const EmptyCard(text: 'હજુ કોઈ કામ ઉમેરાયેલ નથી')
          else
            ...works.reversed.map(
              (record) => WorkCard(
                record: record,
                onChanged: refresh,
              ),
            ),
          const SizedBox(height: 20),
          const Text(
            'ઉપાડની હિસ્ટરી',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (withdrawals.isEmpty)
            const EmptyCard(text: 'હજુ કોઈ ઉપાડ નથી')
          else
            ...withdrawals.reversed.map(
              (record) => WithdrawalCard(
                record: record,
                onChanged: refresh,
              ),
            ),
        ],
      ),
    );
  }
}

// ================= SUMMARY CARD =================

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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= WORKER PAGE =================

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
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (workers.isEmpty)
          const EmptyCard(text: 'હજુ કોઈ કારીગર ઉમેરાયેલ નથી')
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
                  '${worker.mobile}\nફેક્ટરી: ${worker.factory}',
                ),
                isThreeLine: true,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          WorkerHistoryPage(worker: worker),
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
                          builder: (_) =>
                              WorkerFormPage(worker: worker),
                        ),
                      );
                      refresh();
                    }

                    if (value == 'delete') {
                      AppData.instance.workers
                          .removeWhere((e) => e.id == worker.id);

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

// ================= WORKER FORM =================

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
  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController factoryController;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.worker?.name ?? '');
    mobileController =
        TextEditingController(text: widget.worker?.mobile ?? '');
    factoryController =
        TextEditingController(text: widget.worker?.factory ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.worker == null
              ? 'કારીગર ઉમેરો'
              : 'કારીગર Edit',
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
          const SizedBox(height: 25),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  showMessage(context, 'કારીગરનું નામ નાખો');
                  return;
                }

                final id =
                    widget.worker?.id ??
                    DateTime.now()
                        .millisecondsSinceEpoch
                        .toString();

                final worker = Worker(
                  id: id,
                  name: nameController.text.trim(),
                  mobile: mobileController.text.trim(),
                  factory: factoryController.text.trim(),
                );

                if (widget.worker == null) {
                  AppData.instance.workers.add(worker);
                } else {
                  final index = AppData.instance.workers
                      .indexWhere((e) => e.id == widget.worker!.id);

                  if (index != -1) {
                    AppData.instance.workers[index] = worker;
                  }
                }

                await AppData.instance.save();

                if (!context.mounted) return;

                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= WORK PAGE =================

class WorkPage extends StatefulWidget {
  final String section;

  const WorkPage({
    super.key,
    required this.section,
  });

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  late String section;
  String? workerId;
  DateTime selectedDate = DateTime.now();

  final diamondsController = TextEditingController();
  final rateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    section = widget.section;

    diamondsController.addListener(() {
      setState(() {});
    });

    rateController.addListener(() {
      setState(() {});
    });
  }

  double get diamonds =>
      double.tryParse(diamondsController.text) ?? 0;

  double get rate =>
      double.tryParse(rateController.text) ?? 0;

  double get total => diamonds * rate;

  @override
  Widget build(BuildContext context) {
    final workers = AppData.instance.workers;

    return Scaffold(
      appBar: AppBar(title: const Text('કામ ઉમેરો')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DropdownButtonFormField<String>(
            value: section,
            decoration: const InputDecoration(
              labelText: 'વિભાગ',
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
              if (value != null) {
                setState(() {
                  section = value;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.grey),
            ),
            leading: const Icon(Icons.calendar_month),
            title: const Text('તારીખ'),
            subtitle: Text(
              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
            ),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                initialDate: selectedDate,
              );

              if (date != null) {
                setState(() {
                  selectedDate = date;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: workerId,
            decoration: const InputDecoration(
              labelText: 'કારીગર',
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
                const TextInputType.numberWithOptions(decimal: true),
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
                const TextInputType.numberWithOptions(decimal: true),
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
                    style: TextStyle(fontSize: 17),
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
          const SizedBox(height: 25),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: () async {
                if (workerId == null) {
                  showMessage(context, 'કારીગર પસંદ કરો');
                  return;
                }

                if (diamonds <= 0) {
                  showMessage(context, 'હીરા નાખો');
                  return;
                }

                final record = WorkRecord(
                  id: DateTime.now()
                      .millisecondsSinceEpoch
                      .toString(),
                  section: section,
                  date:
                      '${selectedDate.day.toString().padLeft(2, '0')}/'
                      '${selectedDate.month.toString().padLeft(2, '0')}/'
                      '${selectedDate.year}',
                  workerId: workerId!,
                  diamonds: diamonds,
                  rate: rate,
                );

                AppData.instance.works.add(record);

                await AppData.instance.save();

                if (!context.mounted) return;

                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
              label: const Text('કામ Save કરો'),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WithdrawalPage(
                    section: section,
                  ),
                ),
              );
              if (context.mounted) {
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

// ================= WITHDRAWAL =================

class WithdrawalPage extends StatefulWidget {
  final String section;

  const WithdrawalPage({
    super.key,
    required this.section,
  });

  @override
  State<WithdrawalPage> createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  String? workerId;
  DateTime date = DateTime.now();

  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final workers = AppData.instance.workers;

    return Scaffold(
      appBar: AppBar(title: const Text('ઉપાડ')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DropdownButtonFormField<String>(
            value: widget.section,
            decoration: const InputDecoration(
              labelText: 'વિભાગ',
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
            onChanged: (_) {},
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: workerId,
            decoration: const InputDecoration(
              labelText: 'કારીગર',
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
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.grey),
            ),
            leading: const Icon(Icons.calendar_month),
            title: const Text('તારીખ'),
            subtitle: Text(
              '${date.day}/${date.month}/${date.year}',
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                initialDate: date,
              );

              if (picked != null) {
                setState(() {
                  date = picked;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: amountController,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'ઉપાડ',
              prefixIcon: Icon(Icons.currency_rupee),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: () async {
                if (workerId == null) {
                  showMessage(context, 'કારીગર પસંદ કરો');
                  return;
                }

                final amount =
                    double.tryParse(amountController.text) ?? 0;

                if (amount <= 0) {
                  showMessage(context, 'ઉપાડની રકમ નાખો');
                  return;
                }

                AppData.instance.withdrawals.add(
                  WithdrawalRecord(
                    id: DateTime.now()
                        .millisecondsSinceEpoch
                        .toString(),
                    section: widget.section,
                    date:
                        '${date.day.toString().padLeft(2, '0')}/'
                        '${date.month.toString().padLeft(2, '0')}/'
                        '${date.year}',
                    workerId: workerId!,
                    amount: amount,
                  ),
                );

                await AppData.instance.save();

                if (!context.mounted) return;

                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
              label: const Text('ઉપાડ Save કરો'),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= WORK CARD =================

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
    final worker = AppData.instance.getWorker(record.workerId);

    return Card(
      child: ListTile(
        leading: const Icon(Icons.diamond),
        title: Text(
          worker?.name ?? 'Unknown Worker',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${record.date}\n'
          '${record.diamonds} × ${money(record.rate)}',
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
                if (value == 'delete') {
                  AppData.instance.works
                      .removeWhere((e) => e.id == record.id);

                  await AppData.instance.save();
                  onChanged();
                }
              },
              itemBuilder: (_) => const [
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

// ================= WITHDRAWAL CARD =================

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
    final worker = AppData.instance.getWorker(record.workerId);

    return Card(
      child: ListTile(
        leading: const Icon(Icons.payments),
        title: Text(
          worker?.name ?? 'Unknown Worker',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(record.date),
        trailing: Text(
          money(record.amount),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ================= WORKER HISTORY =================

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

    final totalDiamonds =
        works.fold<double>(0, (sum, e) => sum + e.diamonds);

    final totalWork =
        works.fold<double>(0, (sum, e) => sum + e.total);

    final totalWithdrawal =
        withdrawals.fold<double>(0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text(worker.name),
        actions: [
          IconButton(
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
                child: Icon(Icons.person),
              ),
              title: Text(worker.name),
              subtitle: Text(
                'મોબાઇલ: ${worker.mobile}\n'
                'ફેક્ટરી: ${worker.factory}',
              ),
            ),
          ),
          const SizedBox(height: 12),
          SummaryCard(
            title: 'ટોટલ હીરા',
            value: formatNumber(totalDiamonds),
            icon: Icons.diamond,
          ),
          SummaryCard(
            title: 'ટોટલ કામ',
            value: money(totalWork),
            icon: Icons.currency_rupee,
          ),
          SummaryCard(
            title: 'ટોટલ ઉપાડ',
            value: money(totalWithdrawal),
            icon: Icons.payments,
          ),
          const SizedBox(height: 20),
          const Text(
            'કામની હિસ્ટરી',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...works.map(
            (record) => Card(
              child: ListTile(
                title: Text(record.date),
                subtitle: Text(
                  '${record.section}\n'
                  '${record.diamonds} × ${money(record.rate)}',
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
            'ઉપાડ',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
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

// ================= TOTAL DIAMONDS =================

class TotalDiamondsPage extends StatelessWidget {
  const TotalDiamondsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = ['તળીયા', 'પેલ', 'મથાળા'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ટોટલ હીરા'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...sections.map(
            (section) {
              final works = AppData.instance.works
                  .where((e) => e.section == section)
                  .toList();

              final diamonds =
                  works.fold<double>(0, (sum, e) => sum + e.diamonds);

              final total =
                  works.fold<double>(0, (sum, e) => sum + e.total);

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

              final diamonds =
                  works.fold<double>(0, (sum, e) => sum + e.diamonds);

              final total =
                  works.fold<double>(0, (sum, e) => sum + e.total);

              return Card(
                child: ListTile(
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

// ================= PDF PAGE =================

class PdfPage extends StatelessWidget {
  const PdfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Complete History PDF'),
              subtitle: const Text(
                'કામ અને ઉપાડની સંપૂર્ણ હિસ્ટરી',
              ),
              trailing: const Icon(Icons.picture_as_pdf),
              onTap: () {
                generateCompletePdf();
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Worker-wise PDF'),
              subtitle: const Text(
                'કારીગર પ્રમાણે હિસ્ટરી',
              ),
              trailing: const Icon(Icons.picture_as_pdf),
              onTap: () async {
                if (AppData.instance.workers.isEmpty) {
                  showMessage(context, 'પહેલા કારીગર ઉમેરો');
                  return;
                }

                final worker = AppData.instance.workers.first;

                await generateWorkerPdf(worker);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ================= PDF FUNCTIONS =================

Future<void> generateCompletePdf() async {
  final pdf = pw.Document();

  final works = AppData.instance.works;
  final withdrawals = AppData.instance.withdrawals;

  final totalDiamonds =
      works.fold<double>(0, (sum, e) => sum + e.diamonds);

  final totalWork =
      works.fold<double>(0, (sum, e) => sum + e.total);

  final totalWithdrawal =
      withdrawals.fold<double>(0, (sum, e) => sum + e.amount);

  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Header(
          level: 0,
          child: pw.Text('Hira Kaam History'),
        ),
        pw.Text(
          'Total Diamonds: ${formatNumber(totalDiamonds)}',
        ),
        pw.Text(
          'Total Work: ${money(totalWork)}',
        ),
        pw.Text(
          'Total Withdrawal: ${money(totalWithdrawal)}',
        ),
        pw.SizedBox(height: 20),
        pw.Text('Work History'),
        pw.SizedBox(height: 10),
        pw.Table.fromTextArray(
          headers: [
            'Date',
            'Section',
            'Worker',
            'Diamonds',
            'Rate',
            'Total Work',
          ],
          data: works.map((record) {
            final worker =
                AppData.instance.getWorker(record.workerId);

            return [
              record.date,
              record.section,
              worker?.name ?? '',
              formatNumber(record.diamonds),
              money(record.rate),
              money(record.total),
            ];
          }).toList(),
        ),
        pw.SizedBox(height: 20),
        pw.Text('Withdrawal History'),
        pw.SizedBox(height: 10),
        pw.Table.fromTextArray(
          headers: [
            'Date',
            'Section',
            'Worker',
            'Withdrawal',
          ],
          data: withdrawals.map((record) {
            final worker =
                AppData.instance.getWorker(record.workerId);

            return [
              record.date,
              record.section,
              worker?.name ?? '',
              money(record.amount),
            ];
          }).toList(),
        ),
      ],
    ),
  );

  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename: 'hira_kaam_history.pdf',
  );
}

Future<void> generateWorkerPdf(Worker worker) async {
  final pdf = pw.Document();

  final works = AppData.instance.works
      .where((e) => e.workerId == worker.id)
      .toList();

  final withdrawals = AppData.instance.withdrawals
      .where((e) => e.workerId == worker.id)
      .toList();

  final totalDiamonds =
      works.fold<double>(0, (sum, e) => sum + e.diamonds);

  final totalWork =
      works.fold<double>(0, (sum, e) => sum + e.total);

  final totalWithdrawal =
      withdrawals.fold<double>(0, (sum, e) => sum + e.amount);

  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Header(
          level: 0,
          child: pw.Text('Worker History'),
        ),
        pw.Text('Worker: ${worker.name}'),
        pw.Text('Mobile: ${worker.mobile}'),
        pw.Text('Factory: ${worker.factory}'),
        pw.SizedBox(height: 15),
        pw.Text(
          'Total Diamonds: ${formatNumber(totalDiamonds)}',
        ),
        pw.Text(
          'Total Work: ${money(totalWork)}',
        ),
        pw.Text(
          'Total Withdrawal: ${money(totalWithdrawal)}',
        ),
        pw.SizedBox(height: 20),
        pw.Table.fromTextArray(
          headers: [
            'Date',
            'Section',
            'Diamonds',
            'Rate',
            'Total Work',
          ],
          data: works.map((record) {
            return [
              record.date,
              record.section,
              formatNumber(record.diamonds),
              money(record.rate),
              money(record.total),
            ];
          }).toList(),
        ),
        pw.SizedBox(height: 20),
        pw.Text('Withdrawal'),
        pw.Table.fromTextArray(
          headers: [
            'Date',
            'Section',
            'Withdrawal',
          ],
          data: withdrawals.map((record) {
            return [
              record.date,
              record.section,
              money(record.amount),
            ];
          }).toList(),
        ),
      ],
    ),
  );

  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename:
        'worker_${worker.name.replaceAll(' ', '_')}.pdf',
  );
}

// ================= HELPERS =================

String money(double value) {
  return '₹${value.toStringAsFixed(2)}';
}

String formatNumber(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }

  return value.toStringAsFixed(2);
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

// ================= EMPTY =================

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
          ),
        ),
      ),
    );
  }
}
