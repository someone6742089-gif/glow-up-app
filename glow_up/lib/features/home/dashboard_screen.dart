import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/app_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              userAsync.when(
                data: (user) => Text(
                  'Welcome back, ${user?.fullName ?? 'King'}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                loading: () => const Text('Loading...'),
                error: (_, __) => const Text('Welcome'),
              ),
              const SizedBox(height: 24),
              
              // Quote
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                      Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    const Icon(LucideIcons.quote, size: 32, color: Colors.white70),
                    const SizedBox(height: 12),
                    Text(
                      '"We suffer more often in imagination than in reality."',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '- Seneca',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white54),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              Text('Your Tools', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _DashboardCard(
                    icon: LucideIcons.camera,
                    title: 'Looksmaxxing',
                    subtitle: 'AI Face Analysis',
                    color: Colors.blue,
                    onTap: () => context.go('/home/looks'),
                  ),
                  _DashboardCard(
                    icon: LucideIcons.zap,
                    title: 'Charisma',
                    subtitle: 'Social Challenges',
                    color: Colors.purple,
                    onTap: () => context.go('/home/charisma'),
                  ),
                  _DashboardCard(
                    icon: LucideIcons.checkCircle,
                    title: 'Habits',
                    subtitle: 'Track Daily Wins',
                    color: Colors.green,
                    onTap: () => context.go('/home/habits'),
                  ),
                  _DashboardCard(
                    icon: LucideIcons.crown,
                    title: 'Premium',
                    subtitle: 'Unlock Everything',
                    color: Colors.amber,
                    onTap: () => context.push('/premium'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}