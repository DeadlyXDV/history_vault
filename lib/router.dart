import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'models/article_model.dart';
import 'screens/home_screen.dart';
import 'screens/timeline_screen.dart';
import 'screens/search_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/favorites_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNav(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/timeline',
          builder: (context, state) => const TimelineScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoritesScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/detail/:title',
      builder: (context, state) {
        final title = state.pathParameters['title']!;
        final extra = state.extra as ArticleModel?;
        return DetailScreen(title: title, preloaded: extra);
      },
    ),
  ],
);

class ScaffoldWithNav extends StatelessWidget {
  const ScaffoldWithNav({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final idx = _locationIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE8E0D5), width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: idx,
          onDestinationSelected: (i) => _onTap(context, i),
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF7C3A19).withValues(alpha: 0.12),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.today), label: 'Today'),
            NavigationDestination(icon: Icon(Icons.timeline), label: 'Timeline'),
            NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
            NavigationDestination(icon: Icon(Icons.bookmark), label: 'Favorites'),
          ],
        ),
      ),
    );
  }

  int _locationIndex(String loc) {
    if (loc.startsWith('/timeline')) return 1;
    if (loc.startsWith('/search')) return 2;
    if (loc.startsWith('/favorites')) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int i) {
    const routes = ['/home', '/timeline', '/search', '/favorites'];
    context.go(routes[i]);
  }
}
