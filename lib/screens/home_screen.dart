import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import '../providers/history_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/random_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'Place',
    'Person',
    'Discovery',
    'Event',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().fetchTodayEvents();
    });
  }

  List<EventModel> _getFilteredEvents(List<EventModel> events) {
    if (_selectedFilter == 'All') {
      return events;
    }
    return events.where((event) => event.category == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    final now = DateTime.now();
    final dateLabel = '${_monthName(now.month)} ${now.day} in History';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          dateLabel,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButton: const RandomFab(),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(HistoryProvider provider) {
    switch (provider.homeState) {
      case LoadState.loading:
        return const Center(child: CircularProgressIndicator());
      case LoadState.error:
        return Center(
          child: _EmptyState(
            icon: Icons.error_outline,
            title: 'Error Loading Events',
            subtitle: provider.homeError,
          ),
        );
      case LoadState.loaded:
        if (provider.todayEvents.isEmpty) {
          return Center(
            child: _EmptyState(
              icon: Icons.event_busy,
              title: 'No events found for today',
            ),
          );
        }

        final filteredEvents = _getFilteredEvents(provider.todayEvents);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filterOptions.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFF1F2937),
                        labelStyle: Theme.of(context).textTheme.labelLarge
                            ?.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF1F2937),
                            ),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF1F2937)
                              : const Color(0xFFE5E7EB),
                          width: 1.5,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: filteredEvents.isEmpty
                  ? Center(
                      child: _EmptyState(
                        icon: Icons.filter_alt_off,
                        title: 'No events found',
                        subtitle: 'Try a different filter',
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                      itemCount: filteredEvents.length,
                      itemBuilder: (_, i) =>
                          EventCard(event: filteredEvents[i]),
                    ),
            ),
          ],
        );
      case LoadState.idle:
        return const SizedBox.shrink();
    }
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.title, this.subtitle});

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final mutedText = const Color(0xFF9CA3AF);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF3F4F6),
          ),
          child: Icon(icon, size: 48, color: const Color(0xFF1F2937)),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              subtitle!,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: mutedText, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}
