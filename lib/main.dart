import 'package:flutter/material.dart';

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
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      ),
      home: const SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final mobileController = TextEditingController();
  final otpController = TextEditingController();
  bool otpSent = false;

  @override
  void dispose() {
    mobileController.dispose();
    otpController.dispose();
    super.dispose();
  }

  void sendOtp() {
    if (mobileController.text.trim().length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('10 અંકનો મોબાઇલ નંબર નાખો')),
      );
      return;
    }

    setState(() => otpSent = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Demo OTP: 123456')),
    );
  }

  void verifyOtp() {
    if (otpController.text.trim() != '123456') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP ખોટો છે')),
      );
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.diamond,
                      size: 64,
                      color: Colors.indigo,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'હિરા કામ હિસ્ટરી',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('મોબાઇલ નંબરથી Sign Up કરો'),
                    const SizedBox(height: 24),
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
                    if (otpSent) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          labelText: 'OTP',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: otpSent ? verifyOtp : sendOtp,
                        child: Text(
                          otpSent ? 'OTP Verify' : 'OTP મોકલો',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int index = 0;

  final pages = const [
    SummaryPage(title: 'તળીયા'),
    SummaryPage(title: 'પેલ'),
    SummaryPage(title: 'મથાળા'),
    WorkerPage(),
  ];

  void openPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'હિરા કામ હિસ્ટરી',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: index == 3
          ? pages[index]
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _menuCard(
                          '👷 કારીગર',
                          Icons.people,
                          () => openPage(const WorkerPage()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _menuCard(
                          '💼 કામ',
                          Icons.work,
                          () => openPage(const WorkPage()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _menuCard(
                          '💰 ઉપાડ',
                          Icons.payments,
                          () => openPage(const WithdrawalPage()),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: pages[index]),
              ],
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          setState(() => index = value);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.layers),
            label: 'તળીયા',
          ),
          NavigationDestination(
            icon: Icon(Icons.diamond),
            label: 'પેલ',
          ),
          NavigationDestination(
            icon: Icon(Icons.category),
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

  Widget _menuCard(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 8,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Colors.indigo,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkerPage extends StatefulWidget {
  const WorkerPage({super.key});

  @override
  State<WorkerPage> createState() => _WorkerPageState();
}

class _WorkerPageState extends State<WorkerPage> {
  final name = TextEditingController();
  final mobile = TextEditingController();
  final factory = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    mobile.dispose();
    factory.dispose();
    super.dispose();
  }

  void save() {
    if (name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('કારીગરનું નામ નાખો'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('કારીગર સેવ થયો'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👷 કારીગર'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field(
            name,
            'કારીગરનું નામ',
            Icons.person,
          ),
          _field(
            mobile,
            'મોબાઇલ નંબર',
            Icons.phone,
            type: TextInputType.phone,
          ),
          _field(
            factory,
            'કારખાના નંબર',
            Icons.factory,
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: save,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
          const SizedBox(height: 20),
          const Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text('Saved Worker'),
              subtitle: Text(
                'Edit માટે અહીંથી પસંદ કરો',
              ),
              trailing: Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? type,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  String type = 'તળીયા';

  final date = TextEditingController();
  final worker = TextEditingController();
  final diamonds = TextEditingController();
  final rate = TextEditingController();

  double get total {
    final d = double.tryParse(diamonds.text) ?? 0;
    final r = double.tryParse(rate.text) ?? 0;
    return d * r;
  }

  @override
  void dispose() {
    date.dispose();
    worker.dispose();
    diamonds.dispose();
    rate.dispose();
    super.dispose();
  }

  void save() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'કામ સેવ થયું: ₹${total.toStringAsFixed(2)}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💼 કામ'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            value: type,
            decoration: const InputDecoration(
              labelText: 'કામનો પ્રકાર',
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
                setState(() => type = value);
              }
            },
          ),
          const SizedBox(height: 12),
          _field(
            date,
            'તારીખ',
            Icons.calendar_month,
          ),
          _field(
            worker,
            'કારીગર',
            Icons.person,
          ),
          _field(
            diamonds,
            'હીરા',
            Icons.diamond,
            type: TextInputType.number,
          ),
          _field(
            rate,
            'ભાવ',
            Icons.currency_rupee,
            type: TextInputType.number,
          ),
          Card(
            child: ListTile(
              title: const Text('કુલ કામ'),
              trailing: Text(
                '₹${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: save,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? type,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({super.key});

  @override
  State<WithdrawalPage> createState() =>
      _WithdrawalPageState();
}

class _WithdrawalPageState
    extends State<WithdrawalPage> {
  String type = 'તળીયા';

  final worker = TextEditingController();
  final date = TextEditingController();
  final amount = TextEditingController();

  @override
  void dispose() {
    worker.dispose();
    date.dispose();
    amount.dispose();
    super.dispose();
  }

  void save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ઉપાડ સેવ થયો'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💰 ઉપાડ'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            value: type,
            decoration: const InputDecoration(
              labelText: 'કામનો પ્રકાર',
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
                setState(() => type = value);
              }
            },
          ),
          const SizedBox(height: 12),
          _field(
            worker,
            'કારીગર',
            Icons.person,
          ),
          _field(
            date,
            'તારીખ',
            Icons.calendar_month,
          ),
          _field(
            amount,
            'ઉપાડ',
            Icons.currency_rupee,
            type: TextInputType.number,
          ),
          ElevatedButton.icon(
            onPressed: save,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? type,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class SummaryPage extends StatelessWidget {
  final String title;

  const SummaryPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _summaryCard(
          'કુલ કામ',
          '₹0.00',
          Icons.work,
        ),
        _summaryCard(
          'કુલ ઉપાડ',
          '₹0.00',
          Icons.payments,
        ),
        _summaryCard(
          'બાકી',
          '₹0.00',
          Icons.account_balance_wallet,
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.date_range),
            title: Text('Date-wise History'),
            subtitle: Text(
              'કામ અને ઉપાડની તારીખવાર માહિતી અહીં દેખાશે',
            ),
            trailing: Icon(Icons.edit),
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
