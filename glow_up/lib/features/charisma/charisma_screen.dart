import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/app_provider.dart';
import '../../services/supabase_service.dart';

class CharismaScreen extends ConsumerWidget {
  const CharismaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasAccess = ref.watch(hasAccessProvider);

    if (!hasAccess) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(LucideIcons.lock, size: 64, color: Colors.grey),
                const SizedBox(height: 24),
                Text(
                  'Premium Feature',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Unlock the Charisma Trainer to build social confidence and master interactions.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => context.push('/premium'),
                  child: const Text('Upgrade to Unlock'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final challenges = [
      {'id': 'c1', 'title': 'Eye Contact', 'desc': 'Make eye contact with 3 strangers today.'},
      {'id': 'c2', 'title': 'The Compliment', 'desc': 'Give a genuine compliment to someone.'},
      {'id': 'c3', 'title': 'Small Talk', 'desc': 'Start a conversation with a barista or cashier.'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Charisma Trainer')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(challenge['title']!, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(challenge['desc']!),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Mark Complete'),
                    onPressed: () async {
                       await SupabaseService().completeCharismaChallenge(challenge['id']!);
                       if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Challenge Completed!')));
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
