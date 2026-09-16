import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(const HiraKaamHistoryApp());
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

  double get totalWork => diamonds * rate;

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

// ================= DATABASE =================

class AppData extends ChangeNotifier {
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

    notifyListeners();
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

    notifyListeners();
  }

  Worker? getWorker(String id) {
    for (final worker in workers) {
      if (worker.id == id) return worker;
    }
    return null;
  }
}

final appData = AppData();

// ================= APP =================

class HiraKaamHistoryApp extends StatefulWidget {
  const HiraKaamHistoryApp({super.key});

  @override
  State<HiraKaamHistoryApp> createState() => _HiraKaamHistoryAppState();
}

class _HiraKaamHistoryAppState extends State<HiraKaamHistoryApp> {
  @override
  void initState() {
    super.initState();
    appData.load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appData,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'હિરા કામ હિસ્ટરી',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
          ),
          home: const LoginPage(),
        );
      },
    );
  }
}

// ================= LOGIN =================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final mobileController = TextEditingController();

  void login() {
    if (mobileController.text.length != 10) {
      showMessage(context, '10 અંકનો મોબાઇલ નંબર નાખો');
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const OtpPage(),
      ),
    );
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
                const Icon(
                  Icons.diamond,
                  size: 80,
                ),
                const SizedBox(height: 15),
                const Text(
                  'હિરા કામ હિસ્ટરી',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Sheth App'),
                const SizedBox(height: 35),
                TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: 'મોબાઇલ નંબર',
                    prefixText: '+91 ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: login,
                    child: const Text('OTP Verification'),
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

  void verify() {
    if (otpController.text.length != 6) {
      showMessage(context, '6 અંકનો OTP નાખો');
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'OTP નાખો',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: '6 Digit OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: verify,
                child: const Text('Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= DASHBOARD =================

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0;

  final sections = [
    'તળીયા',
    'પેલ',
    'મથાળા',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('હિરા કામ હિસ્ટરી'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TotalDiamondsPage(),
                ),
              );
            },
            icon: const Icon(Icons.diamond),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PdfPage(),
                ),
              );
            },
            icon: const Icon(Icons.picture_as_pdf),
          ),
        ],
      ),
      body: selectedIndex < 3
          ? SectionPage(
              section: sections[selectedIndex],
            )
          : const WorkerPage(),
      floatingActionButton: selectedIndex < 3
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkPage(
                      section: sections[selectedIndex],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('કામ'),
            )
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WorkerFormPage(),
                  ),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text('કારીગર'),
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

// ================= SECTION =================

class SectionPage extends StatelessWidget {
  final String section;

