import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../services/auth_service.dart';
import '../../services/fcm_service.dart';
import '../../models/event_model.dart';
import '../auth/login_screen.dart';
import '../profile/profile_screen.dart';
import 'add_event_screen.dart';
import 'detail_event_screen.dart';
import 'my_events_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  String _userName = '';
  int _selectedIndex = 0;
  int _selectedCategory = 0;
  bool _isLoading = true;

  final List<String> _categories = [
    'Semua', 'Workshop', 'Seminar', 'Lomba', 'Seni'
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadEvents();
    FCMService.initialize(context);
  }

  Future<void> _loadUser() async {
    final name = await _authService.getUserName();
    setState(() => _userName = name);
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    Provider.of<EventProvider>(context, listen: false).fetchEvents();
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout, color: Colors.grey, size: 32),
            ),
            const SizedBox(height: 16),
            const Text('Konfirmasi Logout',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Yakin ingin keluar dari akun Anda?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx, false),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Batal'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6BFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Keluar',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
    if (confirm == true) {
      await _authService.logout();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: _selectedIndex == 0
            ? _buildHome()
            : _selectedIndex == 1
                ? _buildEventsPage()
                : _selectedIndex == 2
                    ? const MyEventsScreen()
                    : const ProfileScreen(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEventScreen()),
        ),
        backgroundColor: const Color(0xFF1A6BFF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHome() {
    if (_isLoading) return _buildSkeleton();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildCategoryChips(),
          _buildFeaturedSection(),
          _buildUpcomingGrid(),
          _buildAllEvents(),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmer(height: 20, width: 160),
          const SizedBox(height: 16),
          _shimmer(height: 50, width: double.infinity),
          const SizedBox(height: 16),
          Row(children: [
            _shimmer(height: 36, width: 80),
            const SizedBox(width: 8),
            _shimmer(height: 36, width: 100),
            const SizedBox(width: 8),
            _shimmer(height: 36, width: 80),
          ]),
          const SizedBox(height: 16),
          _buildSkeletonCard(showButton: true),
          const SizedBox(height: 12),
          _buildSkeletonCard(),
          const SizedBox(height: 12),
          _buildSkeletonCard(),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard({bool showButton = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _shimmer(height: 70, width: 70),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmer(height: 12, width: 100),
                const SizedBox(height: 8),
                _shimmer(height: 14, width: 160),
                const SizedBox(height: 8),
                _shimmer(height: 12, width: 120),
                if (showButton) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _shimmer(height: 32, width: 80),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmer({required double height, required double width}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, color: Colors.grey),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Halo,',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    '$_userName!',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF1A6BFF), size: 26),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _logout,
                child: const Icon(Icons.logout, color: Colors.grey, size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari event kampus...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final selected = _selectedCategory == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = index),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF1A6BFF) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF1A6BFF)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  _categories[index],
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.grey.shade700,
                    fontWeight:
                        selected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Unggulan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton(
                onPressed: () {},
                child: const Text('Lihat Semua',
                    style: TextStyle(color: Color(0xFF1A6BFF))),
              ),
            ],
          ),
          Consumer<EventProvider>(
            builder: (context, provider, _) {
              if (provider.events.isEmpty) {
                return Container(
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A6BFF), Color(0xFF0A3D9E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('Belum ada event unggulan',
                        style: TextStyle(color: Colors.white)),
                  ),
                );
              }
              return SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.events.length > 3
                      ? 3
                      : provider.events.length,
                  itemBuilder: (context, index) {
                    return _buildFeaturedCard(provider.events[index], index);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(EventModel event, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailEventScreen(event: event)),
      ),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: index == 0
                ? [const Color(0xFF1A6BFF), const Color(0xFF0A3D9E)]
                : [Colors.blueGrey.shade700, Colors.blueGrey.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                index == 0 ? 'TERBARU' : 'PILIHAN',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${event.location} • ${event.date}',
              style: const TextStyle(color: Colors.white70, fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Mendatang',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton(
                onPressed: () {},
                child: const Text('Lihat Semua',
                    style: TextStyle(color: Color(0xFF1A6BFF))),
              ),
            ],
          ),
          Consumer<EventProvider>(
            builder: (context, provider, _) {
              if (provider.events.isEmpty) return const SizedBox.shrink();
              final items = provider.events.length > 4
                  ? provider.events.sublist(0, 4)
                  : provider.events;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final event = items[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailEventScreen(event: event)),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8)
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.date.split(' ').first,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A6BFF),
                            ),
                          ),
                          Text(
                            event.date.split(' ').length > 1
                                ? event.date.split(' ')[1]
                                : '',
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF1A6BFF)),
                          ),
                          const Spacer(),
                          Text(
                            event.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 11, color: Colors.grey),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  event.location,
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAllEvents() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Semua Event',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton(
                onPressed: () {},
                child: const Text('Lihat Semua',
                    style: TextStyle(color: Color(0xFF1A6BFF))),
              ),
            ],
          ),
          Consumer<EventProvider>(
            builder: (context, provider, _) {
              if (provider.events.isEmpty) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF3FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.folder_open_outlined,
                            size: 64, color: Color(0xFF1A6BFF)),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Text(
                          'NO EVENTS FOUND',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A6BFF),
                            fontSize: 13,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Belum ada event tersedia',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Coba cek kembali nanti ya!',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.events.length,
                itemBuilder: (context, index) {
                  return _buildEventListCard(provider.events[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventListCard(EventModel event) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailEventScreen(event: event)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04), blurRadius: 8)
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.event, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.category.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF1A6BFF),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(event.date,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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

  Widget _buildEventsPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Semua Event',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const Icon(Icons.search, color: Color(0xFF1A6BFF), size: 26),
            ],
          ),
        ),
        Expanded(
          child: Consumer<EventProvider>(
            builder: (context, provider, _) {
              if (provider.events.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF3FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.folder_open_outlined,
                            size: 64, color: Color(0xFF1A6BFF)),
                      ),
                      const SizedBox(height: 16),
                      const Text('NO EVENTS FOUND',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A6BFF),
                              letterSpacing: 1)),
                      const SizedBox(height: 8),
                      const Text('Belum ada event tersedia',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.events.length,
                itemBuilder: (context, index) {
                  return _buildEventListCard(provider.events[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08), blurRadius: 10)
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1A6BFF),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _selectedIndex == 0
                    ? const Color(0xFF1A6BFF)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.home_rounded,
                  color: _selectedIndex == 0 ? Colors.white : Colors.grey),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _selectedIndex == 1
                    ? const Color(0xFF1A6BFF)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.event_outlined,
                  color: _selectedIndex == 1 ? Colors.white : Colors.grey),
            ),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _selectedIndex == 2
                    ? const Color(0xFF1A6BFF)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.event_available_outlined,
                  color: _selectedIndex == 2 ? Colors.white : Colors.grey),
            ),
            label: 'My Events',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _selectedIndex == 3
                    ? const Color(0xFF1A6BFF)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.person_outline,
                  color: _selectedIndex == 3 ? Colors.white : Colors.grey),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}