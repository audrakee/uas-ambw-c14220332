import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final SupabaseClient supabase;
  List<dynamic> activities = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    supabase = Supabase.instance.client;
    _fetchActivities();
  }

  Future<void> _fetchActivities() async {
    setState(() => loading = true);
    final user = supabase.auth.currentUser;
    if (user == null) return;
    try {
      final res = await supabase
          .from('activities')
          .select()
          .eq('user_id', user.id)
          .order('schedule_time', ascending: true);
      print('DEBUG activities: $res');
      setState(() {
        activities = res;
        loading = false;
      });
    } catch (e) {
      setState(() {
        activities = [];
        loading = false;
      });
      print('ERROR fetch activities: $e');
    }
  }

  Future<void> _logout() async {
    await supabase.auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in');
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : activities.isEmpty
              ? const Center(child: Text('Belum ada aktivitas.'))
              : ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, i) {
                    final act = activities[i];
                    final desc = (act['description'] ?? '').toString().trim();
                    final dt = act['schedule_time'] != null
                        ? DateTime.tryParse(act['schedule_time'])
                        : null;
                    final tanggal = dt != null ? DateFormat('dd MMM yyyy').format(dt) : '';
                    final jam = dt != null ? DateFormat('HH:mm').format(dt) : '';
                    return ListTile(
                      title: Text(act['title'] ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (desc.isNotEmpty) Text(desc, style: const TextStyle(fontSize: 13)),
                          if (tanggal.isNotEmpty || jam.isNotEmpty)
                            Text(
                              tanggal.isNotEmpty && jam.isNotEmpty
                                  ? '$tanggal • $jam'
                                  : tanggal + jam,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                        ],
                      ),
                      trailing: Checkbox(
                        value: act['is_completed'] ?? false,
                        onChanged: (val) async {
                          await supabase
                              .from('activities')
                              .update({'is_completed': val})
                              .eq('id', act['id']);
                          _fetchActivities();
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add');
          if (result == true) {
            _fetchActivities();
          }
        },
        tooltip: 'Tambah Aktivitas',
        child: const Icon(Icons.add),
      ),
    );
  }
}