  const SectionPage({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final works =
        appData.works.where((e) => e.section == section).toList();

    final withdrawals =
        appData.withdrawals.where((e) => e.section == section).toList();

    final totalDiamonds =
        works.fold<double>(0, (sum, e) => sum + e.diamonds);

    final totalWork =
        works.fold<double>(0, (sum, e) => sum + e.totalWork);

    final totalWithdrawal =
        withdrawals.fold<double>(0, (sum, e) => sum + e.amount);

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Row(
          children: [
            summaryCard(
              'હીરા',
              totalDiamonds.toStringAsFixed(0),
            ),
            summaryCard(
              'ટોટલ કામ',
              money(totalWork),
            ),
            summaryCard(
              'ઉપાડ',
              money(totalWithdrawal),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // WORK
        Card(
          child: ListTile(
            leading: const Icon(Icons.add_circle),
            title: const Text('નવું કામ'),
            subtitle: const Text('હીરા × ભાવ = ટોટલ કામ'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkPage(
                    section: section,
                  ),
                ),
              );
            },
          ),
        ),

        // WITHDRAWAL
        Card(
          child: ListTile(
            leading: const Icon(Icons.payments),
            title: const Text('ઉપાડ'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WithdrawalPage(
                    section: section,
                  ),
                ),
              );
            },
          ),
        ),

        const Divider(),

        const Text(
          'તારીખ પ્રમાણે કામ',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        ...works.reversed.map(
          (work) => Card(
            child: ListTile(
              title: Text(
                '${work.date} • ${appData.getWorker(work.workerId)?.name ?? "કારીગર"}',
              ),
              subtitle: Text(
                '${work.diamonds.toStringAsFixed(0)} × '
                '${money(work.rate)} = '
                '${money(work.totalWork)}',
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkPage(
                          section: section,
                          oldRecord: work,
                        ),
                      ),
                    );
                  }

                  if (value == 'delete') {
                    appData.works.remove(work);
                    appData.save();
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

        const Divider(),

        const Text(
          'ઉપાડની હિસ્ટરી',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        ...withdrawals.reversed.map(
          (withdrawal) => Card(
            child: ListTile(
              title: Text(
                '${withdrawal.date} • '
                '${appData.getWorker(withdrawal.workerId)?.name ?? "કારીગર"}',
              ),
              subtitle: Text(
                'ઉપાડ: ${money(withdrawal.amount)}',
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WithdrawalPage(
                          section: section,
                          oldRecord: withdrawal,
                        ),
                      ),
                    );
                  }

                  if (value == 'delete') {
                    appData.withdrawals.remove(withdrawal);
                    appData.save();
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

// ================= WORKER =================

class WorkerPage extends StatelessWidget {
  const WorkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        ...appData.workers.map(
          (worker) => Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkerHistoryPage(
                      worker: worker,
                    ),
                  ),
                );
              },
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(worker.name),
              subtitle: Text(
                '${worker.mobile} • ફેક્ટરી ${worker.factory}',
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkerFormPage(
                          oldWorker: worker,
                        ),
                      ),
                    );
                  }

                  if (value == 'delete') {
                    appData.workers.remove(worker);
                    appData.save();
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
  final Worker? oldWorker;

  const WorkerFormPage({
    super.key,
    this.oldWorker,
  });

  @override
  State<WorkerFormPage> createState() => _WorkerFormPageState();
}

class _WorkerFormPageState extends State<WorkerFormPage> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final factoryController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final worker = widget.oldWorker;

    if (worker != null) {
      nameController.text = worker.name;
      mobileController.text = worker.mobile;
      factoryController.text = worker.factory;
    }
  }

  void saveWorker() {
    if (nameController.text.isEmpty ||
        mobileController.text.length != 10 ||
        factoryController.text.isEmpty) {
      showMessage(
        context,
        'બધી માહિતી સાચી રીતે નાખો',
      );
      return;
    }

    if (widget.oldWorker == null) {
      appData.workers.add(
        Worker(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          name: nameController.text,
          mobile: mobileController.text,
          factory: factoryController.text,
        ),
      );
    } else {
      widget.oldWorker!.name = nameController.text;
      widget.oldWorker!.mobile = mobileController.text;
      widget.oldWorker!.factory = factoryController.text;
    }

    appData.save();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      title: widget.oldWorker == null
          ? 'નવો કારીગર'
          : 'કારીગર Edit',
      fields: [
        input(
          nameController,
          'કારીગરનું નામ',
        ),
        input(
          mobileController,
          'મોબાઇલ નંબર',
          keyboardType: TextInputType.phone,
        ),
        input(
          factoryController,
          'ફેક્ટરી નંબર',
        ),
      ],
      onSave: saveWorker,
    );
  }
}

// ================= WORK =================

class WorkPage extends StatefulWidget {
  final String section;
  final WorkRecord? oldRecord;

  const WorkPage({
    super.key,
    required this.section,
    this.oldRecord,
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

    if (widget.oldRecord != null) {
      final work = widget.oldRecord!;

      section = work.section;
      workerId = work.workerId;
      diamondsController.text =
          work.diamonds.toString();
      rateController.text =
          work.rate.toString();

      selectedDate =
          DateTime.tryParse(work.date) ??
              DateTime.now();
    }

    diamondsController.addListener(() {
      setState(() {});
    });

    rateController.addListener(() {
      setState(() {});
    });
  }

  void saveWork() {
    final diamonds =
        double.tryParse(diamondsController.text) ?? 0;

    final rate =
        double.tryParse(rateController.text) ?? 0;

    if (workerId == null ||
        diamonds <= 0 ||
        rate <= 0) {
      showMessage(
        context,
        'કારીગર, હીરા અને ભાવ નાખો',
      );
      return;
    }

    if (widget.oldRecord == null) {
      appData.works.add(
        WorkRecord(
          id: DateTime.now()
              .microsecondsSinceEpoch
              .toString(),
          section: section,
          date: formatDate(selectedDate),
          workerId: workerId!,
          diamonds: diamonds,
          rate: rate,
        ),
      );
    } else {
      final work = widget.oldRecord!;

      work.section = section;
      work.date = formatDate(selectedDate);
      work.workerId = workerId!;
      work.diamonds = diamonds;
      work.rate = rate;
    }

    appData.save();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final diamonds =
        double.tryParse(diamondsController.text) ?? 0;

    final rate =
        double.tryParse(rateController.text) ?? 0;

    final total = diamonds * rate;

    return FormScaffold(
      title: 'કામ નોંધો',
      fields: [
        DropdownButtonFormField<String>(
          value: section,
          decoration: const InputDecoration(
            labelText: 'Section',
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
            setState(() {
              section = value!;
            });
          },
        ),

        const SizedBox(height: 12),

        ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.grey.shade400,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          leading: const Icon(Icons.calendar_month),
          title: const Text('તારીખ'),
          subtitle: Text(
            formatDate(selectedDate),
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

        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          value: workerId,
          decoration: const InputDecoration(
            labelText: 'કારીગર',
            border: OutlineInputBorder(),
          ),
          items: appData.workers.map(
            (worker) {
              return DropdownMenuItem(
                value: worker.id,
                child: Text(worker.name),
              );
            },
          ).toList(),
          onChanged: (value) {
            setState(() {
              workerId = value;
            });
          },
        ),

        const SizedBox(height: 12),

        input(
          diamondsController,
          'હીરા',
          keyboardType: TextInputType.number,
        ),

        input(
          rateController,
          'ભાવ',
          keyboardType: TextInputType.number,
        ),

        const SizedBox(height: 15),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Text(
              'હીરા × ભાવ = ટોટલ કામ\n\n'
              '${diamonds.toStringAsFixed(0)} × '
              '${money(rate)} = '
              '${money(total)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
      onSave: saveWork,
    );
  }
}

// ================= WITHDRAWAL =================

class WithdrawalPage extends StatefulWidget {
  final String section;
  final WithdrawalRecord? oldRecord;

  const WithdrawalPage({
    super.key,
    required this.section,
    this.oldRecord,
  });

  @override
  State<WithdrawalPage> createState() =>
      _WithdrawalPageState();
}

class _WithdrawalPageState
    extends State<WithdrawalPage> {
  late String section;
  String? workerId;

  DateTime selectedDate = DateTime.now();

  final amountController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    section = widget.section;

    if (widget.oldRecord != null) {
      final record = widget.oldRecord!;

      section = record.section;
      workerId = record.workerId;

      amountController.text =
          record.amount.toString();

      selectedDate =
          DateTime.tryParse(record.date) ??
              DateTime.now();
    }
  }

  void saveWithdrawal() {
    final amount =
        double.tryParse(amountController.text) ?? 0;

    if (workerId == null || amount <= 0) {
      showMessage(
        context,
        'કારીગર અને ઉપાડ નાખો',
      );
      return;
    }

    if (widget.oldRecord == null) {
      appData.withdrawals.add(
        WithdrawalRecord(
          id: DateTime.now()
              .microsecondsSinceEpoch
              .toString(),
          section: section,
          date: formatDate(selectedDate),
          workerId: workerId!,
          amount: amount,
        ),
      );
    } else {
      final record = widget.oldRecord!;

      record.section = section;
      record.date = formatDate(selectedDate);
      record.workerId = workerId!;
      record.amount = amount;
    }

    appData.save();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      title: 'ઉપાડ નોંધો',
      fields: [
        DropdownButtonFormField<String>(
          value: section,
          decoration: const InputDecoration(
            labelText: 'Section',
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
            setState(() {
              section = value!;
            });
          },
        ),

        const SizedBox(height: 12),

        ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          leading: const Icon(
            Icons.calendar_month,
          ),
          title: const Text('તારીખ'),
          subtitle: Text(
            formatDate(selectedDate),
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

        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          value: workerId,
          decoration: const InputDecoration(
            labelText: 'કારીગર',
            border: OutlineInputBorder(),
          ),
          items: appData.workers.map(
            (worker) {
              return DropdownMenuItem(
                value: worker.id,
                child: Text(worker.name),
              );
            },
          ).toList(),
          onChanged: (value) {
            setState(() {
              workerId = value;
            });
          },
        ),

        const SizedBox(height: 12),

        input(
          amountController,
          'ઉપાડ',
          keyboardType: TextInputType.number,
        ),
      ],
      onSave: saveWithdrawal,
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
    final works = appData.works
        .where((e) => e.workerId == worker.id)
        .toList();

    final withdrawals = appData.withdrawals
        .where((e) => e.workerId == worker.id)
        .toList();

    final totalDiamonds =
        works.fold<double>(
      0,
      (sum, e) => sum + e.diamonds,
    );

    final totalWork =
        works.fold<double>(
      0,
      (sum, e) => sum + e.totalWork,
    );

    final totalWithdrawal =
        withdrawals.fold<double>(
      0,
      (sum, e) => sum + e.amount,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(worker.name),
        actions: [
          IconButton(
            onPressed: () {
              generateWorkerPdf(
                context,
                worker,
                works,
                withdrawals,
              );
            },
            icon: const Icon(
              Icons.picture_as_pdf,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
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

          Row(
            children: [
              summaryCard(
                'ટોટલ હીરા',
                totalDiamonds.toStringAsFixed(0),
              ),
              summaryCard(
                'ટોટલ કામ',
                money(totalWork),
              ),
              summaryCard(
                'ટોટલ ઉપાડ',
                money(totalWithdrawal),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'પૂર્ણ હિસ્ટરી',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          ...works.reversed.map(
            (work) => Card(
              child: ListTile(
                title: Text(work.date),
                subtitle: Text(
                  '${work.section}\n'
                  '${work.diamonds.toStringAsFixed(0)} × '
                  '${money(work.rate)} = '
                  '${money(work.totalWork)}',
                ),
              ),
            ),
          ),

          ...withdrawals.reversed.map(
            (withdrawal) => Card(
              child: ListTile(
                leading: const Icon(Icons.payments),
                title: Text(withdrawal.date),
                subtitle: Text(
                  '${withdrawal.section} • '
                  'ઉપાડ: ${money(withdrawal.amount)}',
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
    const sections = [
      'તળીયા',
      'પેલ',
      'મથાળા',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ટોટલ હીરા'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: sections.map(
          (section) {
            final works = appData.works
                .where((e) => e.section == section)
                .toList();

            final diamonds =
                works.fold<double>(
              0,
              (sum, e) => sum + e.diamonds,
            );

            final totalWork =
                works.fold<double>(
              0,
              (sum, e) => sum + e.totalWork,
            );

            return Card(
              child: ListTile(
                leading: const Icon(
                  Icons.diamond,
                ),
                title: Text(section),
                subtitle: Text(
                  'ટોટલ હીરા: '
                  '${diamonds.toStringAsFixed(0)}\n'
                  'ટોટલ કામ: ${money(totalWork)}',
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SectionPage(
                        section: section,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

// ================= PDF =================

class PdfPage extends StatelessWidget {
  const PdfPage({super.key});

  Future<void> createPdf(
    BuildContext context,
  ) async {
    final pdf = pw.Document();

    final totalDiamonds =
        appData.works.fold<double>(
      0,
      (sum, e) => sum + e.diamonds,
    );

    final totalWork =
        appData.works.fold<double>(
      0,
      (sum, e) => sum + e.totalWork,
    );

    final totalWithdrawal =
        appData.withdrawals.fold<double>(
      0,
      (sum, e) => sum + e.amount,
    );

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            'Hira Kaam History',
            style: pw.TextStyle(
              fontSize: 24,
            ),
          ),

          pw.SizedBox(height: 15),

          ...appData.works.map(
            (work) {
              final worker =
                  appData.getWorker(work.workerId);

              return pw.Padding(
                padding:
                    const pw.EdgeInsets.only(
                  bottom: 6,
                ),
                child: pw.Text(
                  '${work.date} | '
                  '${worker?.name ?? ""} | '
                  '${work.section} | '
                  '${work.diamonds} × '
                  '${work.rate} = '
                  '${work.totalWork}',
                ),
              );
            },
          ),

          pw.SizedBox(height: 15),

          pw.Text(
            'Total Diamonds: '
            '$totalDiamonds',
          ),

          pw.Text(
            'Total Work: '
            '$totalWork',
          ),

          pw.Text(
            'Total Withdrawal: '
            '$totalWithdrawal',
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'hira_kaam_history.pdf',
    );
  }

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
              ),
              title: const Text(
                'Complete History PDF',
              ),
              subtitle: const Text(
                'Date • Worker • Section • '
                'Diamonds • Rate • Total Work • Withdrawal',
              ),
              onTap: () {
                createPdf(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ================= PDF WORKER =================

Future<void> generateWorkerPdf(
  BuildContext context,
  Worker worker,
  List<WorkRecord> works,
  List<WithdrawalRecord> withdrawals,
) async {
  final pdf = pw.Document();

  final totalDiamonds =
      works.fold<double>(
    0,
    (sum, e) => sum + e.diamonds,
  );

  final totalWork =
      works.fold<double>(
    0,
    (sum, e) => sum + e.totalWork,
  );

  final totalWithdrawal =
      withdrawals.fold<double>(
    0,
    (sum, e) => sum + e.amount,
  );

  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Text(
          'Hira Kaam History',
          style: pw.TextStyle(
            fontSize: 24,
          ),
        ),

        pw.SizedBox(height: 10),

        pw.Text('Worker: ${worker.name}'),
        pw.Text('Mobile: ${worker.mobile}'),
        pw.Text('Factory: ${worker.factory}'),

        pw.SizedBox(height: 15),

        ...works.map(
          (work) => pw.Text(
            '${work.date} | '
            '${work.section} | '
            '${work.diamonds} × '
            '${work.rate} = '
            '${work.totalWork}',
          ),
        ),

        ...withdrawals.map(
          (withdrawal) => pw.Text(
            '${withdrawal.date} | '
            '${withdrawal.section} | '
            'Withdrawal: ${withdrawal.amount}',
          ),
        ),

        pw.SizedBox(height: 15),

        pw.Text(
          'Total Diamonds: $totalDiamonds',
        ),

        pw.Text(
          'Total Work: $totalWork',
        ),

        pw.Text(
          'Total Withdrawal: '
          '$totalWithdrawal',
        ),
      ],
    ),
  );

  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename:
        '${worker.name}_history.pdf',
  );
}

// ================= COMMON WIDGETS =================

class FormScaffold extends StatelessWidget {
  final String title;
  final List<Widget> fields;
  final VoidCallback onSave;

  const FormScaffold({
    super.key,
    required this.title,
    required this.fields,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...fields,
          const SizedBox(height: 15),
          SizedBox(
            height: 52,
            width: double.infinity,
            child: FilledButton(
              onPressed: onSave,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}

Widget input(
  TextEditingController controller,
  String label, {
  TextInputType? keyboardType,
}) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 12,
    ),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    ),
  );
}

Widget summaryCard(
  String title,
  String value,
) {
  return Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ================= HELPERS =================

String money(double value) {
  return '₹${value.toStringAsFixed(2)}';
}

String formatDate(DateTime date) {
  return '${date.year}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
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
