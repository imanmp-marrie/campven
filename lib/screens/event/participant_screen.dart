import 'package:flutter/material.dart';
import '../../models/event_model.dart';

class ParticipantScreen extends StatelessWidget {
  final EventModel event;
  const ParticipantScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final participants = [
      {'name': 'Jane Doe', 'email': 'jane.doe@university.edu', 'initials': 'JD', 'status': 'Confirmed', 'color': const Color(0xFF1A6BFF)},
      {'name': 'Mark Spencer', 'email': 'm.spencer@college.org', 'initials': 'MS', 'status': 'Waitlisted', 'color': Colors.grey},
      {'name': 'Sarah Connor', 'email': 'sarah.c@tech.edu', 'initials': 'SC', 'status': 'Confirmed', 'color': const Color(0xFF1A6BFF)},
      {'name': 'Alex Lee', 'email': 'alex.lee@univ.ca', 'initials': 'AL', 'status': 'Canceled', 'color': Colors.red},
    ];

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
            Row(children: [
              const Text('Events', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
              const Text('Participant List',
                  style: TextStyle(color: Color(0xFF1A6BFF), fontSize: 13)),
            ]),
            const SizedBox(height: 12),
            Text(event.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey),
              const SizedBox(width: 4),
              Text(event.date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const Text(' • ', style: TextStyle(color: Colors.grey)),
              const Icon(Icons.location_on_outlined, size: 13, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                  child: Text(event.location,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, color: Colors.white, size: 16),
                label: const Text('Invite', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A6BFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_outlined, size: 16, color: Color(0xFF1A1A2E)),
                label: const Text('Export CSV', style: TextStyle(color: Color(0xFF1A1A2E))),
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(color: Colors.grey.shade300)),
              ),
            ]),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: const Row(children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by name, email, or department...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.tune, color: Colors.grey, size: 18),
                  SizedBox(width: 8),
                  Text('Filters', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2,
              children: [
                _buildStatCard('Total Registered', '124', highlight: true),
                _buildStatCard('Confirmed', '98'),
                _buildStatCard('Waitlist', '15'),
                _buildStatCard('No Shows', '11'),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(children: const [
                      Expanded(child: Text('PARTICIPANT',
                          style: TextStyle(color: Colors.grey, fontSize: 11,
                              fontWeight: FontWeight.bold, letterSpacing: 1))),
                      Text('STATUS',
                          style: TextStyle(color: Colors.grey, fontSize: 11,
                              fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ]),
                  ),
                  const Divider(height: 1),
                  ...participants.map((p) => _buildParticipantRow(p)),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Showing 4 of 124 participants',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(6)),
                            child: const Icon(Icons.chevron_left, size: 18, color: Colors.grey),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(6)),
                            child: const Icon(Icons.chevron_right, size: 18, color: Color(0xFF1A1A2E)),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF1A6BFF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, {bool highlight = false}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFEEF3FF) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: highlight ? Border.all(color: const Color(0xFF1A6BFF).withOpacity(0.3)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: TextStyle(
                  color: highlight ? const Color(0xFF1A6BFF) : Colors.grey,
                  fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold,
                  color: highlight ? const Color(0xFF1A6BFF) : const Color(0xFF1A1A2E))),
        ],
      ),
    );
  }

  Widget _buildParticipantRow(Map<String, dynamic> p) {
    final color = p['color'] as Color;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: color.withOpacity(0.1),
                child: Text(p['initials'] as String,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p['name'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    Text(p['email'] as String,
                        style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
              Row(children: [
                Icon(Icons.circle, size: 8, color: color),
                const SizedBox(width: 4),
                Text(p['status'] as String,
                    style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
              ]),
            ],
          ),
        ),
        const Divider(height: 1, indent: 16),
      ],
    );
  }
}