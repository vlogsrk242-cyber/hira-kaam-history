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
        colorSchemeSeed: Colors.blue,
      ),
      home: const SignUpPage(),
    );
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.diamond,
                size: 90,
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

              const SizedBox(height: 10),

              const Text(
                'તમારા કામ અને ઉપાડનો સરળ હિસાબ',
                textAlign: TextAlign.center,
              ),

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
                child: ElevatedButton(
                  onPressed: () {
                    if (mobileController.text.length == 10) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardPage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('10 અંકનો મોબાઇલ નંબર નાખો'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= DASHBOARD =================

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void openPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
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

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'સ્વાગત 👋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'તમારો કામ અને ઉપાડનો હિસાબ મેનેજ કરો.',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          DashboardButton(
            icon: Icons.person,
            title: 'કારીગર',
            color: Colors.orange,
            onTap: () {
              openPage(context, const WorkerPage());
            },
          ),

          DashboardButton(
            icon: Icons.work,
            title: 'કામ',
            color: Colors.green,
            onTap: () {
              openPage(context, const WorkPage());
            },
          ),

          DashboardButton(
            icon: Icons.payments,
            title: 'ઉપાડ',
            color: Colors.deepPurple,
            onTap: () {
              openPage(context, const WithdrawalPage());
            },
          ),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.layers_outlined),
            label: 'તળીયા',
          ),
          NavigationDestination(
            icon: Icon(Icons.diamond_outlined),
            label: 'પેલ',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_headline),
            label: 'મથાળા',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            label: 'કારીગર',
          ),
        ],
        onDestinationSelected: (index) {
          if (index == 0) {
            openPage(context, const SummaryPage(type: 'તળીયા'));
          }

          if (index == 1) {
            openPage(context, const SummaryPage(type: 'પેલ'));
          }

          if (index == 2) {
            openPage(context, const SummaryPage(type: 'મથાળા'));
          }

          if (index == 3) {
            openPage(context, const WorkerPage());
          }
        },
      ),
    );
  }
}

// ================= DASHBOARD BUTTON =================

class DashboardButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const DashboardButton({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(15),
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ================= WORKER =================

class WorkerPage extends StatelessWidget {
  const WorkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('કારીગર'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'કારીગરનું નામ',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            const TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'મોબાઇલ નંબર',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            const TextField(
              decoration: InputDecoration(
                labelText: 'કારખાના નંબર',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('કારીગર Save થયો'),
                    ),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= WORK =================

class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  String type = 'તળીયા';

  final diamondsController = TextEditingController();
  final rateController = TextEditingController();

  double total = 0;

  void calculate() {
    final diamonds =
        double.tryParse(diamondsController.text) ?? 0;

    final rate =
        double.tryParse(rateController.text) ?? 0;

    setState(() {
      total = diamonds * rate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('કામ'),
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
              setState(() {
                type = value!;
              });
            },
          ),

          const SizedBox(height: 15),

          const TextField(
            decoration: InputDecoration(
              labelText: 'તારીખ',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          const TextField(
            decoration: InputDecoration(
              labelText: 'કારીગર',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: diamondsController,
            keyboardType: TextInputType.number,
            onChanged: (_) => calculate(),
            decoration: const InputDecoration(
              labelText: 'હીરા',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: rateController,
            keyboardType: TextInputType.number,
            onChanged: (_) => calculate(),
            decoration: const InputDecoration(
              labelText: 'ભાવ',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                'કુલ કામ = ₹${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('કામ Save થયું'),
                ),
              );
            },
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ================= WITHDRAWAL =================

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({super.key});

  @override
  State<WithdrawalPage> createState() =>
      _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  String type = 'તળીયા';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ઉપાડ'),
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
              setState(() {
                type = value!;
              });
            },
          ),

          const SizedBox(height: 15),

          const TextField(
            decoration: InputDecoration(
              labelText: 'કારીગર',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          const TextField(
            decoration: InputDecoration(
              labelText: 'તારીખ',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          const TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'ઉપાડ',
              prefixText: '₹ ',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ઉપાડ Save થયો'),
                ),
              );
            },
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ================= SUMMARY =================

class SummaryPage extends StatelessWidget {
  final String type;

  const SummaryPage({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.work,
                color: Colors.green,
              ),
              title: const Text('કુલ કામ'),
              trailing: const Text(
                '₹0',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.payments,
                color: Colors.deepPurple,
              ),
              title: const Text('કુલ ઉપાડ'),
              trailing: const Text(
                '₹0',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Card(
            color: Colors.blue.shade50,
            child: const ListTile(
              title: Text(
                'બાકી કામ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                '₹0',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'તારીખ પ્રમાણે હિસાબ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Card(
            child: ListTile(
              title: Text('હજુ કોઈ રેકોર્ડ નથી'),
              subtitle: Text(
                'Dashboardમાંથી કામ અથવા ઉપાડ Save કરો.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
