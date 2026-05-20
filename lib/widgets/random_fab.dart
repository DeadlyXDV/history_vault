import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/random_provider.dart';

class RandomFab extends StatelessWidget {
  const RandomFab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RandomProvider>();

    return FloatingActionButton.extended(
      onPressed: provider.isLoading
          ? null
          : () async {
              final article = await context
                  .read<RandomProvider>()
                  .fetchRandom();
              if (article == null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to load random article.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              if (context.mounted) {
                context.push(
                  '/detail/${Uri.encodeComponent(article!.title)}',
                  extra: article,
                );
              }
            },
      tooltip: 'Random Article',
      label: const Text('Random'),
      icon: provider.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(Icons.shuffle),
    );
  }
}
