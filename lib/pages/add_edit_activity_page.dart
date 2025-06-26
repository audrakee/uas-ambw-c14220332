import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class AddEditActivityPage extends StatefulWidget {
  const AddEditActivityPage({super.key});

  @override
  State<AddEditActivityPage> createState() => _AddEditActivityPageState();
}

class _AddEditActivityPageState extends State<AddEditActivityPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDateTime;
  bool _saving = false;
  String? _error;

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty || _selectedDateTime == null) {
      setState(() => _error = 'Judul dan waktu wajib diisi.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User tidak ditemukan');
      await Supabase.instance.client.from('activities').insert({
        'title': _titleController.text.trim(),
        'description': _descController.text.trim(),
        'schedule_time': _selectedDateTime!.toIso8601String(),
        'user_id': user.id,
        'is_completed': false,
      });
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _error = 'Gagal menyimpan aktivitas.');
    } finally {
      setState(() => _saving = false);
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Aktivitas')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(_selectedDateTime == null
                      ? 'Pilih waktu'
                      : DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!)),
                ),
                TextButton(
                  onPressed: _pickDateTime,
                  child: const Text('Pilih'),
                ),
              ],
            ),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const CircularProgressIndicator()
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
