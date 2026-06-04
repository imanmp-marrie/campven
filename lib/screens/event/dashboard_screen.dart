import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../models/event_model.dart';
import 'add_event_screen.dart';
import 'edit_event_screen.dart';
import 'detail_event_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Campven',
          style: TextStyle(
              color: Color(0xFF1A6BFF),
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Color(0xFF1A1A2E)),
            onPressed: () {},
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey.shade300,
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
            // Header
            const Text(
              'Ringkasan Dashboard',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 4),
            const Text(
              'Berikut adalah statistik performa event Anda.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            // Stats cards
            Consumer<EventProvider>(
              builder: (context, provider, _) {
                return Column(
                  children: [
                    _buildStatCard(
                      'Total Event',
                      '${provider.events.length}',
                      '+12% dari bulan lalu',
                      Icons.calendar_month_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      'Total Peserta',
                      '${provider.events.length * 50}',
                      '+5% dari bulan lalu',
                      Icons.people_outline,
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      'Event Aktif',
                      '${provider.events.length}',
                      'Pendaftaran dibuka',
                      Icons.event_available_outlined,
                      showTrend: false,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            // Event terbaru
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Event Terbaru Saya',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Text('Lihat Semua',
                      style: TextStyle(color: Color(0xFF1A6BFF))),
                  label: const Icon(Icons.arrow_forward,
                      color: Color(0xFF1A6BFF), size: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Consumer<EventProvider>(
              builder: (context, provider, _) {
                if (provider.events.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text('Belum ada event',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.events.length > 3
                      ? 3
                      : provider.events.length,
                  itemBuilder: (context, index) {
                    return _buildEventCard(
                        context, provider.events[index]);
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            // Aksi Cepat
            const Text(
              'Aksi Cepat',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: [
                _buildQuickAction(
                  context,
                  'Buat Event',
                  Icons.add_circle_outline,
                  const Color(0xFF1A6BFF),
                  Colors.white,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddEventScreen()),
                  ),
                ),
                _buildQuickAction(
                  context,
                  'Laporan',
                  Icons.bar_chart_outlined,
                  Colors.white,
                  const Color(0xFF1A1A2E),
                  () {},
                ),
                _buildQuickAction(
                  context,
                  'Presensi QR',
                  Icons.qr_code_2_outlined,
                  Colors.white,
                  const Color(0xFF1A1A2E),
                  () {},
                ),
                _buildQuickAction(
                  context,
                  'Broadcasting',
                  Icons.campaign_outlined,
                  Colors.white,
                  const Color(0xFF1A1A2E),
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEventScreen()),
        ),
        backgroundColor: const Color(0xFF1A6BFF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon, {
    bool showTrend = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04), blurRadius: 8)
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A6BFF)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (showTrend)
                      const Icon(Icons.trending_up,
                          color: Colors.green, size: 14),
                    const SizedBox(width: 4),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 12,
                            color: showTrend
                                ? Colors.green
                                : Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF3FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF1A6BFF), size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, EventModel event) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => DetailEventScreen(event: event)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A6BFF), Color(0xFF0A3D9E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)),
                  ),
                  child: const Center(
                    child: Icon(Icons.event,
                        size: 40, color: Colors.white54),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event.category,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A6BFF)),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 13, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(event.date,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on_outlined,
                          size: 13, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(event.location,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Color(0xFFEEF3FF),
                            child: Icon(Icons.person,
                                size: 14, color: Color(0xFF1A6BFF)),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      const Text('+0',
                          style: TextStyle(
                              color: Colors.grey, fontSize: 12)),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  EditEventScreen(event: event)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A6BFF),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Kelola',
                            style: TextStyle(
                                color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String label,
    IconData icon,
    Color bgColor,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05), blurRadius: 8)
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}