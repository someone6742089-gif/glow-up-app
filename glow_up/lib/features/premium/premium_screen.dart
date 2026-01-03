import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  /*
  Future<void> _launchStripe() async {
    // Replace with real Stripe Payment Link
    final url = Uri.parse('https://buy.stripe.com/test_12345'); 
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      // In a real app, you'd use deep linking to return. 
      // Here we simulate return.
    }
  }
  */

  
  void _simulateSuccess(BuildContext context) {
    context.push('/payment_success');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upgrade to Premium')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(LucideIcons.crown, size: 80, color: Colors.amber),
            const SizedBox(height: 24),
            Text(
              'Unlock Your Potential',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Get unlimited access to Charisma Trainer, Advanced Looks Analysis, and more.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            _BenefitRow(text: 'Charisma Challenges'),
            _BenefitRow(text: 'Detailed Face Analysis'),
            _BenefitRow(text: 'Priority Support'),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _simulateSuccess(context), // _launchStripe in prod
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Upgrade for \$9.99/mo'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Maybe Later'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final String text;
  const _BenefitRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(height: 12),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
