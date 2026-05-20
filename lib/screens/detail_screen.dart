import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article_model.dart';
import '../providers/favorites_provider.dart';
import '../providers/random_provider.dart';
import '../services/wikipedia_service.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.title, this.preloaded});
  final String title;
  final ArticleModel? preloaded;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  ArticleModel? _article;
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    if (widget.preloaded != null) {
      _article = widget.preloaded;
      _fetchFull();
    } else {
      _fetchFull();
    }
  }

  Future<void> _fetchFull() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final article = await WikipediaService().fetchPageSummary(widget.title);
      setState(() => _article = article);
    } catch (_) {
      if (_article == null) {
        setState(
          () => _error = 'Failed to load article. Check your connection.',
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavoritesProvider>();
    final randomProvider = context.watch<RandomProvider>();
    final article = _article;
    final isFav = article != null && favs.isFavorite(article.title);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          article?.title ?? widget.title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (article != null)
            IconButton(
              icon: AnimatedScale(
                scale: isFav ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  isFav ? Icons.bookmark : Icons.bookmark_border,
                  color: isFav
                      ? const Color(0xFF10B981)
                      : const Color(0xFF9CA3AF),
                ),
              ),
              tooltip: isFav ? 'Remove from favorites' : 'Save to favorites',
              onPressed: () {
                if (isFav) {
                  favs.remove(article.title);
                } else {
                  favs.add(article);
                }
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: randomProvider.isLoading
            ? null
            : () async {
                final newArticle = await context
                    .read<RandomProvider>()
                    .fetchRandom();
                if (newArticle == null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to load random article.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                if (context.mounted && newArticle != null) {
                  setState(() {
                    _article = newArticle;
                    _isLoading = false;
                    _error = '';
                  });
                }
              },
        tooltip: 'Random Article',
        label: const Text('Random'),
        icon: randomProvider.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.shuffle),
      ),
      body: _buildBody(article),
    );
  }

  Widget _buildBody(ArticleModel? article) {
    if (_error.isNotEmpty && article == null) {
      return Center(
        child: _EmptyState(
          icon: Icons.error_outline,
          title: 'Error Loading Article',
          subtitle: _error,
        ),
      );
    }

    if (article == null) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1F2937)),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (article.thumbnailUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: article.thumbnailUrl!,
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox(
                  height: 240,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF1F2937),
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 240,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.history,
                      size: 64,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),
          Text(
            article.title,
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 28),
          ),
          const SizedBox(height: 16),
          Text(
            article.extract,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(height: 1.7, fontSize: 16),
          ),
          const SizedBox(height: 32),
          if (article.wikiUrl.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.open_in_browser, size: 18),
                label: const Text('Read on Wikipedia'),
                onPressed: () => _launchUrl(article.wikiUrl),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: LinearProgressIndicator(
                color: Color(0xFF1F2937),
                backgroundColor: Color(0x147C3A19),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open URL.')));
      }
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
