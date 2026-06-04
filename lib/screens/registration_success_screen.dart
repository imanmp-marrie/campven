import 'package:flutter/material.dart';
import '../models/event_model.dart';
import 'event/home_screen.dart';
import 'event/my_events_screen.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  final EventModel event;
  const RegistrationSuccessScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Campven',
            style: TextStyle(color: Color(0xFF1A6BFF), fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                      color: const Color(0xFF1A6BFF).withOpacity(0.1),
                      shape: BoxShape.circle),
                ),
                Container(
                  width: 80, height: 80,
                  decoration: const BoxDecoration(
                      color: Color(0xFF1A6BFF), shape: BoxShape.circle),
                  child: const Icon(Icons.check, color: Colors.white, size: 40),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text("You're in!",
                style: TextStyle(
                    fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 12),
            const Text(
                'Your registration for the upcoming event has been successfully confirmed. We\'ve sent a ticket to your university email.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFF1A6BFF), Color(0xFF0A3D9E)]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.event, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.category.toUpperCase(),
                                style: const TextStyle(
                                    color: Color(0xFF1A6BFF),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                            Text(event.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Date',
                                style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Row(children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 13, color: Color(0xFF1A1A2E)),
                              const SizedBox(width: 4),
                              Text(event.date,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 13)),
                            ]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Time',
                                style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Row(children: [
                              Icon(Icons.access_time_outlined,
                                  size: 13, color: Color(0xFF1A1A2E)),
                              SizedBox(width: 4),
                              Text('09:00 AM',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 13)),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Location',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Row(children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: Color(0xFF1A1A2E)),
                        const SizedBox(width: 4),
                        Text(event.location,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13)),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const MyEventsScreen())),
                icon: const Icon(Icons.event_available, color: Colors.white),
                label: const Text('View My Events',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6BFF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()), (r) => false),
                icon: const Icon(Icons.home_outlined, color: Color(0xFF1A6BFF)),
                label: const Text('Back to Home',
                    style: TextStyle(color: Color(0xFF1A6BFF))),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  side: const BorderSide(color: Color(0xFF1A6BFF)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.info_outline, size: 16, color: Colors.grey),
              label: const Text('Add this to your Google Calendar?',
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}