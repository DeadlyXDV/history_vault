import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../widgets/article_card.dart';
import '../widgets/random_fab.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline Explorer'),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButton: const RandomFab(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter a year (e.g. 1969)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today, size: 20),
                    ),
                    onSubmitted: (_) => _explore(context),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.search, size: 18),
                  label: const Text('Explore'),
                  onPressed: () => _explore(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildResults(provider)),
        ],
      ),
    );
  }

  void _explore(BuildContext context) {
    final year = _controller.text.trim();
    if (year.isEmpty) return;
    context.read<HistoryProvider>().fetchTimeline(year);
  }

  Widget _buildResults(HistoryProvider provider) {
    switch (provider.timelineState) {
      case LoadState.idle:
        return Center(
          child: _EmptyState(
            icon: Icons.timeline,
            title: 'Enter a year to explore history',
          ),
        );
      case LoadState.loading:
        return const Center(child: CircularProgressIndicator());
      case LoadState.error:
        return Center(
          child: _EmptyState(
            icon: Icons.error_outline,
            title: 'Error Loading Timeline',
            subtitle: provider.timelineError,
          ),
        );
      case LoadState.loaded:
        if (provider.timelineResults.isEmpty) {
          return Center(
            child: _EmptyState(
              icon: Icons.search_off,
              title: 'No results found',
              subtitle: 'Try a different year',
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
          itemCount: provider.timelineResults.length,
          itemBuilder: (_, i) =>
              ArticleCard.fromSearchResult(provider.timelineResults[i]),
        );
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.title, this.subtitle});

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF9CA3AF),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}
