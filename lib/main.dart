import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const HiraKaamHistoryApp());
}

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
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const SignUpPage(),
    );
  }
}

/* =========================
   MODELS
========================= */

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

/* =========================
   APP DATA
========================= */

class AppData {
  static final AppData instance = AppData._();

  AppData._();

  List<Worker> workers = [];
  List<WorkRecord> works = [];
  List<WithdrawalRecord> withdrawals = [];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final workerData = prefs.getString('workers');
    final workData = prefs.getString('works');
    final withdrawalData = prefs.getString('withdrawals');

    if (workerData != null) {
      workers = (jsonDecode(workerData) as List)
          .map((e) => Worker.fromJson(e))
          .toList();
    }

    if (workData != null) {
      works = (jsonDecode(workData) as List)
          .map((e) => WorkRecord.fromJson(e))
          .toList();
    }

    if (withdrawalData != null) {
      withdrawals = (jsonDecode(withdrawalData) as List)
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

  Worker? workerById(String id) {
    for (final worker in workers) {
      if (worker.id == id) return worker;
    }
    return null;
  }

  String workerName(String id) {
    return workerById(id)?.name ?? '';
  }
}

/* =========================
   SIGN UP
========================= */

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
                const SizedBox(height: 18),
                const Text(
                  'હિરા કામ હિસ્ટરી',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('શેઠની મેનેજમેન્ટ એપ'),
                const SizedBox(height: 40),
                TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: 'મોબાઈલ નંબર',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (mobileController.text.length != 10) {
                        showMessage(context, '10 અંકનો મોબાઈલ નંબર નાખો');
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OtpPage(
                            mobile: mobileController.text,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'OTP માટે આગળ વધો',
                      style: TextStyle(fontSize: 16),
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

/* =========================
   OTP
========================= */

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

  Future<void> openDashboard() async {
    await AppData.instance.load();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MainDashboard(),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Icon(
              Icons.verified_user,
              size: 70,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              '${widget.mobile} પર OTP મોકલવામાં આવશે',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'OTP',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (otpController.text.length != 6) {
                    showMessage(context, '6 અંકનો OTP નાખો');
                    return;
                  }

                  openDashboard();
                },
                child: const Text('Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================
   MAIN DASHBOARD
========================= */

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

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      SectionPage(
        section: sections[0],
        onChanged: refresh,
      ),
      SectionPage(
        section: sections[1],
        onChanged: refresh,
      ),
      SectionPage(
        section: sections[2],
        onChanged: refresh,
      ),
      const WorkerPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'હિરા કામ હિસ્ટરી',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TotalDiamondsPage(),
                ),
              ).then((_) => refresh());
            },
            icon: const Icon(Icons.diamond),
          ),
        ],
      ),
      body: pages[index],
      floatingActionButton: index == 0 ||
              index == 1 ||
              index == 2
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WorkPage(),
                  ),
                ).then((_) => refresh());
              },
              child: const Icon(Icons.add),
            )
          : null,
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
            icon: Icon(Icons.view_agenda),
            label: 'પેલ',
          ),
          NavigationDestination(
            icon: Icon(Icons.category),
            label: 'મથાળા',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'કારીગર',
          ),
        ],
      ),
    );
  }
}

/* =========================
   DASHBOARD SECTION PAGE
========================= */

class SectionPage extends StatelessWidget {
  final String section;
  final VoidCallback onChanged;

