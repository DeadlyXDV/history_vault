import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';
import '../widgets/article_card.dart';
import '../widgets/random_fab.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _showSuggestions = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search History'),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButton: const RandomFab(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Search people, places, events...',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          _controller.clear();
                          setState(() {});
                          context.read<SearchProvider>().clearSuggestions();
                        },
                      )
                    : null,
              ),
              onChanged: (q) {
                setState(() {});
                context.read<SearchProvider>().onQueryChanged(q);
              },
              onSubmitted: (q) {
                _focusNode.unfocus();
                context.read<SearchProvider>().search(q);
              },
            ),
          ),
          if (_showSuggestions && provider.suggestions.isNotEmpty)
            _SuggestionDropdown(
              suggestions: provider.suggestions.map((s) => s.title).toList(),
              onTap: (title) {
                _controller.text = title;
                _focusNode.unfocus();
                context.read<SearchProvider>().clearSuggestions();
                context.push('/detail/${Uri.encodeComponent(title)}');
              },
            ),
          Expanded(child: _buildResults(provider)),
        ],
      ),
    );
  }

  Widget _buildResults(SearchProvider provider) {
    if (provider.isLoadingResults) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error.isNotEmpty) {
      return Center(
        child: _EmptyState(
          icon: Icons.error_outline,
          title: 'Search Error',
          subtitle: provider.error,
        ),
      );
    }
    if (provider.results.isEmpty) {
      return Center(
        child: _EmptyState(
          icon: Icons.search,
          title: 'Search for people, places, or events',
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
      itemCount: provider.results.length,
      itemBuilder: (_, i) => ArticleCard.fromSearchResult(provider.results[i]),
    );
  }
}

class _SuggestionDropdown extends StatelessWidget {
  const _SuggestionDropdown({required this.suggestions, required this.onTap});
  final List<String> suggestions;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: suggestions
            .map(
              (s) => ListTile(
                leading: const Icon(
                  Icons.schedule,
                  size: 18,
                  color: Color(0xFF9CA3AF),
                ),
                title: Text(
                  s,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onTap: () => onTap(s),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
              ),
            )
            .toList(),
      ),
    );
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
