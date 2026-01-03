import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/supabase_service.dart';
import '../../providers/app_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          userAsync.when(
            data: (user) => UserAccountsDrawerHeader(
              accountName: Text(user?.fullName ?? 'User'),
              accountEmail: Text(user?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  (user?.fullName ?? 'U').substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox(),
          ),
          
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Subscription Status'),
            subtitle: userAsync.when(
              data: (user) {
                if (user?.isPremium == true) return const Text('Premium Member', style: TextStyle(color: Colors.amber));
                return Text('Trial Active (${user?.trialDaysRemaining ?? 0} days left)');
              },
              loading: () => const Text('Loading...'),
              error: (_, __) => const Text('Unknown'),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/premium'),
          ),
          
          const Divider(),
          
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await SupabaseService().signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