  const SectionPage({
    super.key,
    required this.section,
    required this.onChanged,
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
        .toList();

    final totalDiamonds =
        works.fold<double>(0, (sum, item) => sum + item.diamonds);

    final totalWork =
        works.fold<double>(0, (sum, item) => sum + item.total);

    final totalWithdrawal =
        withdrawals.fold<double>(0, (sum, item) => sum + item.amount);

    return RefreshIndicator(
      onRefresh: () async {
        onChanged();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            section,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'ટોટલ હીરા',
                  value: formatNumber(totalDiamonds),
                  icon: Icons.diamond,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SummaryCard(
                  title: 'ટોટલ કામ',
                  value: money(totalWork),
                  icon: Icons.work,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SummaryCard(
            title: 'ટોટલ ઉપાડ',
            value: money(totalWithdrawal),
            icon: Icons.payments,
          ),
          const SizedBox(height: 20),
          const Text(
            'તારીખવાર કામ',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (works.isEmpty)
            const EmptyCard(
              text: 'હજુ કોઈ કામ સેવ થયેલ નથી',
            ),
          ...works.map(
            (work) => WorkCard(
              work: work,
              onChanged: onChanged,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'તારીખવાર ઉપાડ',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (withdrawals.isEmpty)
            const EmptyCard(
              text: 'હજુ કોઈ ઉપાડ સેવ થયેલ નથી',
            ),
          ...withdrawals.map(
            (withdrawal) => WithdrawalCard(
              withdrawal: withdrawal,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/* =========================
   WORKER PAGE
========================= */

class WorkerPage extends StatefulWidget {
  const WorkerPage({super.key});

  @override
  State<WorkerPage> createState() => _WorkerPageState();
}

class _WorkerPageState extends State<WorkerPage> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final workers = AppData.instance.workers;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'કારીગર',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WorkerFormPage(),
                    ),
                  ).then((_) => refresh());
                },
                icon: const Icon(Icons.add),
                label: const Text('નવો કારીગર'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (workers.isEmpty)
            const EmptyCard(
              text: 'હજુ કોઈ કારીગર ઉમેરેલ નથી',
            ),
          ...workers.map(
            (worker) => Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(worker.name),
                subtitle: Text(
                  'મોબાઈલ: ${worker.mobile}\nકારખાના: ${worker.factory}',
                ),
                isThreeLine: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkerHistoryPage(
                        worker: worker,
                      ),
                    ),
                  ).then((_) => refresh());
                },
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WorkerFormPage(
                            worker: worker,
                          ),
                        ),
                      ).then((_) => refresh());
                    }

                    if (value == 'delete') {
                      await deleteWorker(context, worker);
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
      ),
    );
  }
}

/* =========================
   WORKER FORM
========================= */

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
  late TextEditingController name;
  late TextEditingController mobile;
  late TextEditingController factory;

  @override
  void initState() {
    super.initState();

    name = TextEditingController(
      text: widget.worker?.name ?? '',
    );

    mobile = TextEditingController(
      text: widget.worker?.mobile ?? '',
    );

    factory = TextEditingController(
      text: widget.worker?.factory ?? '',
    );
  }

