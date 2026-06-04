import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../models/event_model.dart';
import '../../services/auth_service.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  String _selectedCategory = 'Seminar';
  bool _isLoading = false;

  final List<String> _categories = [
    'Seminar', 'Workshop', 'Lomba', 'Pertunjukan', 'Olahraga', 'Lainnya',
  ];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF1A6BFF)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            '${picked.day} ${_monthName(picked.month)} ${picked.year}';
      });
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month - 1];
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    final location = _locationController.text.trim();
    final date = _dateController.text.trim();

    if (title.isEmpty || desc.isEmpty || location.isEmpty || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authService = AuthService();
    final userName = await authService.getUserName();

    final event = EventModel(
      id: '',
      title: title,
      description: desc,
      location: location,
      date: date,
      category: _selectedCategory,
      createdBy: userName,
    );

    await Provider.of<EventProvider>(context, listen: false).addEvent(event);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event berhasil ditambahkan!')),
    );
    Navigator.pop(context);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Event',
          style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.bold),
        ),
        actions: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.person, color: Colors.grey, size: 20),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload poster
            const Text('Poster Event',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: const Color(0xFF1A6BFF).withOpacity(0.4),
                    style: BorderStyle.solid,
                    width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF3FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add_a_photo_outlined,
                        color: Color(0xFF1A6BFF), size: 28),
                  ),
                  const SizedBox(height: 10),
                  const Text('Unggah Foto atau Poster',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E))),
                  const Text('Maks. 5MB (JPG, PNG)',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Nama Event
            _buildLabel('Nama Event'),
            _buildTextField(
              controller: _titleController,
              hint: 'Contoh: Seminar Karier Teknologi 2024',
            ),
            const SizedBox(height: 16),
            // Kategori
            _buildLabel('Kategori'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  hint: const Text('Pilih Kategori'),
                  items: _categories.map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
                  onChanged: (val) =>
                      setState(() => _selectedCategory = val!),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Tanggal
            _buildLabel('Tanggal'),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        color: Color(0xFF1A6BFF), size: 18),
                    const SizedBox(width: 10),
                    Text(
                      _dateController.text.isEmpty
                          ? 'mm/dd/yyyy'
                          : _dateController.text,
                      style: TextStyle(
                        color: _dateController.text.isEmpty
                            ? Colors.grey
                            : const Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Lokasi
            _buildLabel('Lokasi'),
            _buildTextField(
              controller: _locationController,
              hint: 'Gedung Rektorat Lt. 3 atau Zoom Meeting',
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 16),
            // Deskripsi
            _buildLabel('Deskripsi'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Jelaskan detail event, agenda, dan persyaratan peserta...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Tombol simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6BFF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan Event',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            // Batalkan
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batalkan',
                    style: TextStyle(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          prefixIcon: icon != null
              ? Icon(icon, color: const Color(0xFF1A6BFF), size: 18)
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}