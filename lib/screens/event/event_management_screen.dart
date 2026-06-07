import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../models/event_model.dart';
import 'add_event_screen.dart';
import 'edit_event_screen.dart';
import 'participant_screen.dart';

class EventManagementScreen extends StatelessWidget {
  const EventManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A6BFF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Campven',
            style: TextStyle(color: Color(0xFF1A6BFF), fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Color(0xFF1A6BFF)), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<EventProvider>(
                  builder: (context, provider, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Manage Events',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text('You have ${provider.events.length} active events this week.',
                          style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AddEventScreen())),
                  icon: const Icon(Icons.add, color: Colors.white, size: 16),
                  label: const Text('Create\nEvent',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A6BFF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: const Color(0xFF1A6BFF), borderRadius: BorderRadius.circular(16)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TOTAL ENGAGEMENT',
                          style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1)),
                      Icon(Icons.trending_up, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('2,840',
                      style: TextStyle(
                          color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                  Text('+12.5% from last month',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pending Approvals', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 4),
                      Text('12', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      Text('Review required', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.pending_actions, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Consumer<EventProvider>(
              builder: (context, provider, _) {
                if (provider.events.isEmpty) {
                  return const Center(
                      child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text('Belum ada event',
                              style: TextStyle(color: Colors.grey))));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.events.length,
                  itemBuilder: (context, index) =>
                      _buildManageCard(context, provider, provider.events[index]),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AddEventScreen())),
        backgroundColor: const Color(0xFF1A6BFF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildManageCard(BuildContext context, EventProvider provider, EventModel event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF1A6BFF), Color(0xFF0A3D9E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: const Center(child: Icon(Icons.event, size: 40, color: Colors.white54)),
              ),
              Positioned(
                top: 10, left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(event.category,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1A6BFF))),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(event.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                    Row(children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Color(0xFF1A6BFF), size: 20),
                        onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => EditEventScreen(event: event))),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Hapus Event'),
                              content: const Text('Yakin ingin menghapus event ini?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Batal')),
                                TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Hapus',
                                        style: TextStyle(color: Colors.red))),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            if (!context.mounted) return;
                            await provider.deleteEvent(event.id.toString());
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ]),
                  ],
                ),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(event.date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ]),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ParticipantScreen(event: event))),
                  child: Row(children: [
                    _buildStat('Views', '1.2k'),
                    const SizedBox(width: 20),
                    _buildStat('RSVP', '450'),
                    const SizedBox(width: 20),
                    _buildStatusBadge('LIVE'),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        Text(value,
            style: const TextStyle(
                color: Color(0xFF1A6BFF), fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status == 'LIVE' ? const Color(0xFFEEF3FF) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(status,
          style: TextStyle(
              color: status == 'LIVE' ? const Color(0xFF1A6BFF) : Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.bold)),
    );
  }
}