  Future<void> saveWorker() async {
    if (name.text.trim().isEmpty ||
        mobile.text.trim().isEmpty ||
        factory.text.trim().isEmpty) {
      showMessage(context, 'બધી માહિતી ભરો');
      return;
    }

    if (mobile.text.trim().length != 10) {
      showMessage(context, 'મોબાઈલ નંબર 10 અંકનો હોવો જોઈએ');
      return;
    }

    if (widget.worker == null) {
      AppData.instance.workers.add(
        Worker(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name.text.trim(),
          mobile: mobile.text.trim(),
          factory: factory.text.trim(),
        ),
      );
    } else {
      widget.worker!
        ..name = name.text.trim()
        ..mobile = mobile.text.trim()
        ..factory = factory.text.trim();
    }

    await AppData.instance.save();

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.worker == null ? 'નવો કારીગર' : 'કારીગર Edit',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(
              labelText: 'કારીગરનું નામ',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: mobile,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: const InputDecoration(
              labelText: 'મોબાઈલ નંબર',
              prefixIcon: Icon(Icons.phone),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: factory,
            decoration: const InputDecoration(
              labelText: 'કારખાના નંબર',
              prefixIcon: Icon(Icons.factory),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: saveWorker,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}

/* =========================
   WORK FORM
========================= */

class WorkPage extends StatefulWidget {
  final WorkRecord? record;

  const WorkPage({
    super.key,
    this.record,
  });

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  String section = 'તળીયા';
  String? workerId;

  late TextEditingController date;
  late TextEditingController diamonds;
  late TextEditingController rate;

  @override
  void initState() {
    super.initState();

    section = widget.record?.section ?? 'તળીયા';
    workerId = widget.record?.workerId;

    date = TextEditingController(
      text: widget.record?.date ?? '',
    );

    diamonds = TextEditingController(
      text: widget.record?.diamonds.toString() ?? '',
    );

    rate = TextEditingController(
      text: widget.record?.rate.toString() ?? '',
    );

    diamonds.addListener(update);
    rate.addListener(update);
  }

  void update() {
    setState(() {});
  }

  double get total {
    final d = double.tryParse(diamonds.text) ?? 0;
    final r = double.tryParse(rate.text) ?? 0;
    return d * r;
  }

  Future<void> saveWork() async {
    if (workerId == null ||
        date.text.trim().isEmpty ||
        diamonds.text.trim().isEmpty ||
        rate.text.trim().isEmpty) {
      showMessage(context, 'બધી માહિતી ભરો');
      return;
    }

    final d = double.tryParse(diamonds.text);
    final r = double.tryParse(rate.text);

    if (d == null || r == null) {
      showMessage(context, 'હીરા અને ભાવ સાચી રીતે નાખો');
      return;
    }

    if (widget.record == null) {
      AppData.instance.works.add(
        WorkRecord(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          section: section,
          date: date.text.trim(),
          workerId: workerId!,
          diamonds: d,
          rate: r,
        ),
      );
    } else {
      widget.record!
        ..section = section
        ..date = date.text.trim()
        ..workerId = workerId!
        ..diamonds = d
        ..rate = r;
    }

    await AppData.instance.save();

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final workers = AppData.instance.workers;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.record == null ? 'કામ ઉમેરો' : 'કામ Edit',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            value: section,
            decoration: const InputDecoration(
              labelText: 'વિભાગ',
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
          const SizedBox(height: 12),
          TextField(
            controller: date,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'તારીખ',
              prefixIcon: Icon(Icons.calendar_month),
            ),
            onTap: () async {
              final selected = await showDatePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                initialDate: DateTime.now(),
              );

              if (selected != null) {
                setState(() {
                  date.text =
                      '${selected.day.toString().padLeft(2, '0')}-'
                      '${selected.month.toString().padLeft(2, '0')}-'
                      '${selected.year}';
                });
              }
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: workers.any((e) => e.id == workerId)
                ? workerId
                : null,
            decoration: const InputDecoration(
              labelText: 'કારીગર',
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
          const SizedBox(height: 12),
          TextField(
            controller: diamonds,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'હીરા',
              prefixIcon: Icon(Icons.diamond),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: rate,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'ભાવ',
              prefixIcon: Icon(Icons.currency_rupee),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                'હીરા × ભાવ = ${money(total)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: workers.isEmpty ? null : saveWork,
              child: const Text('Save'),
            ),
          ),
          if (workers.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                'પહેલા કારીગર ઉમેરો.',
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

/* =========================
   WITHDRAWAL
========================= */

class WithdrawalPage extends StatefulWidget {
  final WithdrawalRecord? record;

  const WithdrawalPage({
    super.key,
    this.record,
  });

  @override
  State<WithdrawalPage> createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  String section = 'તળીયા';
  String? workerId;

  late TextEditingController date;
  late TextEditingController amount;

  @override
  void initState() {
    super.initState();

    section = widget.record?.section ?? 'તળીયા';
    workerId = widget.record?.workerId;

    date = TextEditingController(
      text: widget.record?.date ?? '',
    );

    amount = TextEditingController(
      text: widget.record?.amount.toString() ?? '',
    );
  }

  Future<void> saveWithdrawal() async {
    if (workerId == null ||
        date.text.trim().isEmpty ||
        amount.text.trim().isEmpty) {
      showMessage(context, 'બધી માહિતી ભરો');
      return;
    }

    final value = double.tryParse(amount.text);

    if (value == null) {
      showMessage(context, 'ઉપાડની રકમ સાચી રીતે નાખો');
      return;
    }

    if (widget.record == null) {
      AppData.instance.withdrawals.add(
        WithdrawalRecord(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          section: section,
          date: date.text.trim(),
          workerId: workerId!,
          amount: value,
        ),
      );
    } else {
      widget.record!
        ..section = section
        ..date = date.text.trim()
        ..workerId = workerId!
        ..amount = value;
    }

    await AppData.instance.save();

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final workers = AppData.instance.workers;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.record == null ? 'ઉપાડ ઉમેરો' : 'ઉપાડ Edit',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            value: section,
            decoration: const InputDecoration(
              labelText: 'વિભાગ',
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
          const SizedBox(height: 12),
          TextField(
            controller: date,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'તારીખ',
              prefixIcon: Icon(Icons.calendar_month),
            ),
            onTap: () async {
              final selected = await showDatePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                initialDate: DateTime.now(),
              );

              if (selected != null) {
                setState(() {
                  date.text =
                      '${selected.day.toString().padLeft(2, '0')}-'
                      '${selected.month.toString().padLeft(2, '0')}-'
                      '${selected.year}';
                });
              }
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: workers.any((e) => e.id == workerId)
                ? workerId
                : null,
            decoration: const InputDecoration(
              labelText: 'કારીગર',
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
          const SizedBox(height: 12),
          TextField(
            controller: amount,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'ઉપાડ',
              prefixIcon: Icon(Icons.payments),
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: workers.isEmpty ? null : saveWithdrawal,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}

/* =========================
   WORKER HISTORY
========================= */

class WorkerHistoryPage extends StatelessWidget {
  final Worker worker;

  const WorkerHistoryPage({
    super.key,
    required this.worker,
  });

  @override
  Widget build(BuildContext context) {
    final data = AppData.instance;

    final works = data.works
        .where((e) => e.workerId == worker.id)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final withdrawals = data.withdrawals
        .where((e) => e.workerId == worker.id)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final totalDiamonds =
        works.fold<double>(0, (sum, e) => sum + e.diamonds);

    final totalWork =
        works.fold<double>(0, (sum, e) => sum + e.total);

    final totalWithdrawal =
        withdrawals.fold<double>(0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text(worker.name),
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
                'મોબાઈલ: ${worker.mobile}\n'
                'કારખાના: ${worker.factory}',
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
            icon: Icons.work,
          ),
          SummaryCard(
            title: 'ટોટલ ઉપાડ',
            value: money(totalWithdrawal),
            icon: Icons.payments,
          ),
          const SizedBox(height: 20),
          const Text(
            'તારીખવાર કામ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (works.isEmpty)
            const EmptyCard(
              text: 'કોઈ કામની માહિતી નથી',
            ),
          ...works.map(
            (work) => WorkCard(
              work: work,
              onChanged: () {},
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'તારીખવાર ઉપાડ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (withdrawals.isEmpty)
            const EmptyCard(
              text: 'કોઈ ઉપાડની માહિતી નથી',
            ),
          ...withdrawals.map(
            (withdrawal) => WithdrawalCard(
              withdrawal: withdrawal,
              onChanged: () {},
            ),
          ),
        ],
      ),
    );
  }
}

/* =========================
   TOTAL DIAMONDS
========================= */

class TotalDiamondsPage extends StatelessWidget {
  const TotalDiamondsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = AppData.instance;

    final sections = [
      'તળીયા',
      'પેલ',
      'મથાળા',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ટોટલ હીરા'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...sections.map(
            (section) {
              final works = data.works
                  .where((e) => e.section == section)
                  .toList();

              final diamonds = works.fold<double>(
                0,
                (sum, e) => sum + e.diamonds,
              );

              final work = works.fold<double>(
                0,
                (sum, e) => sum + e.total,
              );

              return Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.diamond,
                    color: Colors.blue,
                  ),
                  title: Text(
                    section,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'હીરા: ${formatNumber(diamonds)}\n'
                    'ટોટલ કામ: ${money(work)}',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/* =========================
   WORK CARD
========================= */

class WorkCard extends StatelessWidget {
  final WorkRecord work;
  final VoidCallback onChanged;

  const WorkCard({
    super.key,
    required this.work,
    required this.onChanged,
  });

  Future<void> delete() async {
    AppData.instance.works.removeWhere(
      (e) => e.id == work.id,
    );

    await AppData.instance.save();
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.diamond),
        ),
        title: Text(
          '${work.date} • ${AppData.instance.workerName(work.workerId)}',
        ),
        subtitle: Text(
          '${work.section}\n'
          'હીરા: ${formatNumber(work.diamonds)} × '
          '${money(work.rate)} = ${money(work.total)}',
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkPage(
                    record: work,
                  ),
                ),
              ).then((_) => onChanged());
            }

            if (value == 'delete') {
              await delete();
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
    );
  }
}

/* =========================
   WITHDRAWAL CARD
========================= */

class WithdrawalCard extends StatelessWidget {
  final WithdrawalRecord withdrawal;
  final VoidCallback onChanged;

  const WithdrawalCard({
    super.key,
    required this.withdrawal,
    required this.onChanged,
  });

  Future<void> delete() async {
    AppData.instance.withdrawals.removeWhere(
      (e) => e.id == withdrawal.id,
    );

    await AppData.instance.save();
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.payments),
        ),
        title: Text(
          '${withdrawal.date} • '
          '${AppData.instance.workerName(withdrawal.workerId)}',
        ),
        subtitle: Text(
          '${withdrawal.section}\n'
          'ઉપાડ: ${money(withdrawal.amount)}',
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WithdrawalPage(
                    record: withdrawal,
                  ),
                ),
              ).then((_) => onChanged());
            }

            if (value == 'delete') {
              await delete();
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
    );
  }
}

/* =========================
   SUMMARY CARD
========================= */

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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              child: Icon(icon),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================
   EMPTY CARD
========================= */

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

/* =========================
   DELETE WORKER
========================= */

Future<void> deleteWorker(
  BuildContext context,
  Worker worker,
) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('કારીગર Delete કરવો છે?'),
      content: Text(
        '${worker.name} ની માહિતી Delete થશે.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  AppData.instance.workers.removeWhere(
    (e) => e.id == worker.id,
  );

  AppData.instance.works.removeWhere(
    (e) => e.workerId == worker.id,
  );

  AppData.instance.withdrawals.removeWhere(
    (e) => e.workerId == worker.id,
  );

  await AppData.instance.save();
}

/* =========================
   HELPERS
========================= */

String money(double value) {
  return '₹${value.toStringAsFixed(2)}';
}

String formatNumber(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }

  return value.toStringAsFixed(2);
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
