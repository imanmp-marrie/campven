import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Events', 'Updates', 'System'];

  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'New Event: CS Symposium 2024',
      'body': 'Registration is now open for the annual Computer Science Symposium. Secure your spot before slots fill up!',
      'time': '2m ago',
      'tag': 'Workshop',
      'icon': Icons.event,
      'color': Color(0xFF1A6BFF),
      'isRead': false,
      'group': 'TODAY',
    },
    {
      'title': 'Registration Confirmed',
      'body': 'You\'ve successfully registered for the "Campus Eco-Walk" scheduled for next Friday.',
      'time': '1h ago',
      'tag': null,
      'icon': Icons.person_add_outlined,
      'color': Color(0xFF1A6BFF),
      'isRead': false,
      'group': 'TODAY',
    },
    {
      'title': 'System Update Complete',
      'body': 'Campven v2.4 is now live. Check out the new calendar integration features in your profile settings.',
      'time': '1d ago',
      'tag': null,
      'icon': Icons.refresh,
      'color': Colors.grey,
      'isRead': true,
      'group': 'YESTERDAY',
    },
    {
      'title': 'Security Alert',
      'body': 'Your password was successfully changed from a desktop device in "Engineering Hall L3".',
      'time': '1d ago',
      'tag': null,
      'icon': Icons.shield_outlined,
      'color': Colors.grey,
      'isRead': true,
      'group': 'YESTERDAY',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final n in _notifications) {
      final g = n['group'] as String;
      grouped.putIfAbsent(g, () => []).add(n);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A6BFF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifications',
            style: TextStyle(
                color: Color(0xFF1A6BFF), fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: Color(0xFF1A6BFF)),
            onPressed: () => setState(() {
              for (final n in _notifications) n['isRead'] = true;
            }),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF1A6BFF)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final selected = _selectedFilter == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF1A6BFF) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(_filters[index],
                          style: TextStyle(
                              color: selected ? Colors.white : Colors.grey.shade700,
                              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 13)),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(entry.key,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1)),
                    ),
                    ...entry.value.map((n) => _buildNotifCard(n)),
                    const SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotifCard(Map<String, dynamic> n) {
    final isRead = n['isRead'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isRead ? null : Border(left: BorderSide(color: n['color'] as Color, width: 3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (n['color'] as Color).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(n['icon'] as IconData, color: n['color'] as Color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(n['title'] as String,
                            style: TextStyle(
                                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                fontSize: 14,
                                color: isRead ? Colors.grey : const Color(0xFF1A1A2E))),
                      ),
                      Text(n['time'] as String,
                          style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(n['body'] as String,
                      style: TextStyle(
                          color: isRead ? Colors.grey : Colors.grey.shade700,
                          fontSize: 12,
                          height: 1.4)),
                  if (n['tag'] != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(n['tag'] as String,
                          style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// NotificationScreen - v1.0
